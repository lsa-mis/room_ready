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
require 'rails_helper'

RSpec.describe AppPreference, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:app_preference)).to be_valid
    end
  end

  context "create app_preference with all required fields present" do
    it 'is valid' do
      expect(create(:app_preference)).to be_valid
    end
  end

  context "create app preference without a name" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Name can\'t be blank"' do
      expect { FactoryBot.create(:app_preference, name: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end
  end

  context "create app preference without a description" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Description can\'t be blank"' do
      expect { FactoryBot.create(:app_preference, description: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Description can't be blank")
    end
  end

  context "create app preference without a preference type" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Pref type can\'t be blank"' do
      expect { FactoryBot.create(:app_preference, pref_type: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Pref type can't be blank")
    end
  end
  
  context "create app preference without a preference type" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Pref type can\'t be blank"' do
      expect { FactoryBot.create(:app_preference, pref_type: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Pref type can't be blank")
    end
  end

  context "create app preference with a duplicated name" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Name has already been taken"' do
      app_preference = FactoryBot.create(:app_preference)
      app_preference1 = FactoryBot.build(:app_preference, name: app_preference.name)
      expect(app_preference1.valid?).to be_falsy
      expect(app_preference1.errors.full_messages_for(:name)).to include "Name has already been taken"

    end
  end
end
