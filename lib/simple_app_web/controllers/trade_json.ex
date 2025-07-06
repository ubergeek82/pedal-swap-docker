defmodule SimpleAppWeb.TradeJSON do
  alias SimpleApp.Trades.Trade

  @doc """
  Renders a list of trades.
  """
  def index(%{trades: trades}) do
    %{data: for(trade <- trades, do: data(trade))}
  end

  @doc """
  Renders a single trade.
  """
  def show(%{trade: trade}) do
    %{data: data(trade)}
  end

  @doc """
  Renders an error.
  """
  def error(%{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  defp data(%Trade{} = trade) do
    %{
      id: trade.id,
      status: trade.status,
      message: trade.message,
      initiator_notes: trade.initiator_notes,
      recipient_notes: trade.recipient_notes,
      initiator: user_data(trade.initiator),
      recipient: user_data(trade.recipient),
      bike_offered: bike_data(trade.bike_offered),
      bike_requested: bike_data(trade.bike_requested),
      inserted_at: trade.inserted_at,
      updated_at: trade.updated_at
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

  defp bike_data(%SimpleApp.Bikes.Bike{} = bike) do
    %{
      id: bike.id,
      title: bike.title,
      brand: bike.brand,
      model: bike.model,
      type: bike.type,
      size: bike.size,
      condition: bike.condition,
      price: bike.price,
      images: bike.images
    }
  end

  defp bike_data(_), do: nil

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end