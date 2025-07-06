defmodule SimpleApp.Trades.Trade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trades" do
    field :status, :string, default: "pending"
    field :message, :string
    field :initiator_notes, :string
    field :recipient_notes, :string

    belongs_to :initiator, SimpleApp.Accounts.User
    belongs_to :recipient, SimpleApp.Accounts.User
    belongs_to :bike_offered, SimpleApp.Bikes.Bike
    belongs_to :bike_requested, SimpleApp.Bikes.Bike

    timestamps()
  end

  @doc false
  def changeset(trade, attrs) do
    trade
    |> cast(attrs, [:status, :message, :initiator_notes, :recipient_notes, :initiator_id, :recipient_id, :bike_offered_id, :bike_requested_id])
    |> validate_required([:initiator_id, :recipient_id, :bike_offered_id, :bike_requested_id])
    |> validate_inclusion(:status, ["pending", "accepted", "rejected", "cancelled", "completed"])
    |> foreign_key_constraint(:initiator_id)
    |> foreign_key_constraint(:recipient_id)
    |> foreign_key_constraint(:bike_offered_id)
    |> foreign_key_constraint(:bike_requested_id)
  end
end