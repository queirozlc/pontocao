defmodule PontoCaoWeb.PetControllerTest do
  use PontoCaoWeb.ConnCase

  import PontoCao.AnnouncementsFixtures

  alias PontoCao.Announcements.Pet

  @create_attrs %{
    name: "some name",
    size: "120.5",
    bio: "some bio",
    photos: ["option1", "option2"],
    age: 42,
    gender: :male,
    breed: "some breed",
    species: "some species",
    spayed: true,
    dewormed: true,
    neutered: true,
    disability: true,
    pedigree: true,
    weight: "120.5"
  }
  @update_attrs %{
    name: "some updated name",
    size: "456.7",
    bio: "some updated bio",
    photos: ["option1"],
    age: 43,
    gender: :female,
    breed: "some updated breed",
    species: "some updated species",
    spayed: false,
    dewormed: false,
    neutered: false,
    disability: false,
    pedigree: false,
    weight: "456.7"
  }
  @invalid_attrs %{name: nil, size: nil, bio: nil, photos: nil, age: nil, gender: nil, breed: nil, species: nil, spayed: nil, dewormed: nil, neutered: nil, disability: nil, pedigree: nil, weight: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all pets", %{conn: conn} do
      conn = get(conn, ~p"/api/pets")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create pet" do
    test "renders pet when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/pets", pet: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/pets/#{id}")

      assert %{
               "id" => ^id,
               "age" => 42,
               "bio" => "some bio",
               "breed" => "some breed",
               "dewormed" => true,
               "disability" => true,
               "gender" => "male",
               "name" => "some name",
               "neutered" => true,
               "pedigree" => true,
               "photos" => ["option1", "option2"],
               "size" => "120.5",
               "spayed" => true,
               "species" => "some species",
               "weight" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/pets", pet: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update pet" do
    setup [:create_pet]

    test "renders pet when data is valid", %{conn: conn, pet: %Pet{id: id} = pet} do
      conn = put(conn, ~p"/api/pets/#{pet}", pet: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/pets/#{id}")

      assert %{
               "id" => ^id,
               "age" => 43,
               "bio" => "some updated bio",
               "breed" => "some updated breed",
               "dewormed" => false,
               "disability" => false,
               "gender" => "female",
               "name" => "some updated name",
               "neutered" => false,
               "pedigree" => false,
               "photos" => ["option1"],
               "size" => "456.7",
               "spayed" => false,
               "species" => "some updated species",
               "weight" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, pet: pet} do
      conn = put(conn, ~p"/api/pets/#{pet}", pet: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete pet" do
    setup [:create_pet]

    test "deletes chosen pet", %{conn: conn, pet: pet} do
      conn = delete(conn, ~p"/api/pets/#{pet}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/pets/#{pet}")
      end
    end
  end

  defp create_pet(_) do
    pet = pet_fixture()
    %{pet: pet}
  end
end
