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
require 'rails_helper'

RSpec.describe RoomUpdateLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
