class RemoveFieldFromBuilding < ActiveRecord::Migration[7.1]
  def change
    remove_column :buildings, :abbreviation
  end
end
