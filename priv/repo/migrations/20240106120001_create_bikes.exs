defmodule SimpleApp.Repo.Migrations.CreateBikes do
  use Ecto.Migration

  def change do
    create table(:bikes) do
      add :name, :string, null: false
      add :brand, :string, null: false
      add :model, :string
      add :type, :string, null: false
      add :year, :string
      add :size, :string
      add :condition, :string, null: false
      add :location, :string, null: false
      add :description, :text
      add :looking_for, :text
      add :estimated_value, :string
      add :components, :text
      add :wheelset, :string
      add :wheel_size, :string
      add :tire_size, :string
      add :images, {:array, :string}, default: []
      add :status, :string, default: "available"
      add :user_id, references(:users, on_delete: :delete_all), null: false
      
      timestamps()
    end

    create index(:bikes, [:user_id])
    create index(:bikes, [:status])
    create index(:bikes, [:type])
    create index(:bikes, [:location])
    create index(:bikes, [:size])
  end
end