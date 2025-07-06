defmodule SimpleApp.Repo.Migrations.UpdateBikesTable do
  use Ecto.Migration

  def change do
    alter table(:bikes) do
      # Add missing fields
      add :title, :string
      add :price, :decimal
      
      # Rename name to title is already handled above
      remove :name
      
      # Remove fields not in schema
      remove :looking_for
      remove :estimated_value
      remove :location
      
    end
  end
end