# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patients::Validations::CreateValidator, type: :validator do
  subject(:validator) { described_class.new(attributes) }

  let(:attributes) do
    {
      first_name: 'Ivan',
      last_name: 'Ivanov',
      middle_name: 'Ivanovich',
      birthday: Date.today - 30.years,
      gender: 'male',
      height: 175.0,
      weight: 70.0
    }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(validator).to be_valid
    end

    it 'is invalid without first_name' do
      attributes[:first_name] = nil
      expect(validator).not_to be_valid
      expect(validator.errors[:first_name]).to contain_exactly('can\'t be blank')
    end

    it 'is invalid without last_name' do
      attributes[:last_name] = nil
      expect(validator).not_to be_valid
      expect(validator.errors[:last_name]).to contain_exactly('can\'t be blank')
    end

    it 'allows blank middle_name' do
      attributes[:middle_name] = nil
      expect(validator).to be_valid
    end

    it 'is invalid without birthday' do
      attributes[:birthday] = nil
      expect(validator).not_to be_valid
      expect(validator.errors[:birthday]).to contain_exactly('can\'t be blank')
    end

    it 'is invalid with invalid gender' do
      attributes[:gender] = 'unknown'
      expect(validator).not_to be_valid
      expect(validator.errors[:gender]).to contain_exactly('is not included in the list')
    end

    it 'is invalid without height' do
      attributes[:height] = nil
      expect(validator).not_to be_valid
      expect(validator.errors[:height]).to contain_exactly('can\'t be blank', 'is not a number')
    end

    it 'is invalid with non-positive height' do
      attributes[:height] = 0
      expect(validator).not_to be_valid
      expect(validator.errors[:height]).to contain_exactly('must be greater than 0')
    end

    it 'is invalid without weight' do
      attributes[:weight] = nil
      expect(validator).not_to be_valid
      expect(validator.errors[:weight]).to contain_exactly('can\'t be blank', 'is not a number')
    end

    it 'is invalid with non-positive weight' do
      attributes[:weight] = 0
      expect(validator).not_to be_valid
      expect(validator.errors[:weight]).to contain_exactly('must be greater than 0')
    end
  end

  describe '#filtered_attributes' do
    it 'returns only the allowed keys' do
      expect(validator.filtered_attributes.keys).to match_array(
        %i[first_name last_name middle_name birthday gender height weight]
      )
    end
  end
end
