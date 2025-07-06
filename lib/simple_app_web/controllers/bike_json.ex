defmodule SimpleAppWeb.BikeJSON do
  alias SimpleApp.Bikes.Bike

  @doc """
  Renders a list of bikes.
  """
  def index(%{bikes: bikes}) do
    %{data: for(bike <- bikes, do: data(bike))}
  end

  @doc """
  Renders a single bike.
  """
  def show(%{bike: bike}) do
    %{data: data(bike)}
  end

  @doc """
  Renders an error.
  """
  def error(%{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  defp data(%Bike{} = bike) do
    %{
      id: bike.id,
      title: bike.title,
      description: bike.description,
      brand: bike.brand,
      model: bike.model,
      type: bike.type,
      size: bike.size,
      condition: bike.condition,
      price: bike.price,
      year: bike.year,
      status: bike.status,
      images: bike.images,
      components: bike.components,
      wheelset: bike.wheelset,
      wheel_size: bike.wheel_size,
      tire_size: bike.tire_size,
      user: user_data(bike.user),
      inserted_at: bike.inserted_at,
      updated_at: bike.updated_at
    }
  end

  defp user_data(%SimpleApp.Accounts.User{} = user) do
    %{
      id: user.id,
      username: user.username,
      display_name: user.display_name,
      location: user.location
    }
  end

  defp user_data(_), do: nil

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end