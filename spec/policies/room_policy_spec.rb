require 'rails_helper'

RSpec.describe RoomPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { Room.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, room) }

    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, room) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, room) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, room) }

    it { is_expected.to forbid_all_actions }
  end

end
