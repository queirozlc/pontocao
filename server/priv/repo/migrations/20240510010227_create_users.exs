defmodule PontoCao.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string, null: false
      add :password_hash, :string
      add :roles, {:array, :string}, null: false, default: ["ADOPTER"]
      add :bio, :text
      add :avatar, :string
      add :website, :string
      add :social_links, {:array, :string}, default: []
      add :phone, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
    create index(:users, [:name])
  end
end
