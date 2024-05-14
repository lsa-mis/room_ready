# == Schema Information
#
# Table name: app_preferences
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :string
#  pref_type   :integer
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :app_preference do
    name { "MyString" }
    description { "MyString" }
    pref_type { 1 }
    value { "MyString" }
  end
end
