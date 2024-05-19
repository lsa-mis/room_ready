# == Schema Information
#
# Table name: buildings
#
#  id         :bigint           not null, primary key
#  bldrecnbr  :string
#  name       :string
#  nick_name  :string
#  address    :string
#  city       :string
#  state      :string
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  zone_id    :bigint
#
FactoryBot.define do
  factory :building do
    bldrecnbr { Faker::Number.number(digits: 7).to_s }
    name { Faker::Company.department }
    nick_name { Faker::Alphanumeric.alphanumeric(number: 3)}
    address { Faker::Address.full_address }
    city { Faker::Address.city }
    state { Faker::Address.state  }
    zip { Faker::Address.postcode }
    association :zone
  end
end
