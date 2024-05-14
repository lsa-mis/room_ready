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
class RoomTicket < ApplicationRecord
  belongs_to :room
end
