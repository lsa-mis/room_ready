# == Schema Information
#
# Table name: specific_attribute_states
#
#  id                    :bigint           not null, primary key
#  checkbox_value        :boolean
#  quantity_box_value    :integer
#  room_state_id         :bigint           not null
#  specific_attribute_id :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
FactoryBot.define do
  factory :specific_attribute_state do
    checkbox_value { true }
    quantity_box_value { 1 }

    # need to create a virtual attribute becuz room_state and resource need to have the SAME room,
    # otherwise validations fail (and becuz of design). we can't use simple 'associations' here
    transient do
      room { create(:room) }
    end
    room_state { create(:room_state, room: room) }
    specific_attribute { create(:specific_attribute, room: room) }
  end
end
