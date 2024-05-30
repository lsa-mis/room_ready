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
    name { Faker::Lorem.words(number: 2, supplemental: true).join(' ') }
    description { Faker::Lorem.words(number: 4, supplemental: true).join(' ') }
    pref_type { [0, 1, 2].sample }
    value do
      case pref_type
      when 0
        ["0", "1"].sample
      when 1
        Faker::Number.number(digits: 3).to_s
      when 2  
        Faker::Lorem.word
      end
    end
  end
end
