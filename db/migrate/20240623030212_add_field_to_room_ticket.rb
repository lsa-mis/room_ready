class AddFieldToRoomTicket < ActiveRecord::Migration[7.1]
  def change
    add_column :room_tickets, :tdx_email, :string
  end
end
