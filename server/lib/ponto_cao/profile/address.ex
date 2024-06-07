defmodule PontoCao.Profile.Address do
  alias PontoCao.Commons
  alias PontoCao.Accounts
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field :state, :string
    field :number, :integer
    field :street, :string
    field :neighborhood, :string
    field :zip_code, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :city, :string
    belongs_to :user, Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :street,
      :state,
      :neighborhood,
      :number,
      :zip_code,
      :latitude,
      :longitude,
      :city,
      :user_id
    ])
    |> validate_required([
      :street,
      :state,
      :neighborhood,
      :number,
      :zip_code,
      :latitude,
      :longitude,
      :city,
      :user_id
    ])
    |> foreign_key_constraint(:user_id)
    |> validate_number(:number, greater_than: 0)
    |> validate_number(:latitude, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
    |> validate_number(:longitude, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
    |> Commons.Cep.validate_cep_format(:zip_code)
    |> Commons.Cep.validate_address(:zip_code)
  end
end
