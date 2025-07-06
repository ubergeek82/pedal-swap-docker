defmodule SimpleApp.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      # Add missing fields
      add :username, :string
      add :display_name, :string
      add :avatar_url, :string
      add :strava_id, :string
      add :favorite_ride, :string
      add :preferred_size, :string
      add :interested_in, {:array, :string}, default: []
      
      # Rename password field
      remove :hashed_password
      add :password_hash, :string
      
      # Rename name to match schema
      remove :name
    end

    create unique_index(:users, [:username])
  end
end