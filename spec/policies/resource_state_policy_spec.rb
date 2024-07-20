require 'rails_helper'

RSpec.describe ResourceStatePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room) }
  let(:resource) { FactoryBot.create(:resource, room: room) }
  let(:room_state) { FactoryBot.create(:room_state, room: room) }
  let(:resource_state) { ResourceState.new(resource: resource, room_state: room_state) }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, resource_state) }

    it { is_expected.to permit_only_actions(%i[is_rover new create edit update_resource_states ]) }
    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly]) }

  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, resource_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin new create edit update_resource_states]) }
    it { is_expected.to permit_only_actions(%i[is_readonly]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, resource_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer]) }
    it { is_expected.to permit_only_actions(%i[is_admin new create edit update_resource_states ]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, resource_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_developer is_admin new create edit update_resource_states ]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, resource_state) }

    it { is_expected.to forbid_all_actions }
  end

end
