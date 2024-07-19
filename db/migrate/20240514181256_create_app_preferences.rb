class CreateAppPreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :app_preferences do |t|
      t.string :name
      t.string :description
      t.integer :pref_type
      t.string :value

      t.timestamps
    end
  end
end
