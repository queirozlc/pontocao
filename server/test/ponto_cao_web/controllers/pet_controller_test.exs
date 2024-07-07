defmodule PontoCaoWeb.PetControllerTest do
  use PontoCaoWeb.ConnCase

  import PontoCao.AnnouncementsFixtures
  import PontoCao.UsersFixtures

  alias PontoCao.Announcements.Pet

  @create_attrs %{
    name: "some name",
    size: "120.5",
    bio: "some bio",
    photos: ["https://www.example.com/image.jpg", "https://www.example.com/image2.jpg"],
    age: 42,
    gender: :MALE,
    species: :DOG,
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
    photos: [
      "https://www.example.com/image_updated.jpg",
      "https://www.example.com/image2_updated.jpg"
    ],
    age: 43,
    gender: :FEMALE,
    species: :CAT,
    dewormed: false,
    neutered: false,
    disability: false,
    pedigree: false,
    weight: "456.7"
  }
  @invalid_attrs %{
    name: nil,
    size: nil,
    bio: nil,
    photos: nil,
    age: nil,
    gender: nil,
    breed: nil,
    species: nil,
    dewormed: nil,
    neutered: nil,
    disability: nil,
    pedigree: nil,
    weight: nil
  }

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
      user = user_fixture()
      breed = breed_fixture()
      valid_params = @create_attrs |> Map.put(:owner_id, user.id) |> Map.put(:breed_id, breed.id)
      conn = post(conn, ~p"/api/pets", pet: valid_params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/pets/#{id}")

      assert %{
               "id" => ^id,
               "age" => 42,
               "bio" => "some bio",
               "dewormed" => true,
               "disability" => true,
               "gender" => "MALE",
               "name" => "some name",
               "neutered" => true,
               "pedigree" => true,
               "photos" => [
                 "https://www.example.com/image.jpg",
                 "https://www.example.com/image2.jpg"
               ],
               "size" => "120.5",
               "species" => "DOG",
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
               "dewormed" => false,
               "disability" => false,
               "gender" => "FEMALE",
               "name" => "some updated name",
               "neutered" => false,
               "pedigree" => false,
               "photos" => [
                 "https://www.example.com/image_updated.jpg",
                 "https://www.example.com/image2_updated.jpg"
               ],
               "size" => "456.7",
               "species" => "CAT",
               "weight" => "456.7",
               "vaccinated" => false
             } =
               json_response(conn, 200)["data"]
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
