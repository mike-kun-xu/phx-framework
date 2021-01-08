defmodule User.Users do
  use UserWeb, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true 

    timestamps()
  end
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :username], [])
    |> validate_length(:username, min: 1, max: 20)
  end
end
