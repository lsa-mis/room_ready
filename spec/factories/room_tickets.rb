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
    description { "MyString" }
    submitted_by { "MyString" }
    submitted_at { "2024-05-14 11:08:05" }
    room { nil }
  end
end
