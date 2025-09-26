# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttendingPhysician, type: :model do
  subject { build(:attending_physician) }

  describe 'database columns' do
    it do
      is_expected.to have_db_column(:first_name).of_type(:string)
      is_expected.to have_db_column(:last_name).of_type(:string)
      is_expected.to have_db_column(:middle_name).of_type(:string)
    end
  end

  describe 'validations' do
    it do
      is_expected.to validate_presence_of(:first_name)
      is_expected.to validate_presence_of(:last_name)
    end

    it 'allows blank middle_name' do
      expect(subject).to be_valid
    end
  end

  describe 'associations' do
    it do
      is_expected.to have_many(:patient_attending_physicians)
      is_expected.to have_many(:patients).through(:patient_attending_physicians)
    end
  end
end
