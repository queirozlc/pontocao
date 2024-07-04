defmodule PontoCao.CommonsCepTest do
  use ExUnit.Case

  alias PontoCao.Commons.Cep
  alias PontoCao.Profile.Address

  describe "find_address/1" do
    test "when the postal code is valid and found" do
      assert {:ok, address} = Cep.find_address("01311-000")
      assert address.city == "São Paulo"
      assert address.state == "SP"
    end

    test "when the postal code is valid but not address was found" do
      assert {:error, error} = Cep.find_address("00000-000")
      assert error.message == "Postal code not found"
      assert error.status_code == 404
      assert error.valid? == false
    end

    test "when the postal code is invalid" do
      # 6 digits postal code
      assert {:error, error} = Cep.find_address("0000-000")
      assert error.valid? == false
      assert error.status_code == 400
    end
  end

  # describe "validate_cep_format/2" do
  #   test "when the postal code is valid" do
  #     changeset = Ecto.Changeset.cast(%Address{}, %{zip_code: "01311-000"}, [:zip_code])
  #     changeset = Cep.validate_cep_format(changeset, :zip_code)
  #     assert changeset.valid?
  #   end

  #   test "when the postal code has an invalid format" do
  #     changeset = Ecto.Changeset.cast(%Address{}, %{zip_code: "01311"}, [:zip_code])
  #     changeset = Cep.validate_cep_format(changeset, :zip_code)
  #     assert changeset.valid? == false
  #     assert changeset.errors[:zip_code] == {"has invalid format", [validation: :format]}
  #   end
  # end

  # describe "validate_address/2" do
  #   test "when the postal code is valid" do
  #     changeset = Ecto.Changeset.cast(%Address{}, %{zip_code: "01311-000"}, [:zip_code])
  #     changeset = Cep.validate_address(changeset, :zip_code)
  #     assert changeset.valid?
  #   end

  #   test "when the postal code does not exists" do
  #     changeset = Ecto.Changeset.cast(%Address{}, %{zip_code: "00000-000"}, [:zip_code])
  #     changeset = Cep.validate_address(changeset, :zip_code)
  #     assert changeset.valid? == false
  #     assert changeset.errors == [zip_code: {"Postal code not found", []}]
  #   end
  # end
end
