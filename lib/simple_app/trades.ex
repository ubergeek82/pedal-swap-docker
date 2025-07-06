defmodule SimpleApp.Trades do
  @moduledoc """
  The Trades context.
  """

  import Ecto.Query, warn: false
  alias SimpleApp.Repo
  alias SimpleApp.Trades.Trade

  @doc """
  Returns the list of trades.
  """
  def list_trades do
    Trade
    |> preload([:initiator, :recipient, :bike_offered, :bike_requested])
    |> Repo.all()
  end

  @doc """
  Returns the list of trades for a specific user (both initiated and received).
  """
  def list_user_trades(user_id) do
    Trade
    |> where([t], t.initiator_id == ^user_id or t.recipient_id == ^user_id)
    |> preload([:initiator, :recipient, :bike_offered, :bike_requested])
    |> order_by([t], desc: t.inserted_at)
    |> Repo.all()
  end

  @doc """
  Returns the list of trades initiated by a user.
  """
  def list_initiated_trades(user_id) do
    Trade
    |> where([t], t.initiator_id == ^user_id)
    |> preload([:initiator, :recipient, :bike_offered, :bike_requested])
    |> order_by([t], desc: t.inserted_at)
    |> Repo.all()
  end

  @doc """
  Returns the list of trades received by a user.
  """
  def list_received_trades(user_id) do
    Trade
    |> where([t], t.recipient_id == ^user_id)
    |> preload([:initiator, :recipient, :bike_offered, :bike_requested])
    |> order_by([t], desc: t.inserted_at)
    |> Repo.all()
  end

  @doc """
  Returns the list of pending trades for a user.
  """
  def list_pending_trades(user_id) do
    Trade
    |> where([t], (t.initiator_id == ^user_id or t.recipient_id == ^user_id) and t.status == "pending")
    |> preload([:initiator, :recipient, :bike_offered, :bike_requested])
    |> order_by([t], desc: t.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single trade.
  """
  def get_trade!(id) do
    Trade
    |> preload([:initiator, :recipient, :bike_offered, :bike_requested])
    |> Repo.get!(id)
  end

  @doc """
  Creates a trade.
  """
  def create_trade(attrs \\ %{}) do
    %Trade{}
    |> Trade.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a trade.
  """
  def update_trade(%Trade{} = trade, attrs) do
    trade
    |> Trade.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a trade.
  """
  def delete_trade(%Trade{} = trade) do
    Repo.delete(trade)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trade changes.
  """
  def change_trade(%Trade{} = trade, attrs \\ %{}) do
    Trade.changeset(trade, attrs)
  end

  @doc """
  Accepts a trade and updates bike statuses.
  """
  def accept_trade(%Trade{} = trade) do
    Repo.transaction(fn ->
      with {:ok, trade} <- update_trade(trade, %{status: "accepted"}),
           {:ok, _bike_offered} <- SimpleApp.Bikes.update_bike(trade.bike_offered, %{status: "traded"}),
           {:ok, _bike_requested} <- SimpleApp.Bikes.update_bike(trade.bike_requested, %{status: "traded"}) do
        trade
      else
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  @doc """
  Rejects a trade.
  """
  def reject_trade(%Trade{} = trade) do
    update_trade(trade, %{status: "rejected"})
  end

  @doc """
  Cancels a trade.
  """
  def cancel_trade(%Trade{} = trade) do
    update_trade(trade, %{status: "cancelled"})
  end
end