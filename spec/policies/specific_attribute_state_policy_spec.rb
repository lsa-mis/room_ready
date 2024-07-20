require 'rails_helper'

RSpec.describe SpecificAttributeStatePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room) }
  let(:specific_attribute) { FactoryBot.create(:specific_attribute, room: room) }
  let(:room_state) { FactoryBot.create(:room_state, room: room) }
  let(:specific_attribute_state) { SpecificAttributeState.new(specific_attribute: specific_attribute, room_state: room_state) }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, specific_attribute_state) }

    it { is_expected.to permit_only_actions(%i[is_rover new create edit update_specific_attribute_states]) }
    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly index]) }

  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, specific_attribute_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin index new create edit update_specific_attribute_states]) }
    it { is_expected.to permit_only_actions(%i[is_readonly]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, specific_attribute_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin index new create edit update_specific_attribute_states]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, specific_attribute_state) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_developer is_admin index new create edit update_specific_attribute_states]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, specific_attribute_state) }

    it { is_expected.to forbid_all_actions }
  end

end
