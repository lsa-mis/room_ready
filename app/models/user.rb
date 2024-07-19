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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:saml]

end
