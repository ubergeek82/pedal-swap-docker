defmodule SimpleApp.Bikes.Bike do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bikes" do
    field :title, :string
    field :description, :string
    field :brand, :string
    field :model, :string
    field :type, :string
    field :size, :string
    field :condition, :string
    field :price, :decimal
    field :year, :integer
    field :status, :string, default: "available"
    field :images, {:array, :string}, default: []
    field :components, :string
    field :wheelset, :string
    field :wheel_size, :string
    field :tire_size, :string

    belongs_to :user, SimpleApp.Accounts.User
    has_many :initiated_trades, SimpleApp.Trades.Trade, foreign_key: :bike_offered_id
    has_many :received_trades, SimpleApp.Trades.Trade, foreign_key: :bike_requested_id

    timestamps()
  end

  @doc false
  def changeset(bike, attrs) do
    bike
    |> cast(attrs, [:title, :description, :brand, :model, :type, :size, :condition, :price, :year, :status, :images, :components, :wheelset, :wheel_size, :tire_size, :user_id])
    |> validate_required([:title, :brand, :type, :size, :condition, :user_id])
    |> validate_inclusion(:type, ["road", "mountain", "gravel", "hybrid", "other"])
    |> validate_inclusion(:condition, ["excellent", "good", "fair", "poor"])
    |> validate_inclusion(:status, ["available", "pending", "traded", "removed"])
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> validate_number(:year, greater_than: 1900, less_than_or_equal_to: Date.utc_today().year + 1)
  end
end