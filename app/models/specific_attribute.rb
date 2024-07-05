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
#  archived          :boolean          default(FALSE)
#
class SpecificAttribute < ApplicationRecord
  belongs_to :room
  has_many :specific_attribute_states

  validates :description, presence: true
  validates :description, uniqueness: { scope: [:room_id], message: "has already been taken for this room" }
  validate :needs_either_checkbox_or_quantity_box

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  private

  def needs_either_checkbox_or_quantity_box
    errors.add(:base, 'Needs to have either a checkbox or a quantity box, or both.') unless need_checkbox || need_quantity_box
  end

  def state_exist?
    SpecificAttributeState.find_by(specific_attribute_id: self).present?
  end
end
