# == Schema Information
#
# Table name: room_states
#
#  id                   :bigint           not null, primary key
#  checked_by           :string
#  is_accessed          :boolean
#  report_to_supervisor :boolean
#  room_id              :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  no_access_reason     :string
#
require 'rails_helper'

RSpec.describe RoomState, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:room_state)).to be_valid
    end
  end

  context "create room_state with all required fields present" do
    it 'is valid' do
      expect(create(:room_state)).to be_valid
    end
  end

  context "create room_state for the same room for the same day" do
    it 'raises an error: There can only be one RoomState per room per day' do
      room_state = FactoryBot.create(:room_state)
      room_state1 = FactoryBot.build(:room_state, room: room_state.room, updated_at: room_state.updated_at)
      expect(room_state1.valid?).to be_falsy
      expect(room_state1.errors.full_messages_for(:base)).to include "There can only be one RoomState per room per day"
    end
  end

  context "create room_state for the same room for a different day" do
    it 'is valid' do
      room_state = FactoryBot.create(:room_state)
      room_state1 = FactoryBot.build(:room_state, room: room_state.room, updated_at: room_state.updated_at + 1.week)
      expect(room_state1).to be_valid
    end
  end
end
