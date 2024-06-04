require 'rails_helper'

RSpec.describe RoverPolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:rover) { Rover.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, rover) }

    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, rover) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, rover) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, rover) }

    it { is_expected.to forbid_all_actions }
  end

end
