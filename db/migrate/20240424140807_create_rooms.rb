class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :rmrecnbr
      t.string :room_number
      t.string :room_type
      t.string :facility_id
      t.references :floor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
