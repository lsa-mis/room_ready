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
class Building < ApplicationRecord
  has_many :floors
  belongs_to :zone, optional: true

  # validates :bldrecnbr, :name, :address, :city, :state, :zip, presence: true
  validates :bldrecnbr, uniqueness: true, presence: true

  def full_address
    "#{address.titleize}, #{city.titleize}, #{state} #{zip}"
  end
end
