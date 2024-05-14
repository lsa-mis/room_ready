class CreateSpecificAttributeStates < ActiveRecord::Migration[7.1]
  def change
    create_table :specific_attribute_states do |t|
      t.boolean :checkbox_value
      t.integer :quantity_box_value
      t.references :room_state, null: false, foreign_key: true
      t.references :specific_attribute, null: false, foreign_key: true

      t.timestamps
    end
  end
end
