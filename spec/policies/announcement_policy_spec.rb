require 'rails_helper'

RSpec.describe AnnouncementPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:announcement) { Announcement.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, announcement) }

    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly index show update edit]) }
    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, announcement) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin index show update edit]) }
    it { is_expected.to permit_only_actions(%i[is_readonly]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, announcement) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin index show update edit]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, announcement) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin is_developer index show update edit]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, announcement) }

    it { is_expected.to forbid_all_actions }
  end

end
