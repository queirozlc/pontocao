defmodule PontoCao.Announcements.Pet do
  use Ecto.Schema
  import Ecto.Changeset
  alias PontoCao.{Users, Commons, Announcements}

  schema "pets" do
    field :name, :string
    field :size, :decimal
    field :bio, :string
    field :photos, {:array, :string}
    field :age, :integer
    field :gender, Ecto.Enum, values: [:MALE, :FEMALE]
    field :species, Ecto.Enum, values: [:DOG, :CAT]
    field :vaccinated, :boolean, default: false
    field :dewormed, :boolean, default: false
    field :neutered, :boolean, default: false
    field :disability, :boolean, default: false
    field :pedigree, :boolean, default: false
    field :weight, :decimal
    belongs_to :user, Users.User, foreign_key: :owner_id
    belongs_to :breed, Announcements.Breed, foreign_key: :breed_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [
      :name,
      :bio,
      :photos,
      :age,
      :gender,
      :species,
      :vaccinated,
      :dewormed,
      :neutered,
      :disability,
      :pedigree,
      :size,
      :weight,
      :breed_id
    ])
    |> validate_required([
      :name,
      :bio,
      :photos,
      :age,
      :gender,
      :species,
      :vaccinated,
      :dewormed,
      :neutered,
      :disability,
      :pedigree,
      :size,
      :weight,
      :breed_id
    ])
    |> foreign_key_constraint(:owner_id)
    |> foreign_key_constraint(:breed_id)
    |> validate_number(:age, greater_than: 0)
    |> validate_inclusion(:gender, [:MALE, :FEMALE])
    |> validate_inclusion(:species, [:DOG, :CAT])
    |> validate_length(:photos, min: 2, max: 5)
    |> validate_number(:size, greater_than: 0)
    |> validate_number(:weight, greater_than: 0)
    |> Commons.Validations.Url.validate_urls(:photos)
  end
end
