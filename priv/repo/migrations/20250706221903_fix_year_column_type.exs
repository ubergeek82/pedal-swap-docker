defmodule SimpleApp.Repo.Migrations.FixYearColumnType do
  use Ecto.Migration

  def change do
    alter table(:bikes) do
      modify :year, :integer, using: "CASE WHEN year = '' THEN NULL ELSE year::integer END"
    end
  end
end