# == Schema Information
#
# Table name: resources
#
#  id            :bigint           not null, primary key
#  name          :string
#  resource_type :string
#  room_id       :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :resource do
    name { "MyString" }
    resource_type { "MyString" }
    status { "MyString" }
    room { nil }
  end
end
