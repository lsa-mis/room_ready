class CreateResourceStates < ActiveRecord::Migration[7.1]
  def change
    create_table :resource_states do |t|
      t.string :status
      t.boolean :is_checked
      t.references :room_state, null: false, foreign_key: true
      t.references :resource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
