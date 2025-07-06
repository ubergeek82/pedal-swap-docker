defmodule SimpleApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :username, :string
    field :display_name, :string
    field :bio, :string
    field :avatar_url, :string
    field :location, :string
    field :strava_id, :string
    field :favorite_ride, :string
    field :preferred_size, :string
    field :interested_in, {:array, :string}

    has_many :bikes, SimpleApp.Bikes.Bike
    has_many :initiated_trades, SimpleApp.Trades.Trade, foreign_key: :initiator_id
    has_many :received_trades, SimpleApp.Trades.Trade, foreign_key: :recipient_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :username, :display_name, :bio, :avatar_url, :location, :strava_id, :favorite_ride, :preferred_size, :interested_in])
    |> validate_required([:email, :username])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_length(:username, min: 3, max: 30)
    |> validate_length(:password, min: 6, max: 80)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end
end