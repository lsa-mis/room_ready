# == Schema Information
#
# Table name: rovers
#
#  id         :bigint           not null, primary key
#  uniqname   :string
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :rover do
    uniqname { Faker::Alphanumeric.alpha(number: 8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
