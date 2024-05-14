class RemoveFieldFromRoom < ActiveRecord::Migration[7.1]
  def change
    remove_column :rooms, :facility_id
    add_column :rooms, :last_time_checked, :datetime
  end
end
