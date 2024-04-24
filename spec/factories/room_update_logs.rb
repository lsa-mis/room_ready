# == Schema Information
#
# Table name: room_update_logs
#
#  id         :bigint           not null, primary key
#  date       :date
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :room_update_log do
    date { "2024-04-24" }
    note { "MyText" }
  end
end
