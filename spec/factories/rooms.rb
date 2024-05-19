# == Schema Information
#
# Table name: rooms
#
#  id                :bigint           not null, primary key
#  rmrecnbr          :string
#  room_number       :string
#  room_type         :string
#  floor_id          :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  last_time_checked :datetime
#
FactoryBot.define do
  factory :room do
    rmrecnbr { Faker::Number.number(digits: 7).to_s }
    room_number { Faker::Number.number(digits: 4).to_s }
    room_type { "Classroom" }
    association :floor
  end
end
