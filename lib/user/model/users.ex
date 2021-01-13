defmodule User.Users do
  use UserWeb, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string

    timestamps()
  end
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:username,:name,:password], [])
    |> validate_required([:username,:name,:password])
    |> validate_length(:username, min: 5, max: 20)
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
