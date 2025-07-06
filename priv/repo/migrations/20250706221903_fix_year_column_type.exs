defmodule SimpleApp.Repo.Migrations.FixYearColumnType do
  use Ecto.Migration

  def change do
    execute "UPDATE bikes SET year = NULL WHERE year = ''"
    alter table(:bikes) do
      modify :year, :integer, using: "year::integer"
    end
  end
end