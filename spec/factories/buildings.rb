# == Schema Information
#
# Table name: buildings
#
#  id           :bigint           not null, primary key
#  bldrecnbr    :string
#  name         :string
#  nick_name    :string
#  abbreviation :string
#  address      :string
#  city         :string
#  state        :string
#  zip          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  zone_id      :bigint
#
FactoryBot.define do
  factory :building do
    bldrecnbr { "MyString" }
    name { "MyString" }
    nick_name { "MyString" }
    abbreviation { "MyString" }
    address { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip { "MyString" }
  end
end
