class CreateSpecificAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table :specific_attributes do |t|
      t.string :description
      t.boolean :need_checkbox
      t.boolean :need_quantity_box
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
