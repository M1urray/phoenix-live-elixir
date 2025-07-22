defmodule ShopWeb.ProductController do
  use ShopWeb, :controller

  @products [
    %{id: "1", name: "God of War"},
    %{id: "2", name: "Far Cry"},
    %{id: "3", name: "Call of Duty"}
  ]

  def index(conn, _params) do
    conn
    |> assign(:products, @products)
    |> render(:index)
  end

  def show(conn, %{"id" => id}) do
    product = Enum.find(@products, fn product -> product.id == id end)

    conn
    |> assign(:product, product)
    |> render(:show)
  end
end
