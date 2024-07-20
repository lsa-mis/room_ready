require 'rails_helper'

RSpec.describe RoomStatePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room) }
  let(:room_state) { FactoryBot.create(:room_state, room: room) }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, room_state) }

    it { is_expected.to permit_only_actions(%i[is_rover show new create edit update]) }
    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly index]) }

  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, room_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin index show new create edit update]) }
    it { is_expected.to permit_only_actions(%i[is_readonly]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, room_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin index show new create edit update]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, room_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_developer is_admin index show new create edit update]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, room_state) }

    it { is_expected.to forbid_all_actions }
  end

end
