# == Schema Information
#
# Table name: common_attribute_states
#
#  id                  :bigint           not null, primary key
#  checkbox_value      :boolean
#  quantity_box_value  :integer
#  room_state_id       :bigint           not null
#  common_attribute_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :common_attribute_state do
    checkbox_value { false }
    quantity_box_value { }
    association :room_state, factory: :room_state
    association :common_attribute, factory: :common_attribute
  end
end
