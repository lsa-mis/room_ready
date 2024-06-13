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
  validates :description, uniqueness: { scope: [:room_id], message: "already has this attribute" }
  validate :needs_either_checkbox_or_quantity_box

  private

  def needs_either_checkbox_or_quantity_box
    errors.add(:base, 'Needs to have either a checkbox or a quantity box, or both.') unless need_checkbox || need_quantity_box
  end
end
