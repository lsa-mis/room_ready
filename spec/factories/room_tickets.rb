# == Schema Information
#
# Table name: room_tickets
#
#  id           :bigint           not null, primary key
#  description  :string
#  submitted_by :string
#  room_id      :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tdx_email    :string
#
FactoryBot.define do
  factory :room_ticket do
    description { Faker::Lorem.paragraphs(number:2) }
    submitted_by { Faker::Name.name }
    tdx_email { Faker::Internet.email }
    association :room
  end
end
