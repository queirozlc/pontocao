defmodule Fuzzie do
  @moduledoc """
  Fuzzie is a piece of abstraction that allows you to interact with Meilisearch search engine. It's is simple wrapper that facilitates the interaction with Meilisearch.

  At the moment it only integrates with Meilisearch, but the future plan is to integrate with other search engines such as ElasticSearch, Algolia, etc.

  `Fuzzie` 'lib' relies on `ecto_hooks` to provide a simple way to keep the data in sync with the search engine.

  `Fuzzie` should be used only in the context of Ecto schemas in order to work as expected.

  ## Example usage

    ```elixir
    defmodule MyContext.User do
      use Ecto.Schema
      use Fuzzie,
        searchable_fields: [:name, :bio]
    end
    ```

    ## The hooks like `after_insert`, `after_update`, `after_delete` are automatically added to the schema. You can override them if you want to customize the behavior.
  """

  defmacro __using__(opts) do
    searchable_fields = Keyword.get(opts, :searchable_fields, [])
    geo_fields = Keyword.get(opts, :geo_fields, [])

    quote do
      require Fuzzie
      alias unquote(__MODULE__), as: Self

      Self.define_hooks(unquote(searchable_fields), unquote(geo_fields))
    end
  end

  defmacro define_hooks(searchable_fields, geo_fields) do
    quote do
      def after_insert(changeset, %EctoHooks.Delta{} = meta) do
        unquote(__MODULE__).create_or_replace(
          changeset,
          unquote(searchable_fields),
          unquote(geo_fields),
          meta
        )
      end

      def after_update(changeset, %EctoHooks.Delta{} = meta) do
        unquote(__MODULE__).create_or_replace(
          changeset,
          unquote(searchable_fields),
          unquote(geo_fields),
          meta
        )
      end

      def after_delete(changeset, %EctoHooks.Delta{} = meta) do
        unquote(__MODULE__).delete(changeset)
      end
    end
  end

  def create_or_replace(changeset, fields, [], %EctoHooks.Delta{}) do
    schema = Ecto.get_meta(changeset, :source)

    if Enum.all?(fields, &fields_present?(&1, changeset)) do
      client()
      |> Meilisearch.Document.create_or_replace(schema, get_fields(changeset, fields, []))
    end

    changeset
  end

  def create_or_replace(changeset, fields, geo_fields, %EctoHooks.Delta{}) do
    schema = Ecto.get_meta(changeset, :source)

    if Enum.all?(fields, &fields_present?(&1, changeset)) do
      client()
      |> Meilisearch.Document.create_or_replace(
        schema,
        get_fields(changeset, fields, geo_fields)
      )
      |> Meilisearch.Settings.FilterableAttributes.update(schema, "[_geo]")
      |> Meilisearch.Settings.SortableAttributes.update(schema, "[_geo]")
    end

    changeset
  end

  def delete(changeset) do
    client()
    |> Meilisearch.Document.delete_one(Ecto.get_meta(changeset, :source), Map.get(changeset, :id))

    changeset
  end

  defp get_fields(changeset, searchable_fields, geo_fields) do
    geo_map = create_geo_map(changeset, geo_fields)
    searchable_map = get_searchable_fields(changeset, searchable_fields)

    Map.merge(searchable_map, geo_map)
  end

  defp get_fields(changeset, searchable_fields, []),
    do: get_searchable_fields(changeset, searchable_fields)

  defp get_searchable_fields(changeset, fields) do
    Enum.reduce(fields, %{}, fn field, acc ->
      value = Map.get(changeset, field)
      Map.put(acc, field, value) |> Map.put(:id, Map.get(changeset, :id))
    end)
  end

  defp create_geo_map(changeset, geo_fields) when is_list(geo_fields) do
    lat_field = Enum.find(geo_fields, &is_lat_field/1)
    lng_field = Enum.find(geo_fields, &is_lng_field/1)

    lat = Map.get(changeset, lat_field)
    lng = Map.get(changeset, lng_field)

    %{_geo: %{lat: lat, lng: lng}}
  end

  defp create_geo_map(changeset, [location_field]) when is_atom(location_field) do
    location = Ecto.Changeset.get_field(changeset, location_field)

    case location do
      %{lat: lat, lng: lng} -> %{_geo: %{lat: lat, lng: lng}}
      %{latitude: lat, longitude: lng} -> %{_geo: %{lat: lat, lng: lng}}
      _ -> %{}
    end
  end

  defp create_geo_map(_changeset, _geo_fields) do
    %{}
  end

  defp fields_present?(field, changeset) do
    Map.has_key?(changeset, field) && Map.get(changeset, field) != nil
  end

  defp is_lat_field(field) do
    String.contains?(Atom.to_string(field), "lat") ||
      String.contains?(Atom.to_string(field), "latitude")
  end

  defp is_lng_field(field) do
    String.contains?(Atom.to_string(field), "lng") ||
      String.contains?(Atom.to_string(field), "longitude")
  end

  defp client, do: :meilisearch |> Meilisearch.client()
end
