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
require 'rails_helper'

RSpec.describe SpecificAttribute, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
