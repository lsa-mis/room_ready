require 'rails_helper'

RSpec.describe ZonePolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:zone) { Zone.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, zone) }

    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, zone) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, zone) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, zone) }

    it { is_expected.to forbid_all_actions }
  end

end
