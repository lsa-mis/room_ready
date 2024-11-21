# == Schema Information
#
# Table name: room_update_logs
#
#  id         :bigint           not null, primary key
#  date       :date
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class RoomUpdateLog < ApplicationRecord

  def status
    self.note.split("|").first.strip
  end
end
