defmodule UserWeb.Router do
  use UserWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug User.Authenticate, repo: User.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UserWeb do
    pipe_through :browser
    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :new, :create, :delete]
    get "/login", UserController, :login
    post "/login", UserController, :login_do
    get "/users/show", UserController, :show
  end

  # Other scopes may use custom stacks.
   scope "/" do
     pipe_through :api
     forward "/graphiql", Absinthe.Plug.GraphiQL,
     schema: UserWeb.Schema,
     interface: :simple,
     context: %{pubsub: UserWeb.Endpoint}
   end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: UserWeb.Telemetry
    end
  end
end
