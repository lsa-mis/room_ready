# == Schema Information
#
# Table name: buildings
#
#  id           :bigint           not null, primary key
#  bldrecnbr    :string
#  name         :string
#  nick_name    :string
#  abbreviation :string
#  address      :string
#  city         :string
#  state        :string
#  zip          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Building < ApplicationRecord
end
