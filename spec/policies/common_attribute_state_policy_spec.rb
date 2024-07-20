require 'rails_helper'

RSpec.describe CommonAttributeStatePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:common_attribute_state) { CommonAttributeState.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, common_attribute_state) }

    it { is_expected.to permit_only_actions(%i[is_rover new create edit update_common_attribute_states]) }
    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly index]) }
  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, common_attribute_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin new create edit update_common_attribute_states]) }
    it { is_expected.to permit_only_actions(%i[is_readonly]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, common_attribute_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin new create edit update_common_attribute_states]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, common_attribute_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin is_developer new create edit update_common_attribute_states]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, common_attribute_state) }

    it { is_expected.to forbid_all_actions }
  end

end
