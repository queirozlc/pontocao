defmodule PontoCaoWeb.AddressJSON do
  alias PontoCao.Profile.Address

  @doc """
  Renders a list of addresses.
  """
  def index(%{addresses: addresses}) do
    %{data: for(address <- addresses, do: data(address))}
  end

  @doc """
  Renders a single address.
  """
  def show(%{address: address}) do
    %{data: data(address)}
  end

  defp data(%Address{} = address) do
    %{
      id: address.id,
      street: address.street,
      state: address.state,
      neighborhood: address.neighborhood,
      number: address.number,
      zip_code: address.zip_code,
      latitude: address.latitude,
      longitude: address.longitude,
      city: address.city
    }
  end
end
