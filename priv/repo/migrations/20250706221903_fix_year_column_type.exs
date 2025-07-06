defmodule SimpleApp.Repo.Migrations.FixYearColumnType do
  use Ecto.Migration

  def change do
    alter table(:bikes) do
      modify :year, :integer
    end
  end
end