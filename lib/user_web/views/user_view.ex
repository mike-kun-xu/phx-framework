defmodule UserWeb.UserView do
  use UserWeb, :view
  alias User.Users

  def name(%Users{name: name}), do: name
end
