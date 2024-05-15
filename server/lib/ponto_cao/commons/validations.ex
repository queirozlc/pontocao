defmodule PontoCao.Commons.Validations do
  @moduledoc """
    Module with common custom validations for Ponto Cão project.
  """

  import Ecto.Changeset

  def validate_urls(changeset, field) do
    case get_field(changeset, field) do
      nil ->
        changeset

      links ->
        Enum.reduce(links, changeset, fn link, changeset ->
          is_valid_url?(link)
          |> case do
            nil -> changeset
            error -> add_error(changeset, field, error)
          end
        end)
    end
  end

  defp is_valid_url?(url) do
    case URI.parse(url) do
      %URI{scheme: nil} ->
        "is missing a scheme (e.g. https)"

      %URI{host: nil} ->
        "is missing a host"

      %URI{host: host} ->
        case :inet.gethostbyname(Kernel.to_charlist(host)) do
          {:ok, _} -> nil
          {:error, _} -> "invalid host"
        end
    end
  end
end
