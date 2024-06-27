# == Schema Information
#
# Table name: room_states
#
#  id                   :bigint           not null, primary key
#  checked_by           :string
#  is_accessed          :boolean
#  report_to_supervisor :boolean
#  room_id              :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  no_access_reason     :string
#
FactoryBot.define do
  factory :room_state do
    checked_by { Faker::Name.first_name }
    is_accessed { true }
    report_to_supervisor { false }
    association :room
  end
end
