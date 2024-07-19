# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  email               :string           default(""), not null
#  encrypted_password  :string           default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string
#  last_sign_in_ip     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  uid                 :string
#  uniqname            :string
#  principal_name      :string
#  display_name        :string
#  person_affiliation  :string
#
FactoryBot.define do
  factory :user do
    uniqname { Faker::Alphanumeric.alpha(number: 8) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 10) }
    display_name { Faker::Name.name }
  end
end
