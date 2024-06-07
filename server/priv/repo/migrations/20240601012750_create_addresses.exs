defmodule PontoCao.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :street, :string, null: false
      add :state, :string, null: false
      add :neighborhood, :string, null: false
      add :number, :integer
      add :zip_code, :string, null: false
      add :latitude, :decimal, null: false
      add :longitude, :decimal, null: false
      add :city, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:addresses, [:user_id])
    create index(:addresses, [:latitude, :longitude])
    create index(:addresses, [:zip_code])
    create unique_index(:addresses, [:user_id, :zip_code])
    create constraint(:addresses, :latitude, check: "latitude >= -90 AND latitude <= 90")
    create constraint(:addresses, :longitude, check: "longitude >= -180 AND longitude <= 180")
  end
end
