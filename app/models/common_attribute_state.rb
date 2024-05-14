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
end
