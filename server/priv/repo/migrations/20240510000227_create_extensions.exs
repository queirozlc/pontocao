defmodule PontoCao.Repo.Migrations.CreateExtensions do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm;", "DROP EXTENSION IF EXISTS pg_trgm;"
    execute "CREATE EXTENSION IF NOT EXISTS postgis;", "DROP EXTENSION IF EXISTS postgis;"
    execute "CREATE EXTENSION IF NOT EXISTS unaccent", "DROP EXTENSION IF EXISTS unaccent;"
  end
end
