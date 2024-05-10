defmodule PontoCao.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :bio, :text, null: false
      add :avatar, :string
      add :website, :string
      add :social_links, {:array, :string}, null: false, default: []

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
