# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttendingPhysician, type: :model do
  subject { build(:attending_physician) }

  describe 'database columns' do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:middle_name).of_type(:string) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    it 'allows blank middle_name' do
      expect(subject).to be_valid
    end
  end
end
