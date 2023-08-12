defmodule LecabotWeb.PageController do
  use LecabotWeb, :controller

  def index(conn, _params) do
    # render(conn, "index.html")

    redirect(conn, "404.html")
  end
end
