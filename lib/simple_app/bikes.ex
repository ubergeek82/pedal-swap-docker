defmodule SimpleApp.Bikes do
  @moduledoc """
  The Bikes context.
  """

  import Ecto.Query, warn: false
  alias SimpleApp.Repo
  alias SimpleApp.Bikes.Bike

  @doc """
  Returns the list of bikes.
  """
  def list_bikes do
    Bike
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Returns the list of available bikes.
  """
  def list_available_bikes do
    Bike
    |> where([b], b.status == "available")
    |> preload(:user)
    |> order_by([b], desc: b.inserted_at)
    |> Repo.all()
  end

  @doc """
  Returns the list of bikes for a specific user.
  """
  def list_user_bikes(user_id) do
    Bike
    |> where([b], b.user_id == ^user_id)
    |> preload(:user)
    |> order_by([b], desc: b.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single bike.
  """
  def get_bike!(id) do
    Bike
    |> preload(:user)
    |> Repo.get!(id)
  end

  @doc """
  Creates a bike.
  """
  def create_bike(attrs \\ %{}) do
    %Bike{}
    |> Bike.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bike.
  """
  def update_bike(%Bike{} = bike, attrs) do
    bike
    |> Bike.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bike.
  """
  def delete_bike(%Bike{} = bike) do
    Repo.delete(bike)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bike changes.
  """
  def change_bike(%Bike{} = bike, attrs \\ %{}) do
    Bike.changeset(bike, attrs)
  end

  @doc """
  Searches bikes based on filters.
  """
  def search_bikes(filters) do
    query = from b in Bike, where: b.status == "available"

    query
    |> apply_filter(:type, filters[:type])
    |> apply_filter(:size, filters[:size])
    |> apply_filter(:brand, filters[:brand])
    |> apply_filter(:condition, filters[:condition])
    |> apply_price_filter(filters[:min_price], filters[:max_price])
    |> preload(:user)
    |> order_by([b], desc: b.inserted_at)
    |> Repo.all()
  end

  defp apply_filter(query, _field, nil), do: query
  defp apply_filter(query, :type, type), do: where(query, [b], b.type == ^type)
  defp apply_filter(query, :size, size), do: where(query, [b], b.size == ^size)
  defp apply_filter(query, :brand, brand), do: where(query, [b], ilike(b.brand, ^"%#{brand}%"))
  defp apply_filter(query, :condition, condition), do: where(query, [b], b.condition == ^condition)

  defp apply_price_filter(query, nil, nil), do: query
  defp apply_price_filter(query, min, nil), do: where(query, [b], b.price >= ^min)
  defp apply_price_filter(query, nil, max), do: where(query, [b], b.price <= ^max)
  defp apply_price_filter(query, min, max), do: where(query, [b], b.price >= ^min and b.price <= ^max)
end