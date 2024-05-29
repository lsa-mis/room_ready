# == Schema Information
#
# Table name: common_attribute_states
#
#  id                  :bigint           not null, primary key
#  checkbox_value      :boolean
#  quantity_box_value  :integer
#  room_state_id       :bigint           not null
#  common_attribute_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class CommonAttributeState < ApplicationRecord
  belongs_to :room_state
  belongs_to :common_attribute

  validate :checkbox_presence_if_required
  validate :quantity_box_presence_if_required

  private

  def checkbox_presence_if_required
    if common_attribute.need_checkbox && checkbox_value.nil?
      errors.add(:checkbox_value, "can't be blank if checkbox is required")
    end
  end

  def quantity_box_presence_if_required
    if common_attribute.need_quantity_box && quantity_box_value.nil?
      errors.add(:quantity_box_value, "can't be blank if quantity box is required")
    end
  end
end
