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
    rmrecnbr { "MyString" }
    room_number { "MyString" }
    room_type { "MyString" }
    facility_id { "MyString" }
    floor { nil }
  end
end
