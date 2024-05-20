defmodule PontoCao.Repo.Migrations.PetsAndBreedsAssociation do
  use Ecto.Migration

  def up do
    alter table(:pets) do
      add :breed_id, references(:breeds, on_delete: :delete_all), null: false
      remove :breed
    end
  end

  def down do
    alter table(:pets) do
      remove :breed_id
      add :breed, :string, null: false
    end
  end
end
