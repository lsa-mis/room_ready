require 'rails_helper'

RSpec.describe RoomPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { Room.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, room) }

    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly index show create new archive unarchive destroy]) }
    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, room) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin index new create archive unarchive destroy]) }
    it { is_expected.to permit_only_actions(%i[is_readonly]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, room) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin index show create new archive unarchive destroy]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, room) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin is_developer index show create new archive unarchive destroy]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, room) }

    it { is_expected.to forbid_all_actions }
  end

end
