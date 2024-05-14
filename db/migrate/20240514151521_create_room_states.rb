class CreateRoomStates < ActiveRecord::Migration[7.1]
  def change
    create_table :room_states do |t|
      t.string :checked_by
      t.boolean :is_accessed
      t.boolean :report_to_supervisor
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
