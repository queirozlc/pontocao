defmodule PontoCao.Announcements.Event do
  @moduledoc """
  I've commented about this in `create_event` migration file but i think it's worth repeating here.
  The frequency field is a 8-bit integer that represents the days of the week.
  So sunday=1, monday=2, tuesday=4, wednesday=8, thursday=16, friday=32, saturday=64.
  This way, if an event is repeated every Monday, Wednesday, and Friday, the frequency would be 101010 which stands for 42 in decimal.
  To retrieve what is the frequency of an event, we can use the bitwise AND operation to check if a day is present in the frequency. In Elixir we can use the `Bitwise.band/2` function.

  # Example:
  # iex> Bitwise.band(42, 2)
  # 2

  But i also would like to do this bitwise operation by hand, so i can understand how it works. Let's assume you want to check all the events from monday. You would do the following:

  First, let's assume that have two events on database, one with frequency 42 (monday, wednesday and friday) and other with frequency 8 (only wednesday).

  1. Convert the frequency to binary, in this case, 42 is 101010 and 8 is 001000
  2. Convert the day of the week to binary, in this case, monday is 000010
  3. Do the bitwise AND operation between the frequency and the day of the week
  4. If the result is greater than 0, the event is repeated on that day

  Bitwise AND follows a thuth table AND rules, so if both bits are 1, the result is 1, otherwise, the result is 0.
  """
  alias PontoCao.Accounts
  alias PontoCao.Commons
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :description, :string
    field :title, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :photos, {:array, :string}
    field :frequency, :integer, default: 0

    # Fields to handle the event's time considering the user's timezone
    field :input_starts_at, :naive_datetime, virtual: true
    field :input_ends_at, :naive_datetime, virtual: true
    field :timezone, :string, default: "Etc/UTC"

    field :starts_at, :utc_datetime
    field :ends_at, :utc_datetime
    field :original_offset, :integer
    belongs_to :owner, Accounts.User, foreign_key: :owner_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :title,
      :description,
      :latitude,
      :longitude,
      :photos,
      :frequency,
      :owner_id,
      :input_starts_at,
      :input_ends_at,
      :timezone
    ])
    |> validate_required([
      :title,
      :latitude,
      :longitude,
      :photos,
      :frequency,
      :owner_id,
      :input_starts_at,
      :input_ends_at,
      :timezone
    ])
    |> foreign_key_constraint(:owner_id)
    |> validate_number(:latitude, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
    |> validate_number(:longitude, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
    |> validate_length(:photos, min: 2)
    |> validate_length(:description, min: 20)
    |> validate_date_in_future(:input_starts_at)
    |> validate_starts_at_before_ends_at()
    |> validate_frequency
    |> validate_number(:frequency, greater_than_or_equal_to: 0, less_than_or_equal_to: 127)
    |> Commons.Validations.validate_urls(:photos)
    |> TzDatetime.handle_datetime(
      input_datetime: :input_starts_at,
      time_zone: :timezone,
      datetime: :starts_at
    )
    |> TzDatetime.handle_datetime(
      input_datetime: :input_ends_at,
      time_zone: :timezone,
      datetime: :ends_at
    )
  end

  defp validate_starts_at_before_ends_at(changeset) do
    starts_at = get_field(changeset, :input_starts_at)
    ends_at = get_field(changeset, :input_ends_at)

    case {starts_at, ends_at} do
      {nil, _} ->
        changeset

      {_, nil} ->
        changeset

      _ ->
        if NaiveDateTime.compare(starts_at, ends_at) == :gt do
          add_error(changeset, :input_ends_at, "must be after starts_at")
        else
          changeset
        end
    end
  end

  defp validate_date_in_future(changeset, field) do
    value = get_field(changeset, field)

    case value do
      nil ->
        changeset

      _ ->
        if NaiveDateTime.compare(value, NaiveDateTime.utc_now()) == :lt do
          add_error(changeset, field, "must be in the future")
        else
          changeset
        end
    end
  end

  defp validate_frequency(changeset) do
    starts_at = get_field(changeset, :input_starts_at)
    ends_at = get_field(changeset, :input_ends_at)
    frequency = get_field(changeset, :frequency)

    case {starts_at, ends_at, frequency} do
      {nil, _, _} ->
        changeset

      {_, nil, _} ->
        changeset

      {_, _, 0} ->
        changeset

      {_, _, _} ->
        validate_frequency(changeset, starts_at, ends_at, frequency)
    end
  end

  defp validate_frequency(changeset, starts_at, ends_at, frequency) do
    # If the event is not repeated, the frequency must be 0
    # If the event is repeated, the frequency must be greater than 0
    case Date.diff(starts_at, ends_at) do
      0 ->
        event_not_repeated(changeset, frequency)

      _ ->
        event_repeated(changeset, frequency)
    end
  end

  defp event_not_repeated(changeset, 0), do: changeset

  defp event_not_repeated(changeset, _),
    do: add_error(changeset, :frequency, "must be 0 when the event is not repeated")

  defp event_repeated(changeset, 0),
    do:
      add_error(
        changeset,
        :frequency,
        "must be greater than 0 if the starts_at and ends_at are different days"
      )

  defp event_repeated(changeset, _), do: changeset
end
