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
class RoomState < ApplicationRecord
  belongs_to :room
  has_many :common_attribute_states
  has_many :specific_attribute_states
  has_many :resource_states

  # validates :room_id, uniqueness: { scope: [:updated_at.to_date], message: "already exist" }

end
