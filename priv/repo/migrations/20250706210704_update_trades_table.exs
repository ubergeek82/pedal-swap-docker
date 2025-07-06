defmodule SimpleApp.Repo.Migrations.UpdateTradesTable do
  use Ecto.Migration

  def change do
    alter table(:trades) do
      # Rename columns to match schema
      remove :offerer_id
      remove :receiver_id
      remove :offered_bike_id
      remove :requested_bike_id
      remove :counter_message
      
      add :initiator_id, references(:users, on_delete: :delete_all), null: false
      add :recipient_id, references(:users, on_delete: :delete_all), null: false
      add :bike_offered_id, references(:bikes, on_delete: :delete_all), null: false
      add :bike_requested_id, references(:bikes, on_delete: :delete_all), null: false
      add :initiator_notes, :text
      add :recipient_notes, :text
    end

    create index(:trades, [:initiator_id])
    create index(:trades, [:recipient_id])
    create index(:trades, [:bike_offered_id])
    create index(:trades, [:bike_requested_id])
  end
end