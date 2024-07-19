require 'rails_helper'

RSpec.describe AppPreferencePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:app_preference) { AppPreference.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, app_preference) }

    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, app_preference) }

    it { is_expected.to permit_only_actions(%i[configure_prefs save_configured_prefs is_admin]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, app_preference) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, app_preference) }

    it { is_expected.to forbid_all_actions }
  end

end
