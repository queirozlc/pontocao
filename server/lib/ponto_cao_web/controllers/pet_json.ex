defmodule PontoCaoWeb.PetJSON do
  alias PontoCao.Announcements.Pet

  @doc """
  Renders a list of pets.
  """
  def index(%{pets: pets}) do
    %{data: for(pet <- pets, do: data(pet))}
  end

  @doc """
  Renders a single pet.
  """
  def show(%{pet: pet}) do
    %{data: data(pet)}
  end

  defp data(%Pet{} = pet) do
    %{
      id: pet.id,
      name: pet.name,
      bio: pet.bio,
      photos: pet.photos,
      age: pet.age,
      gender: pet.gender,
      breed: pet.breed,
      species: pet.species,
      spayed: pet.spayed,
      dewormed: pet.dewormed,
      neutered: pet.neutered,
      disability: pet.disability,
      pedigree: pet.pedigree,
      size: pet.size,
      weight: pet.weight
    }
  end
end
