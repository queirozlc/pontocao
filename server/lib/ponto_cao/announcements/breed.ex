defmodule PontoCao.Announcements.Breed do
  alias PontoCao.Announcements
  use Ecto.Schema
  import Ecto.Changeset

  schema "breeds" do
    field :name, :string
    field :temperaments, {:array, :string}
    has_many :pets, Announcements.Pet, foreign_key: :breed_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(breed, attrs) do
    breed
    |> cast(attrs, [:name, :temperaments])
    |> validate_required([:name, :temperaments])
    |> validate_length(:name, min: 2)
    |> unique_constraint(:name)
  end
end
