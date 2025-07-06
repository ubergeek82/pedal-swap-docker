defmodule SimpleApp.Repo.Migrations.CreateTrades do
  use Ecto.Migration

  def change do
    create table(:trades) do
      add :offerer_id, references(:users, on_delete: :delete_all), null: false
      add :receiver_id, references(:users, on_delete: :delete_all), null: false
      add :offered_bike_id, references(:bikes, on_delete: :delete_all), null: false
      add :requested_bike_id, references(:bikes, on_delete: :delete_all), null: false
      add :status, :string, default: "pending"
      add :message, :text
      add :counter_message, :text
      
      timestamps()
    end

    create index(:trades, [:offerer_id])
    create index(:trades, [:receiver_id])
    create index(:trades, [:offered_bike_id])
    create index(:trades, [:requested_bike_id])
    create index(:trades, [:status])
  end
end