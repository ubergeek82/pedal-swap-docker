defmodule SimpleApp.Repo.Migrations.FixYearColumnType do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE bikes ALTER COLUMN year TYPE integer USING CASE WHEN year ~ '^[0-9]+$' THEN year::integer ELSE NULL END"
  end
end