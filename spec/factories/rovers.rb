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
    uniqname { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
  end
end
