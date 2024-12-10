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
#  archived   :boolean          default(FALSE)
#
class Building < ApplicationRecord
  has_many :floors
  belongs_to :zone, optional: true

  validates :bldrecnbr, uniqueness: true, presence: true
  validates :name, uniqueness: true

  scope :active, -> { where(archived: false).order(:name) }
  scope :archived, -> { where(archived: true).order(:name) }

  def full_address
    "#{address}, #{city}, #{state} #{zip}"
  end

  def active_rooms
    Room.active.joins(floor: [:building]).where(building: {id: self.id})
  end

  def rooms
    Room.joins(floor: [:building]).where(building: {id: self.id})
  end

  def has_checked_active_rooms?
    active_rooms.detect(&:room_state?).present?
  end

  def has_checked_rooms?
    rooms.detect(&:room_state?).present?
  end

end
