defmodule PontoCao.Commons.Cep do
  @moduledoc """
  This module is responsible for validating and finding addresses by postal code. It uses the Brasil API for do it
  also export functions to validate cep in Ecto Changeset's 
  """
  @cep_url "https://brasilapi.com.br/api/cep/v1/"
  @cep_regex ~r/^\d{5}-\d{3}$|^\d{8}$/

  alias PontoCao.Commons.Cep
  import HTTPoison, only: [get: 1]
  import Ecto.Changeset, only: [add_error: 3, get_field: 2, validate_format: 3]

  @doc """
  Validate the postal code format, it must be in the format XXXXX-XXX or XXXXXXXX, use with Ecto Changeset
  """
  @spec validate_cep_format(changeset :: Ecto.Changeset.t(), field :: atom) :: Ecto.Changeset.t()
  def validate_cep_format(changeset, field) do
    validate_format(changeset, field, @cep_regex)
  end

  @doc """
  Tries to find an address by postal code using the Brasil API, if the postal code is not found
  or the API is down, it will return an error struct with the message and status code
  """

  def find_address(postal_code) do
    case get(@cep_url <> postal_code) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, parse_response(body)}

      {:ok, error_response} ->
        {:error, handle_error(postal_code, error_response)}

      {:error, %HTTPoison.Error{}} ->
        {:error, :timeout,
         %Cep.Error{
           postal_code: postal_code,
           message: "Timeout, could not connect to the API",
           valid?: false
         }}
    end
  end

  @spec find_address!(postal_code :: String.t()) :: Cep.Address.t()
  def find_address!(postal_code) do
    case find_address(postal_code) do
      {:ok, address} ->
        address

      {:error, error} ->
        raise ArgumentError, "Could not find address, error: #{inspect(error)}"
    end
  end

  @doc """
  Validate if the postal code is valid, if it is not, it will add an error to the changeset
  """
  @spec validate_address(changeset :: Ecto.Changeset.t(), field :: atom) :: Ecto.Changeset.t()

  def validate_address(changeset, field) do
    postal_code = get_field(changeset, field)
    validate_address(changeset, field, postal_code)
  end

  defp validate_address(changeset, _field, nil) do
    changeset
  end

  defp validate_address(changeset, field, postal_code) do
    case find_address(postal_code) do
      {:error, :timeout, _} ->
        changeset

      {:error, %Cep.Error{status_code: 500}} ->
        changeset

      {:error, %Cep.Error{message: message}} ->
        add_error(changeset, field, message)

      {:ok, _} ->
        changeset
    end
  end

  @spec parse_response(response_body :: String.t()) :: Cep.Address.t() | Cep.Error.t()
  defp parse_response(respose_body) do
    case Jason.decode(respose_body) do
      {:ok,
       %{
         "state" => state,
         "city" => city,
         "neighborhood" => neighborhood,
         "street" => street,
         "cep" => cep
       }} ->
        %Cep.Address{
          state: state,
          city: city,
          neighborhood: neighborhood,
          street: street,
          postal_code: cep,
          valid?: true
        }

      _ ->
        %Cep.Error{
          message: "Unknown error, maybe could not decode the body",
          valid?: false
        }
    end
  end

  # This function handles the error response from Brasil API in four cases:
  # - When the status code is 400, something is wrong with request, probably the postal code is invalid
  # - When status code is 404, the postal code is valid but was not found in any postal code services
  # - When status code is 500, probably the API is down or something else
  # - When for some reason a timeout occurs
  @spec handle_error(postal_code :: String.t(), error_response :: HTTPoison.Response.t()) ::
          Cep.Error.t()

  defp handle_error(postal_code, %HTTPoison.Response{status_code: 400} = error_response) do
    case Jason.decode(error_response.body) do
      {:ok, %{"message" => message}} ->
        %Cep.Error{
          postal_code: postal_code,
          message: message,
          status_code: error_response.status_code,
          valid?: false
        }

      _ ->
        %Cep.Error{
          postal_code: postal_code,
          status_code: error_response.status_code,
          valid?: false,
          message: "Unknown error, maybe could not decode the body"
        }
    end
  end

  defp handle_error(postal_code, %HTTPoison.Response{status_code: 404} = _error_response) do
    %Cep.Error{
      postal_code: postal_code,
      status_code: 404,
      valid?: false,
      message: "Postal code not found"
    }
  end

  defp handle_error(postal_code, %HTTPoison.Response{status_code: 500} = _error_response) do
    %Cep.Error{
      postal_code: postal_code,
      status_code: 500,
      valid?: false,
      message: "Internal server error, maybe the API is down, try again later"
    }
  end
end
