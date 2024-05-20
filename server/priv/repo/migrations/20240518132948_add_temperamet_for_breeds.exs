defmodule PontoCao.Repo.Migrations.AddTemperametForBreeds do
  use Ecto.Migration

  def up do
    alter table(:breeds) do
      add :temperaments, {:array, :string}, null: false
      remove :personality
    end
  end

  def down do
    alter table(:breeds) do
      add :personality, :text
      remove :temperaments
    end
  end
end
