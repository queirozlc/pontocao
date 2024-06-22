defmodule PontoCao.Accounts do
  @moduledoc """
  The Accounts context.
  """
  require Logger
  import Ecto.Query, warn: false
  alias PontoCao.Accounts.UserNotifier
  alias PontoCao.Repo

  alias PontoCao.Accounts.{User, UserToken}

  @confirmation_context "confirm"

  # Database Query functions

  @doc """
  Gets an user by email.

  ## Example
    
    iex> get_user_by_email("valid_email@example.com")
    %User{}

    iex> get_user_by_email("unknown_email@example.com")
  """

  @spec get_user_by_email(email :: String.t()) :: %User{} | nil

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets an user by email and password

  ## Example
    iex> get_user_by_email_and_password("foo@example.com", "some_password")
    %User{}

    iex> get_user_by_email_and_password("unknown_email@example.com", "some_password")
    nil

    iex> get_user_by_email_and_password("foo@example.com", "wrong_password")
    nil
  """
  @spec get_user_by_email_and_password(email :: String.t(), password :: String.t()) ::
          %User{} | nil
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = get_user_by_email(email)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user by id.

  ## Example
    iex> get_user!(1)
    %User{}
    iex> get_user!(100)
    ** (Ecto.NoResultsError) expected at least one result but got none
  """
  @spec get_user!(id :: integer()) :: %User{} | term()
  def get_user!(id), do: Repo.get!(User, id)

  # User registration and mutation

  @doc """
  Registers a user.

  ## Examples

    iex> register_user(%{field: value})
    {:ok, %User{}}

    iex> register_user(%{field: bad_value})
    {:error, %Ecto.Changeset{}}
  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @spec register_user!(attrs :: map()) :: User.t() | no_return()
  def register_user!(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user profile changes.

  ## Examples

      iex> change_user_profile(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user_profile(user :: %User{}, attrs :: map()) :: Ecto.Changeset.t()
  def change_user_profile(%User{} = user, attrs \\ %{}) do
    User.profile_changeset(user, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing user active status or role.

  ## Examples

      iex> change_user_role(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user_role(user :: %User{}, attrs :: map()) :: Ecto.Changeset.t()
  def change_user_role(%User{} = user, attrs \\ %{}) do
    User.role_changeset(user, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user_registration(user :: %User{}, attrs :: map()) :: Ecto.Changeset.t()
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end

  ## =================== Confirmation ===================

  @doc """
  Delivers the confirmation email instructions to the given user.

  ## Examples

      iex> deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :confirm, &1))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &Routes.user_confirmation_url(conn, :confirm, &1))
      {:error, :already_confirmed}

  """
  def deliver_confirmation_instructions(%User{} = user, confirmation_url_fn)
      when is_function(confirmation_url_fn, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, @confirmation_context)
      Logger.info("Sending confirmation email to #{user.email}")
      Logger.debug("Confirmation token: #{encoded_token}")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fn.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      Logger.info("User confirmed: #{user.email}")
      {:ok, user}
    else
      _ ->
        Logger.error("Error confirming user with token: #{inspect(token)}")
        {:error, :invalid_token}
    end
  end

  defp confirm_user_multi(user) do
    Logger.info("Confirming user: #{user.email}")

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, ["confirm"]))
  end

  ## =================== Session Management ===================

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    # Change to string representation for authorization.
    # This is a deviation from the mix.phx.gen one
    # Eventually could switch to Phoenix.Token or JWT
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end
end
