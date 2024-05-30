defmodule PontoCao.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string, null: false
      add :description, :text
      add :latitude, :decimal, null: false
      add :longitude, :decimal, null: false
      add :photos, {:array, :string}, null: false, default: []
      add :owner_id, references(:users, on_delete: :delete_all)
      # add bitwise strategy for defining the event frequency on a week
      # Let's suppose that an event starts_at May 23, and ends_at May 31
      # but the event is repeated every Monday, Wednesday, and Friday
      # the frequency would be 101010 which stands for 42 in decimal
      # since sunday=1, monday=2, tuesday=4, wednesday=8, thursday=16, friday=32, saturday=64
      # In this case, the frequency value stored would be 42
      # In zero case, the event is not repeated
      # In 127 case, the event is repeated every day

      add :frequency, :integer, null: false, default: 0

      # Handling the event's time considering the user's timezone
      add :starts_at, :utc_datetime, null: false
      add :ends_at, :utc_datetime, null: false
      add :original_offset, :integer, null: false
      add :timezone, :string, null: false, default: "Etc/UTC"
      timestamps(type: :utc_datetime)
    end

    create index(:events, [:owner_id])
    create constraint(:events, :latitude_range, check: "latitude >= -90 AND latitude <= 90")
    create constraint(:events, :longitude_range, check: "longitude >= -180 AND longitude <= 180")
    create constraint(:events, :date_range, check: "starts_at <= ends_at")
    create constraint(:events, :date_future, check: "starts_at >= CURRENT_TIMESTAMP")
    create index(:events, [:latitude, :longitude])
  end
end
