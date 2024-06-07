defmodule PontoCaoWeb.AddressController do
  use PontoCaoWeb, :controller

  alias PontoCao.Profile
  alias PontoCao.Profile.Address

  action_fallback PontoCaoWeb.FallbackController

  def index(conn, _params) do
    addresses = Profile.list_addresses()
    render(conn, :index, addresses: addresses)
  end

  def create(conn, %{"address" => address_params}) do
    with {:ok, %Address{} = address} <- Profile.create_address(address_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/addresses/#{address}")
      |> render(:show, address: address)
    end
  end

  def show(conn, %{"id" => id}) do
    address = Profile.get_address!(id)
    render(conn, :show, address: address)
  end

  def update(conn, %{"id" => id, "address" => address_params}) do
    address = Profile.get_address!(id)

    with {:ok, %Address{} = address} <- Profile.update_address(address, address_params) do
      render(conn, :show, address: address)
    end
  end

  def delete(conn, %{"id" => id}) do
    address = Profile.get_address!(id)

    with {:ok, %Address{}} <- Profile.delete_address(address) do
      send_resp(conn, :no_content, "")
    end
  end
end
