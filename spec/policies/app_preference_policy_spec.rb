require 'rails_helper'

RSpec.describe AppPreferencePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:app_preference) { AppPreference.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, app_preference) }

    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly show create new update edit configure_prefs save_configured_prefs destroy]) }
    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, app_preference) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin show create new update edit configure_prefs save_configured_prefs destroy]) }
    it { is_expected.to permit_only_actions(%i[is_readonly]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, app_preference) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly index show create new update edit destroy]) }
    it { is_expected.to permit_only_actions(%i[is_admin configure_prefs save_configured_prefs]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, app_preference) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin is_developer index show create new update edit configure_prefs save_configured_prefs destroy]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, app_preference) }

    it { is_expected.to forbid_all_actions }
  end

end
