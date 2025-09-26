# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BmrRecords::CalculateMifflinStJeor do
  subject(:service) { described_class.new }

  context 'when patient is male' do
    let(:patient) { create(:patient, weight: 70.0, height: 175.0, birthday: 30.years.ago.to_date, gender: 'male') }

    it 'calculates BMR according to Mifflin-St Jeor formula for males' do
      age = ((Date.today - patient.birthday).to_i / 365.25).floor
      expected = 10 * patient.weight + 6.25 * patient.height - 5 * age + 5
      expect(service.call(patient)).to be_within(0.01).of(expected)
    end
  end

  context 'when patient is female' do
    let(:patient) { create(:patient, weight: 60.0, height: 165.0, birthday: 28.years.ago.to_date, gender: 'female') }

    it 'calculates BMR according to Mifflin-St Jeor formula for females' do
      age = ((Date.today - patient.birthday).to_i / 365.25).floor
      expected = 10 * patient.weight + 6.25 * patient.height - 5 * age - 161
      expect(service.call(patient)).to be_within(0.01).of(expected)
    end
  end
end
