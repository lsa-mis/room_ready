require 'rails_helper'

RSpec.describe RoverPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:rover) { Rover.new }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, rover) }

    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly index show create new update edit destroy]) }
    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, rover) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin index show new create edit update destroy]) }
    it { is_expected.to permit_only_actions(%i[is_readonly]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, rover) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin index show create new update edit destroy]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, rover) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin is_developer index show create new update edit destroy]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, rover) }

    it { is_expected.to forbid_all_actions }
  end

end
