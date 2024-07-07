# == Schema Information
#
# Table name: common_attributes
#
#  id                :bigint           not null, primary key
#  description       :string
#  need_checkbox     :boolean
#  need_quantity_box :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class CommonAttribute < ApplicationRecord
  has_many :common_attribute_states

  validates :description, presence: true, uniqueness: true
  validate :needs_checkbox_or_quantity_box

  private

  def needs_checkbox_or_quantity_box
    return if need_checkbox.blank? ^ need_quantity_box.blank?
    errors.add(:base, 'Needs to have a checkbox or a quantity box, but not both.') 
  end

  def state_exist?
    CommonAttributeState.find_by(common_attribute_id: self).present?
  end
end
