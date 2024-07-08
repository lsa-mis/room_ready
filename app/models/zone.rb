# == Schema Information
#
# Table name: zones
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Zone < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, presence: true
  has_many :buildings, -> { active }, class_name: 'Building'

  def total_rooms
    Room.joins(floor: { building: :zone })
        .where(zones: { id: self.id })
        .count
  end
end
