# == Schema Information
#
# Table name: resource_states
#
#  id            :bigint           not null, primary key
#  status        :string
#  is_checked    :boolean
#  room_state_id :bigint           not null
#  resource_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class ResourceState < ApplicationRecord
  belongs_to :room_state
  belongs_to :resource

  validates_inclusion_of :is_checked, in: [true, false], message: 'must be selected'

  # validate :resource_must_be_checked

  # private

  # # Custom validation
  # def resource_must_be_checked
  #   errors.add(:is_checked, "Resource must be checked") unless is_checked != nil
  # end

end
