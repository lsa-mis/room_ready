class AddArchiveFieldToResource < ActiveRecord::Migration[7.1]
  def change
    add_column :resources, :archived, :boolean, default: false
  end
end
