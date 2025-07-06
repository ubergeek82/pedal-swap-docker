defmodule SimpleApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string, null: false
      add :location, :string
      add :bio, :text
      add :experience, :string
      add :interests, {:array, :string}, default: []
      add :hashed_password, :string, null: false
      
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end