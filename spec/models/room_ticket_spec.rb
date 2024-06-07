# == Schema Information
#
# Table name: room_tickets
#
#  id           :bigint           not null, primary key
#  description  :string
#  submitted_by :string
#  room_id      :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe RoomTicket, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
