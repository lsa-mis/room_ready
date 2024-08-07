# == Schema Information
#
# Table name: resource_states
#
#  id            :bigint           not null, primary key
#  is_checked    :boolean
#  room_state_id :bigint           not null
#  resource_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class ResourceState < ApplicationRecord
  include Editable
  belongs_to :room_state
  belongs_to :resource

  validates :is_checked, inclusion: { in: [true, false], message: 'must be a present (either true or false)' }
  validate :is_editable, on: :update
  
end
