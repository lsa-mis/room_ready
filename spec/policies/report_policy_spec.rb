require 'rails_helper'

RSpec.describe ReportPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, :report) }

    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, :report) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly]) }
  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, :report) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, :report) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, :report) }

    it { is_expected.to forbid_all_actions }
  end

end
