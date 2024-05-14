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
end
