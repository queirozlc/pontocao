defmodule PontoCao.Repo.Migrations.CreateBreeds do
  use Ecto.Migration

  def change do
    create table(:breeds) do
      add :name, :string, null: false
      add :temperaments, {:array, :string}, default: [], null: false

      timestamps(type: :utc_datetime)
    end

    unique_index(:breeds, [:name])
  end
end
