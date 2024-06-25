# == Schema Information
#
# Table name: zones
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Zone < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, presence: true
  has_many :buildings

  scope :get_array_of_all_zones, -> {order(:name).map { |z| [z.name, z.id] }}
end
