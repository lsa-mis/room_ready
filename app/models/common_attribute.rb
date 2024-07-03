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
#  archived          :boolean          default(FALSE)
#
class CommonAttribute < ApplicationRecord
  has_many :common_attribute_states

  validates :description, presence: true, uniqueness: true
  validate :needs_either_checkbox_or_quantity_box

  private

  def needs_either_checkbox_or_quantity_box
    errors.add(:base, 'Needs to have either a checkbox or a quantity box, or both.') unless need_checkbox || need_quantity_box
  end
end
