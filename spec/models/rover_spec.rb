# == Schema Information
#
# Table name: rovers
#
#  id         :bigint           not null, primary key
#  uniqname   :string
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Rover, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
