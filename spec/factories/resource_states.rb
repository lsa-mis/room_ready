# == Schema Information
#
# Table name: resource_states
#
#  id            :bigint           not null, primary key
#  status        :string
#  is_checked    :boolean
#  room_state_id :bigint           not null
#  resource_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :resource_state do
    is_checked { true }

    # need to create a virtual attribute becuz room_state and resource need to have the SAME room,
    # otherwise validations fail (and becuz of design). we can't use simple 'associations' here
    transient do
      room { create(:room) }
    end
    room_state { create(:room_state, room: room) }
    resource { create(:resource, room: room) }
  end
end
