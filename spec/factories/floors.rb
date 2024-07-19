# == Schema Information
#
# Table name: floors
#
#  id          :bigint           not null, primary key
#  name        :string
#  building_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :floor do
    name { Faker::Alphanumeric.alphanumeric(number: 1) }
    association :building
  end
end
