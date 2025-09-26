# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BmrRecords::CalculateHarrisBenedict do
  subject(:service) { described_class.new }

  context 'when patient is male' do
    let(:patient) { create(:patient, weight: 70.0, height: 175.0, birthday: 30.years.ago.to_date, gender: 'male') }

    it 'calculates BMR according to Harris-Benedict formula for males' do
      age = ((Date.today - patient.birthday).to_i / 365.25).floor
      expected = 88.362 + 13.397 * patient.weight + 4.799 * patient.height - 5.677 * age
      expect(service.call(patient)).to be_within(0.01).of(expected)
    end
  end

  context 'when patient is female' do
    let(:patient) { create(:patient, weight: 60.0, height: 165.0, birthday: 28.years.ago.to_date, gender: 'female') }

    it 'calculates BMR according to Harris-Benedict formula for females' do
      age = ((Date.today - patient.birthday).to_i / 365.25).floor
      expected = 447.593 + 9.247 * patient.weight + 3.098 * patient.height - 4.330 * age
      expect(service.call(patient)).to be_within(0.01).of(expected)
    end
  end
end
