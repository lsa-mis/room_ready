class CreateRoomUpdateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :room_update_logs do |t|
      t.date :date
      t.text :note

      t.timestamps
    end
  end
end
