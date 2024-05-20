require 'rails_helper'

RSpec.describe BuildingPolicy do
  subject { described_class.new(user, building) }

  let(:building) { Building.new }

  context 'with rovers' do
    let(:rover) { FactoryBot.create(:rover) }
    let(:user) { FactoryBot.create(:user, uniqname: rover.uniqname) }

    it { is_expected.to permit_only_actions(%i[index show is_rover]) }
  end

  context 'with admins' do
    let(:user) { FactoryBot.create(:user, admin: true, membership: ['lsa-roomready-admins']) }

    # it { is_expected.to permit_all_actions }
    it { is_expected.to forbid_action(:is_rover) }
  end

  context 'with rovers' do
    let(:user) { FactoryBot.create(:user) }

    it { is_expected.to forbid_all_actions }
  end

end
