class RemoveStatusFieldFromResources < ActiveRecord::Migration[7.1]
  def change
    remove_column :resources, :status
  end
end
