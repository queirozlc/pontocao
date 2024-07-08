defmodule PontoCaoWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PontoCaoWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: PontoCaoWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: PontoCaoWeb.ErrorHTML, json: PontoCaoWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, _conn}) do
    conn
    |> put_status(401)
    |> json(%{error: %{status: 401, message: "Invalid email or password"}})
  end

  def call(conn, {:error, changeset, _conn}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: PontoCaoWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end
end
