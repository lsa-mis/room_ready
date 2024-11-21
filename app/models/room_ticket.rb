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

  validates :description, :submitted_by, :tdx_email, presence: true

  scope :latest, -> { all.order(created_at: :desc)
    .limit(AppPreference.find_by(name: "tdx_tickets_quantity_on_dashboard")&.value.presence&.to_i || 5) }

end
