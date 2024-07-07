# == Schema Information
#
# Table name: specific_attributes
#
#  id                :bigint           not null, primary key
#  description       :string
#  need_checkbox     :boolean
#  need_quantity_box :boolean
#  room_id           :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class SpecificAttribute < ApplicationRecord
  belongs_to :room
  has_many :specific_attribute_states

  validates :description, presence: true
  validates :description, uniqueness: { scope: [:room_id], message: "has already been taken for this room" }
  validate :needs_either_checkbox_or_quantity_box

  private

  def needs_either_checkbox_or_quantity_box
    return if need_checkbox.present? ^ need_quantity_box.present?
    errors.add(:base, 'Needs to have either a checkbox or a quantity box, but not both.')
  end

  def state_exist?
    SpecificAttributeState.find_by(specific_attribute_id: self).present?
  end
end
