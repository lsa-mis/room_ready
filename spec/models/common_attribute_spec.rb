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
require 'rails_helper'

RSpec.describe CommonAttribute, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
