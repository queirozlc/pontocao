defmodule PontoCao.Accounts.User do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  import EctoCommons.EmailValidator
  import EctoCommons.URLValidator
  alias PontoCao.{Commons, Announcements}
  alias __MODULE__

  @type t :: Ecto.Changeset.t()

  @derive {Inspect, except: [:password, :hashed_password]}
  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :country, :string, virtual: true, default: "BR"
    field :hashed_password, :string, redact: true
    field :is_active, :boolean, default: false
    field :confirmed_at, :naive_datetime
    field :bio, :string
    field :avatar, PontoCaoWeb.Uploaders.Avatar.Type
    field :website, :string
    field :phone, :string
    field :social_links, {:array, :string}
    field :roles, {:array, Ecto.Enum}, values: [:ADOPTER, :DONOR]
    has_many :pets, Announcements.Pet, foreign_key: :owner_id
    has_many :events, Announcements.Event, foreign_key: :owner_id

    timestamps(type: :utc_datetime)
  end

  ## Public API

  @doc """
  Changeset for user registration

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

  * `:hash_password` - Defines if the password should be hashed. Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_email
    |> validate_password(opts)
  end

  @doc """
  Changeset for complete the user profile
  """
  def profile_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :country, :bio, :website, :phone, :social_links])
    |> cast_attachments(attrs, [:avatar])
    |> validate_required([:name, :bio, :phone, :country])
    |> validate_url(:website, checks: [:path, :valid_host])
    |> Commons.Validations.Url.validate_urls(:social_links)
    |> validate_phone_number
  end

  @doc """
  Change a role or status of some user
  """
  def role_changeset(user, attrs) do
    user
    |> cast(attrs, [:roles, :is_active])
    |> validate_subset(:roles, [:ADOPTER, :DONOR])
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, %{confirmed_at: now, is_active: true})
  end

  def valid_password?(%User{hashed_password: hashed_password}, password)
      when is_binary(password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  # ========== Private functions ==========

  @spec validate_email(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_email(changeset) do
    changeset
    |> validate_required(:email)
    |> unsafe_validate_unique(:email, PontoCao.Repo)
    |> validate_email(:email, checks: [:check_mx_record])
  end

  @spec validate_password(Ecto.Changeset.t(), Keyword.t()) :: Ecto.Changeset.t()
  defp validate_password(changeset, opts) do
    changeset
    |> validate_required(:password)
    |> validate_length(:password, min: 8)
    |> validate_format(:password, ~r/\d/, message: "must contain at least one digit")
    |> validate_format(:password, ~r/[A-Z]/,
      message: "must contain at least one uppercase letter"
    )
    |> maybe_hash_password(opts)
  end

  @spec maybe_hash_password(Ecto.Changeset.t(), Keyword.t()) :: Ecto.Changeset.t()
  defp maybe_hash_password(%Ecto.Changeset{} = changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if(hash_password? && !is_nil(password) && changeset.valid?) do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
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
