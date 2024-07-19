class CreateRoomTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :room_tickets do |t|
      t.string :description
      t.string :submitted_by
      t.datetime :submitted_at
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
