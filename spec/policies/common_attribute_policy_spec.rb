require 'rails_helper'

RSpec.describe CommonAttributePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:common_attribute) { CommonAttribute.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, common_attribute) }

    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, common_attribute) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, common_attribute) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, common_attribute) }

    it { is_expected.to forbid_all_actions }
  end

end
