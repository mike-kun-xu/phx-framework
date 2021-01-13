defmodule UserWeb.UserController do
  use UserWeb, :controller
  alias User.Users
  alias User.Repo
  alias User.Authenticate, as: Auth

  def index(conn, _params) do
    render(conn, "index.html")
  end
  def show(conn, _params) do
    case authenticate(conn) do
      %Plug.Conn{halted: true} = conn ->
        conn
      conn ->
        users = Repo.all(Users)
        render conn, "list.html", users: users
    end
  end
  def login(conn, _params) do
    render conn, "login.html"
  end
  def login_do(conn, %{"login" => %{"username" => user, "password" => pass}}) do
    case Auth.login_check(conn, user, pass, repo: Repo) do
      {:ok, conn} -> conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.user_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("login.html")
    end
  end

  def new(conn, _params) do
    changeset = Users.changeset(%Users{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"users" => user_params}) do
    changeset = Users.changeset(%Users{}, user_params)
    if valid?(changeset) do
      case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index))
      _ ->
        conn
        |> put_flash(:error, "Error")
        render(conn, "new.html", changeset: changeset)
    end
    else
      conn
      |> put_flash(:error, "Invalid Input")
      render(conn, "new.html", changeset: changeset)
    end

  end


  defp authenticate(conn) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must log in first to access that page")
      |> redirect(to: Routes.user_path(conn, :login))
      |> halt()
    end
  end
  defp valid?(changeset) do
    changeset.valid?
  end
end
