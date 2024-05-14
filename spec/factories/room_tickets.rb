# == Schema Information
#
# Table name: room_tickets
#
#  id           :bigint           not null, primary key
#  description  :string
#  submitted_by :string
#  submitted_at :datetime
#  room_id      :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :room_ticket do
    description { "MyString" }
    submitted_by { "MyString" }
    submitted_at { "2024-05-14 11:08:05" }
    room { nil }
  end
end
