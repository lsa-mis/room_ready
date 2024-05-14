# == Schema Information
#
# Table name: buildings
#
#  id         :bigint           not null, primary key
#  bldrecnbr  :string
#  name       :string
#  nick_name  :string
#  address    :string
#  city       :string
#  state      :string
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  zone_id    :bigint
#
require 'rails_helper'

RSpec.describe Building, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
