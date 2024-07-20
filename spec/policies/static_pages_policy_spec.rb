require 'rails_helper'

RSpec.describe StaticPagePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, :static_page) }

    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly dashboard]) }
    it { is_expected.to permit_only_actions(%i[is_rover welcome_rovers about]) }
  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, :static_page) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin welcome_rovers]) }
    it { is_expected.to permit_only_actions(%i[is_readonly about dashboard]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, :static_page) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin about dashboard welcome_rovers]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, :static_page) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin is_developer about dashboard welcome_rovers]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, :static_page) }

    it { is_expected.to permit_only_actions(%i[about]) }
    it { is_expected.to forbid_actions(%i[is_admin is_developer is_rover is_readonly dashboard welcome_rovers]) }
  end

  context 'with visitors' do
    subject { described_class.new({ user: nil, role: nil }, :static_page) }

    it { is_expected.to permit_only_actions(%i[about]) }
  end

end
