require 'rails_helper'

RSpec.describe BuildingPolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:building) { Building.new }

  context 'with rovers' do
    subject { described_class.new({ user: user, role: "rover" }, building) }

    it { is_expected.to permit_only_actions(%i[index show is_rover]) }
  end

  context 'with admins' do
    subject { described_class.new({ user: user, role: "admin" }, building) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with admins' do
    subject { described_class.new({ user: user, role: "developer" }, building) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with rovers' do
    subject { described_class.new({ user: user, role: "none" }, building) }

    it { is_expected.to forbid_all_actions }
  end

end
