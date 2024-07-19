class AddArchivedToCommonAttributes < ActiveRecord::Migration[7.1]
  def change
    add_column :common_attributes, :archived, :boolean, default: false
  end
end
