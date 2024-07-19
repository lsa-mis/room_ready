# == Schema Information
#
# Table name: announcements
#
#  id         :bigint           not null, primary key
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Announcement < ApplicationRecord
  has_rich_text :content

  validates :location, uniqueness: true, presence: true
end
