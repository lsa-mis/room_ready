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
  has_rich_text :description
  validates :description, presence: true
  validates :room_id, presence: true
  validate  :room_number_must_exist

  private

  def room_number_must_exist
    unless Room.exists?(room_number: self.room_id)
      errors.add(:room, 'must exist')
    end
  end
end
