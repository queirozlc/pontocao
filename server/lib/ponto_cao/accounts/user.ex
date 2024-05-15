defmodule PontoCao.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoCommons.EmailValidator
  import EctoCommons.URLValidator
  alias PontoCao.Announcements

  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :avatar, :string
    field :website, :string
    field :phone, :string
    field :social_links, {:array, :string}
    field :roles, {:array, Ecto.Enum}, values: [:ADOPTER, :DONOR]
    has_many :pets, Announcements.Pet, foreign_key: :owner_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :bio, :avatar, :website, :social_links, :phone, :roles])
    |> validate_required([:name, :email, :bio, :phone, :roles])
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
    |> validate_email(:email, checks: [:check_mx_record])
    |> validate_url(:website, checks: [:path, :valid_host])
    |> validate_subset(:roles, [:ADOPTER, :DONOR])
    |> validate_social_links
    |> validate_phone_number(attrs["country"])
  end

  defp validate_phone_number(changeset, country) do
    with {:ok, phone} <- ExPhoneNumber.parse(get_field(changeset, :phone), country) do
      is_valid_phone_number?(changeset, phone)
    else
      {:error, reason} -> add_error(changeset, :phone, reason)
    end
  end

  defp is_valid_phone_number?(changeset, %ExPhoneNumber.Model.PhoneNumber{} = phone) do
    case ExPhoneNumber.is_valid_number?(phone) do
      true ->
        put_change(
          changeset,
          :phone,
          ExPhoneNumber.format(phone, :e164)
        )

      false ->
        add_error(changeset, :phone, "is invalid")
    end
  end

  defp validate_social_links(changeset) do
    case get_field(changeset, :social_links) do
      nil ->
        changeset

      links ->
        Enum.reduce(links, changeset, fn link, changeset ->
          is_valid_url?(link)
          |> case do
            nil -> changeset
            error -> add_error(changeset, :social_links, error)
          end
        end)
    end
  end

  defp is_valid_url?(url) do
    case URI.parse(url) do
      %URI{scheme: nil} ->
        "is missing a scheme (e.g. https)"

      %URI{host: nil} ->
        "is missing a host"

      %URI{host: host} ->
        case :inet.gethostbyname(Kernel.to_charlist(host)) do
          {:ok, _} -> nil
          {:error, _} -> "invalid host"
        end
    end
  end
end
