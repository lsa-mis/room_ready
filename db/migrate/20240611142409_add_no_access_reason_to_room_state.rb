class AddNoAccessReasonToRoomState < ActiveRecord::Migration[7.1]
  def change
    add_column :room_states, :no_access_reason, :string
  end
end
