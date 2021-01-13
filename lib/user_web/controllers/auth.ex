defmodule User.Authenticate do
  import Plug.Conn
  alias User.Users
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end
  def call(conn,repo) do
    id = get_session(conn, :user_id)
    user = id && repo.get(Users, id)
    assign(conn, :current_user, user)
  end
  def login(conn,user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end
  def login_check(conn, user, pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Users, username: user)
    cond do
      user && checkpw(pass, user.password) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end
