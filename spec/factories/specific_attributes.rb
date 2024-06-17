# == Schema Information
#
# Table name: specific_attributes
#
#  id                :bigint           not null, primary key
#  description       :string
#  need_checkbox     :boolean
#  need_quantity_box :boolean
#  room_id           :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :specific_attribute do
    description { Faker::Lorem.question }
    need_checkbox { true }
    need_quantity_box { false }
    association :room
  end
end
