require 'rails_helper'

RSpec.describe BuildingPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:building) { Building.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, building) }

    it { is_expected.to permit_only_actions(%i[index show is_rover]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, building) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, building) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, building) }

    it { is_expected.to forbid_all_actions }
  end

end
