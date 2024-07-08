class AddArchiveFieldToRoom < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :archived, :boolean, default: false
  end
end
