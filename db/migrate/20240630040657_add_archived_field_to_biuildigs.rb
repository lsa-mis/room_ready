class AddArchivedFieldToBiuildigs < ActiveRecord::Migration[7.1]
  def change
    add_column :buildings, :archived, :boolean, default: false
  end
end
