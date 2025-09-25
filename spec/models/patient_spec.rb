# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patient, type: :model do
  describe 'enum gender' do
    it 'contains correct keys and values' do
      expect(Patient.genders.keys).to contain_exactly('male', 'female', 'other')
      expect(Patient.genders.values).to contain_exactly(0, 1, 2)
    end
  end

  describe 'validations and attributes' do
    it 'can create a valid patient' do
      patient = Patient.new(
        first_name: 'John',
        last_name: 'Pitters',
        middle_name: '',
        birthday: Date.new(1980, 1, 1),
        gender: 'male',
        height: 180.5,
        weight: 75.0
      )
      expect(patient).to be_valid
    end

    it 'should respond to attributes' do
      patient = Patient.new
      expect(patient).to respond_to(:first_name)
      expect(patient).to respond_to(:last_name)
      expect(patient).to respond_to(:middle_name)
      expect(patient).to respond_to(:birthday)
      expect(patient).to respond_to(:gender)
      expect(patient).to respond_to(:height)
      expect(patient).to respond_to(:weight)
    end
  end
end
