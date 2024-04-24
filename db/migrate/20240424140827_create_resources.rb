class CreateResources < ActiveRecord::Migration[7.1]
  def change
    create_table :resources do |t|
      t.string :name
      t.string :resource_type
      t.string :status
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
