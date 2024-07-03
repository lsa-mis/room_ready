class RemoveStatusFromResourceStates < ActiveRecord::Migration[7.1]
  def change
    remove_column :resource_states, :status
  end
end
