# == Schema Information
#
# Table name: rooms
#
#  id          :bigint           not null, primary key
#  rmrecnbr    :string
#  room_number :string
#  room_type   :string
#  facility_id :string
#  floor_id    :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Room < ApplicationRecord
  belongs_to :floor
  has_many :resources
end
