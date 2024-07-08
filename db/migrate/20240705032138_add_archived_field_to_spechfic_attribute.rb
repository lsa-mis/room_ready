class AddArchivedFieldToSpechficAttribute < ActiveRecord::Migration[7.1]
  def change
    add_column :specific_attributes, :archived, :boolean, default: false
  end
end
