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
  validate :checkbox_blank_if_not_required
  validate :quantity_box_blank_if_not_required
  validate :unique_common_attribute_state_per_room_state, on: :create

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

  def checkbox_blank_if_not_required
    if !common_attribute.need_checkbox && checkbox_value.present?
      errors.add(:checkbox_value, "must be blank if checkbox is not required")
    end
  end

  def quantity_box_blank_if_not_required
    if !common_attribute.need_quantity_box && quantity_box_value.present?
      errors.add(:quantity_box_value, "must be blank if quantity box is not required")
    end
  end

  def unique_common_attribute_state_per_room_state
    if room_state.common_attribute_states.where(common_attribute_id: common_attribute_id).any?
      errors.add(:base, "There can only be one Common Attribute State per Common Attribute per Room State")
    end
  end
end
