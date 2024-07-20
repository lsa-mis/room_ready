require 'rails_helper'

RSpec.describe NotePolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room) }
  let(:note) { Note.new(user: user, room: room) }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, note) }

    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, note) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, note) }

    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, note) }

    it { is_expected.to forbid_all_actions }
  end

end
