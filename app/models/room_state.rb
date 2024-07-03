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

  validate :unique_room_state_per_day
  validate :is_editable, on: :update

  private
  def unique_room_state_per_day
    date = (updated_at || Time.current).to_date # different based on whether it is a new record or an existing one
    existing_records = RoomState.where(room_id: room_id, updated_at: date.beginning_of_day..date.end_of_day)
                               .where.not(id: id)
    if existing_records.exists?
      errors.add(:base, 'There can only be one RoomState per room per day')
    end
  end

  def readonly?
    if self.id.present?
      self.updated_at < Time.current.beginning_of_day
    else
      false
    end
  end
  
  def is_editable
    errors.add(:base, 'Old room state record cannot be edited') if readonly?
  end

end
