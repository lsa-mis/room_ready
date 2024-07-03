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
#  tdx_email    :string
#
require 'rails_helper'

RSpec.describe RoomTicket, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:room_ticket)).to be_valid
    end
  end

  context "create room_ticket with all required fields present" do
    it 'is valid' do
      expect(create(:room_ticket)).to be_valid
    end
  end

  context "create zone without a description" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Description can\'t be blank"' do
      expect { FactoryBot.create(:room_ticket, description: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Description can't be blank")
    end
  end

  context "create zone without a submitted_by" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Submitted by can\'t be blank"' do
      expect { FactoryBot.create(:room_ticket, submitted_by: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Submitted by can't be blank")
    end
  end

  context "create zone without a tdx_email" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Tdx email can\'t be blank"' do
      expect { FactoryBot.create(:room_ticket, tdx_email: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Tdx email can't be blank")
    end
  end
end
