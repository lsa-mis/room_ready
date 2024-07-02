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

  validate :is_editable, on: :update

  private

  def readonly?
    self.updated_at < Time.current.beginning_of_day
  end
  
  def is_editable
    errors.add(:base, 'Old resource state record cannot be edited') if readonly?
  end
end
