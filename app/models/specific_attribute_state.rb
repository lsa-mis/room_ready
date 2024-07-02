# == Schema Information
#
# Table name: specific_attribute_states
#
#  id                    :bigint           not null, primary key
#  checkbox_value        :boolean
#  quantity_box_value    :integer
#  room_state_id         :bigint           not null
#  specific_attribute_id :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class SpecificAttributeState < ApplicationRecord
  belongs_to :room_state
  belongs_to :specific_attribute

  validate :is_editable, on: :update

  private

  def readonly?
    self.updated_at < Time.current.beginning_of_day
  end
  
  def is_editable
    errors.add(:base, 'Old specific attribute state record cannot be edited') if readonly?
  end
end
