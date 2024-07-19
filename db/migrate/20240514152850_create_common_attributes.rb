class CreateCommonAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table :common_attributes do |t|
      t.string :description
      t.boolean :need_checkbox
      t.boolean :need_quantity_box

      t.timestamps
    end
  end
end
