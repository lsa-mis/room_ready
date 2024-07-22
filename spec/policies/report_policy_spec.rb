require 'rails_helper'

RSpec.describe ReportPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }

  context 'with rover role' do
    subject { described_class.new({ user: user, role: "rover" }, :report) }

    it { is_expected.to forbid_actions(%i[is_admin is_developer is_readonly index 
      number_of_room_issues_report room_issues_report inspection_rate_report no_access_report common_attribute_states_report 
      specific_attribute_states_report resource_states_report no_access_for_n_times_report not_checked_rooms_report])}
    it { is_expected.to permit_only_actions(%i[is_rover]) }
  end

  context 'with readonly role' do
    subject { described_class.new({ user: user, role: "readonly" }, :report) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_admin]) }
    it { is_expected.to permit_only_actions(%i[is_readonly index 
      number_of_room_issues_report room_issues_report inspection_rate_report no_access_report common_attribute_states_report 
      specific_attribute_states_report resource_states_report no_access_for_n_times_report not_checked_rooms_report]) }
  end

  context 'with admin role' do
    subject { described_class.new({ user: user, role: "admin" }, :report) }

    it { is_expected.to forbid_actions(%i[is_rover is_developer is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin index 
      number_of_room_issues_report room_issues_report inspection_rate_report no_access_report common_attribute_states_report 
      specific_attribute_states_report resource_states_report no_access_for_n_times_report not_checked_rooms_report]) }
  end

  context 'with developer role' do
    subject { described_class.new({ user: user, role: "developer" }, :report) }

    it { is_expected.to forbid_actions(%i[is_rover is_readonly]) }
    it { is_expected.to permit_only_actions(%i[is_admin is_developer index 
      number_of_room_issues_report room_issues_report inspection_rate_report no_access_report common_attribute_states_report 
      specific_attribute_states_report resource_states_report no_access_for_n_times_report not_checked_rooms_report]) }
  end

  context 'with no role' do
    subject { described_class.new({ user: user, role: "none" }, :report) }

    it { is_expected.to forbid_all_actions }
  end

end
