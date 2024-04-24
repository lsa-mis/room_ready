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
require 'rails_helper'

RSpec.describe Room, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
