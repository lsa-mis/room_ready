require 'rails_helper'

RSpec.describe CommonAttributeStatePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:common_attribute_state) { CommonAttributeState.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, common_attribute_state) }

    it { is_expected.to forbid_actions(%i[is_admin is_developer]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, common_attribute_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, common_attribute_state) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, common_attribute_state) }

    it { is_expected.to forbid_all_actions }
  end

end
