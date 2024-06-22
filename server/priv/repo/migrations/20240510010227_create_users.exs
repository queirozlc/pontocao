defmodule PontoCao.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext", "")

    create table(:users) do
      add :is_active, :boolean, default: false
      add :name, :string
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :roles, {:array, :string}, null: false, default: []
      add :bio, :text
      add :avatar, :string
      add :website, :string
      add :phone, :string
      add :social_links, {:array, :string}, default: []
      add :confirmed_at, :naive_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:phone])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:token, :context])
  end
end
