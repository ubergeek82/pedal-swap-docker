defmodule SimpleAppWeb.BikeController do
  use SimpleAppWeb, :controller

  alias SimpleApp.Bikes
  alias SimpleApp.Bikes.Bike

  def index(conn, _params) do
    bikes = Bikes.list_available_bikes()
    render(conn, :index, bikes: bikes)
  end

  def show(conn, %{"id" => id}) do
    bike = Bikes.get_bike!(id)
    render(conn, :show, bike: bike)
  end

  def create(conn, %{"bike" => bike_params}) do
    case Bikes.create_bike(bike_params) do
      {:ok, bike} ->
        bike = Bikes.get_bike!(bike.id)
        conn
        |> put_status(:created)
        |> render(:show, bike: bike)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "bike" => bike_params}) do
    bike = Bikes.get_bike!(id)

    case Bikes.update_bike(bike, bike_params) do
      {:ok, bike} ->
        bike = Bikes.get_bike!(bike.id)
        render(conn, :show, bike: bike)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bike = Bikes.get_bike!(id)

    case Bikes.delete_bike(bike) do
      {:ok, _bike} ->
        send_resp(conn, :no_content, "")

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Could not delete bike"})
    end
  end

  def search(conn, params) do
    filters = %{
      type: params["type"],
      size: params["size"],
      brand: params["brand"],
      condition: params["condition"],
      min_price: params["min_price"],
      max_price: params["max_price"]
    }

    bikes = Bikes.search_bikes(filters)
    render(conn, :index, bikes: bikes)
  end

  def user_bikes(conn, %{"user_id" => user_id}) do
    bikes = Bikes.list_user_bikes(user_id)
    render(conn, :index, bikes: bikes)
  end
end