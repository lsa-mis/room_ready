# == Schema Information
#
# Table name: app_preferences
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :string
#  pref_type   :integer
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class AppPreference < ApplicationRecord
  enum :pref_type, [:boolean, :integer, :string], prefix: true, scopes: true
  validates_presence_of :name, :description, :pref_type
  validates :name, uniqueness: true
end
