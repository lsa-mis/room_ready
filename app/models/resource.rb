# == Schema Information
#
# Table name: resources
#
#  id            :bigint           not null, primary key
#  name          :string
#  resource_type :string
#  room_id       :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  archived      :boolean          default(FALSE)
#
class Resource < ApplicationRecord
  belongs_to :room
  has_many :resource_states

  validates :name, presence: true
  validates :resource_type, presence: true
  validates :room_id, presence: true

  scope :active, -> { where(archived: false).order(:resource_type) }
  scope :archived, -> { where(archived: true).order(:resource_type) }

  def display_name
    "#{self.name} - #{self.resource_type}"
  end

  def state_exist?
    ResourceState.find_by(resource_id: self).present?
  end
end
