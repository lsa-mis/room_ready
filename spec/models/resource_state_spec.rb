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
require 'rails_helper'

RSpec.describe ResourceState, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
