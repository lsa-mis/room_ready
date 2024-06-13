class RemoveSubmittedAtFromRoomTicket < ActiveRecord::Migration[7.1]
  def change
    remove_column :room_tickets, :submitted_at, :datetime
  end
end
