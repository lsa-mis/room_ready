require 'rails_helper'

RSpec.describe SpecificAttributePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:specific_attribute) { SpecificAttribute.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, specific_attribute) }

    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, specific_attribute) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, specific_attribute) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, specific_attribute) }

    it { is_expected.to forbid_all_actions }
  end
end
