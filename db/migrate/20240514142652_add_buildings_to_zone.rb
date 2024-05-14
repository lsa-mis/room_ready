class AddBuildingsToZone < ActiveRecord::Migration[7.1]
  def change
    add_reference :buildings, :zone, index: true, foreign_key: true
  end
end
