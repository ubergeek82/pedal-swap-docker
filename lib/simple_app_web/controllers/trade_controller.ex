defmodule SimpleAppWeb.TradeController do
  use SimpleAppWeb, :controller

  alias SimpleApp.Trades
  alias SimpleApp.Trades.Trade

  def index(conn, _params) do
    trades = Trades.list_trades()
    render(conn, :index, trades: trades)
  end

  def show(conn, %{"id" => id}) do
    trade = Trades.get_trade!(id)
    render(conn, :show, trade: trade)
  end

  def create(conn, %{"trade" => trade_params}) do
    case Trades.create_trade(trade_params) do
      {:ok, trade} ->
        trade = Trades.get_trade!(trade.id)
        conn
        |> put_status(:created)
        |> render(:show, trade: trade)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "trade" => trade_params}) do
    trade = Trades.get_trade!(id)

    case Trades.update_trade(trade, trade_params) do
      {:ok, trade} ->
        trade = Trades.get_trade!(trade.id)
        render(conn, :show, trade: trade)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    trade = Trades.get_trade!(id)

    case Trades.delete_trade(trade) do
      {:ok, _trade} ->
        send_resp(conn, :no_content, "")

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Could not delete trade"})
    end
  end

  def user_trades(conn, %{"user_id" => user_id}) do
    trades = Trades.list_user_trades(user_id)
    render(conn, :index, trades: trades)
  end

  def accept(conn, %{"id" => id}) do
    trade = Trades.get_trade!(id)

    case Trades.accept_trade(trade) do
      {:ok, trade} ->
        render(conn, :show, trade: trade)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def reject(conn, %{"id" => id}) do
    trade = Trades.get_trade!(id)

    case Trades.reject_trade(trade) do
      {:ok, trade} ->
        render(conn, :show, trade: trade)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def cancel(conn, %{"id" => id}) do
    trade = Trades.get_trade!(id)

    case Trades.cancel_trade(trade) do
      {:ok, trade} ->
        render(conn, :show, trade: trade)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end
end