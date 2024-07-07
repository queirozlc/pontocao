defmodule PontoCao.Users.User do
  alias PontoCao.Commons
  alias PontoCao.Announcements
  alias PontoCaoWeb.Uploaders.Avatar
  import Ecto.Changeset
  import EctoCommons.URLValidator
  import Waffle.Ecto.Schema
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    field :name, :string
    field :bio, :string
    field :avatar, Avatar.Type
    field :roles, {:array, Ecto.Enum}, values: ~w(ADOPTER DONOR)a, default: []
    field :phone, :string
    field :country, :string, virtual: true, default: "BR"
    field :social_links, {:array, :string}, default: []
    field :website, :string
    has_many :pets, Announcements.Pet, foreign_key: :owner_id
    has_many :events, Announcements.Event, foreign_key: :owner_id

    pow_user_fields()

    timestamps(type: :utc_datetime)
  end

  def profile_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :country, :bio, :website, :phone, :social_links])
    |> cast_attachments(attrs, [:avatar])
    |> validate_required([:name, :bio, :phone, :country])
    |> validate_url(:website, checks: [:path, :valid_host])
    |> Commons.Validations.Url.validate_urls(:social_links)
    |> validate_phone_number
  end

  def role_changeset(user, attrs) do
    user
    |> cast(attrs, [:roles])
    |> validate_required(:roles)
    |> validate_subset(:roles, [:ADOPTER, :DONOR])
  end

  defp validate_phone_number(changeset) do
    with {:ok, phone} <-
           ExPhoneNumber.parse(get_field(changeset, :phone), get_field(changeset, :country)) do
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
end