class AddIndexOnRoomStates < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_index :room_states, :updated_at, algorithm: :concurrently
  end
end
