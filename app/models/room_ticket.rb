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
class RoomTicket < ApplicationRecord
  belongs_to :room
  has_rich_text :description
  validates :description, presence: true
  validates :room_id, presence: true
end
