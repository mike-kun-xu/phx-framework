defmodule UserWeb.UserController do
  use UserWeb, :controller
  alias User.Users
  alias UserWeb.Router
  alias User.Repo

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = Users.changeset(%Users{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"users" => user_params}) do 
  
    changeset = Users.changeset(%Users{}, user_params) 
    case Repo.insert(changeset) do
      {:ok, user} -> 
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index)) 
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset) 
    end
  end

end