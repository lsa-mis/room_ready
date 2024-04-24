# == Schema Information
#
# Table name: floors
#
#  id          :bigint           not null, primary key
#  name        :string
#  building_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Floor, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
