# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

locations = ['about_page', 'rovers_form', 'preference_page', 'rovers_welcome_page'] #hardcoded locations
existing_locations = Announcement.all.pluck(:location)
locations.each do |location|
  unless existing_locations.include?(location)
    Announcement.create!(location: location)
  end
end

preferences = [
  {:name => 'no_access_reason', :description => "Comma-separated list of why you can't access a room", :pref_type => 'string'},
  {:name => 'supervisor_phone', :description => 'A phone to report to a supervisor', :pref_type => 'string'},
  {:name => 'resource_types', :description => 'Comma-separated list of resource types to add from WebCheckout', :pref_type => 'string'},
  {:name => 'tdx_lsa_ts_email', :description => 'An email address to create a TDX ticket with LSA TS', :pref_type => 'string', :value => "Technology Issues (all classrooms): LSATechnologyServices@umich.edu"},
  {:name => 'tdx_facilities_email', :description => 'An email address to create a TDX ticket with LSA Facilities', :pref_type => 'string', :value => "Facilities Issues (LSA classrooms): lsa-facilities@umich.edu"},
  {:name => 'dana_building_facility_issues_email', :description => 'An email address to report Dana Building Facility Issues', :pref_type => 'string', :value => "Dana Building Facility Issues: Email seas-facilities@umich.edu"},
  {:name => 'skb_facility_issues_email', :description => 'An email address to report SKB Building Facility Issues', :pref_type => 'string', :value => "SKB Facility Issues: Email facility manager ptitus@umich.edu"}
]
existing_preferences = AppPreference.all.pluck(:name)

preferences.each do |pref|
  unless existing_preferences.include?(pref[:name])
    AppPreference.create!(pref)
  end
end
