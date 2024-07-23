require 'rails_helper'

RSpec.describe RoomTicketPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, :room_ticket) }

    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_rover send_email_for_tdx_ticket]) }
  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, :room_ticket) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin send_email_for_tdx_ticket]) }
    it { is_expected.to permit_only_actions(%i[is_readonly]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, :room_ticket) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin send_email_for_tdx_ticket]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, :room_ticket) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin is_developer send_email_for_tdx_ticket]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, :room_ticket) }

    it { is_expected.to forbid_all_actions }
  end

end
