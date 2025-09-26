# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patient, type: :model do
  describe 'enum gender' do
    it { is_expected.to define_enum_for(:gender) }

    it 'validates inclusion of gender' do
      expect(subject).to allow_value('male').for(:gender)
      expect(subject).to allow_value('female').for(:gender)
      expect(subject).to allow_value('other').for(:gender)
      expect(subject).not_to allow_value('invalid').for(:gender)
    end
  end

  describe 'validations' do
    it do
      is_expected.to validate_presence_of(:first_name)
      is_expected.to validate_length_of(:first_name).is_at_most(100)

      is_expected.to validate_presence_of(:last_name)
      is_expected.to validate_length_of(:last_name).is_at_most(100)

      is_expected.to validate_length_of(:middle_name).is_at_most(100).allow_blank

      is_expected.to validate_presence_of(:birthday)

      is_expected.to validate_presence_of(:height)
      is_expected.to validate_numericality_of(:height).is_greater_than(0)

      is_expected.to validate_presence_of(:weight)
      is_expected.to validate_numericality_of(:weight).is_greater_than(0)
    end
  end

  describe 'columns' do
    subject { build(:patient) }

    it do
      is_expected.to have_db_column(:first_name).of_type(:string)
      is_expected.to have_db_column(:last_name).of_type(:string)
      is_expected.to have_db_column(:middle_name).of_type(:string)
      is_expected.to have_db_column(:birthday).of_type(:date)
      is_expected.to have_db_column(:gender).of_type(:integer)
      is_expected.to have_db_column(:height).of_type(:float)
      is_expected.to have_db_column(:weight).of_type(:float)
    end
  end

  describe 'uniqueness validation' do
    subject { build(:patient) }

    before do
      create(
        :patient,
        first_name: 'John',
        last_name: 'Pitters',
        middle_name: 'A',
        birthday: Date.new(1980, 1, 1),
        gender: 'male',
        height: 180.5,
        weight: 75.0
      )
    end

    it 'validates uniqueness of first_name, last_name, middle_name and birthday combination' do
      duplicate_patient = build(
        :patient,
        first_name: 'John',
        last_name: 'Pitters',
        middle_name: 'A',
        birthday: Date.new(1980, 1, 1),
        gender: 'female',
        height: 165.0,
        weight: 60.0
      )
      expect(duplicate_patient).not_to be_valid
      expect(duplicate_patient.errors[:first_name]).to include('has already been taken')
    end
  end
end
