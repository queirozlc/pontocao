defmodule PontoCaoWeb.EventJSON do
  alias PontoCao.Announcements.Event

  @doc """
  Renders a list of events.
  """
  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end

  @doc """
  Renders a single event.
  """
  def show(%{event: event}) do
    %{data: data(event)}
  end

  defp data(%Event{} = event) do
    {:ok, starts_at} =
      TzDatetime.original_datetime(event, time_zone: :timezone, datetime: :starts_at)

    {:ok, ends_at} = TzDatetime.original_datetime(event, time_zone: :timezone, datetime: :ends_at)

    %{
      id: event.id,
      title: event.title,
      description: event.description,
      latitude: event.latitude,
      longitude: event.longitude,
      photos: event.photos,
      starts_at: starts_at,
      ends_at: ends_at,
      frequency: event.frequency
    }
  end
end
