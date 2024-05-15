defmodule PontoCaoWeb.PetController do
  use PontoCaoWeb, :controller

  alias PontoCao.Announcements
  alias PontoCao.Announcements.Pet

  action_fallback PontoCaoWeb.FallbackController

  def index(conn, _params) do
    pets = Announcements.list_pets()
    render(conn, :index, pets: pets)
  end

  def create(conn, %{"pet" => pet_params}) do
    with {:ok, %Pet{} = pet} <- Announcements.create_pet(pet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/pets/#{pet}")
      |> render(:show, pet: pet)
    end
  end

  def show(conn, %{"id" => id}) do
    pet = Announcements.get_pet!(id)
    render(conn, :show, pet: pet)
  end

  def update(conn, %{"id" => id, "pet" => pet_params}) do
    pet = Announcements.get_pet!(id)

    with {:ok, %Pet{} = pet} <- Announcements.update_pet(pet, pet_params) do
      render(conn, :show, pet: pet)
    end
  end

  def delete(conn, %{"id" => id}) do
    pet = Announcements.get_pet!(id)

    with {:ok, %Pet{}} <- Announcements.delete_pet(pet) do
      send_resp(conn, :no_content, "")
    end
  end
end
