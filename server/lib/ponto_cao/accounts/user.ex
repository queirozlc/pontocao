defmodule PontoCao.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoCommons.EmailValidator
  import EctoCommons.URLValidator

  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :avatar, :string
    field :website, :string
    field :social_links, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :bio, :avatar, :website, :social_links])
    |> validate_required([:name, :email, :bio])
    |> unique_constraint(:email)
    |> validate_email(:email, checks: [:check_mx_record])
    |> validate_url(:website, checks: [:path, :valid_host])
    |> validate_social_links
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
