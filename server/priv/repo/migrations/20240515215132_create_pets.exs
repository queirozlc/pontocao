defmodule PontoCao.Repo.Migrations.CreatePets do
  use Ecto.Migration

  def change do
    create table(:pets) do
      add :name, :string, null: false
      add :bio, :text, null: false
      add :photos, {:array, :string}, null: false
      add :age, :integer, null: false
      add :gender, :string, null: false
      add :breed, :string
      add :species, :string, null: false
      add :spayed, :boolean, default: false, null: false
      add :dewormed, :boolean, default: false, null: false
      add :neutered, :boolean, default: false, null: false
      add :disability, :boolean, default: false, null: false
      add :pedigree, :boolean, default: false, null: false
      add :size, :decimal, default: 0.0, null: false
      add :weight, :decimal, default: 0.0, null: false
      add :owner_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:pets, [:owner_id])
    create index(:pets, [:species])
    create index(:pets, [:breed])
  end
end
