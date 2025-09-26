# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BmrRecord, type: :model do
  let(:patient) { create(:patient) }

  subject { build(:bmr_record, patient:) }

  context 'columns' do
    it do
      is_expected.to have_db_column(:mifflin_st_jeor).of_type(:float)
      is_expected.to have_db_column(:harris_benedict).of_type(:float)
      is_expected.to have_db_column(:patient_id).of_type(:integer)
    end
  end

  context 'associations' do
    it { is_expected.to belong_to(:patient) }
  end

  context 'validations' do
    it "is valid with mifflin_st_jeor present" do
      subject.mifflin_st_jeor = 1600.0
      subject.harris_benedict = nil
      expect(subject).to be_valid
    end

    it "is valid with harris_benedict present" do
      subject.mifflin_st_jeor = nil
      subject.harris_benedict = 1550.0
      expect(subject).to be_valid
    end

    it "is invalid without mifflin_st_jeor and harris_benedict" do
      subject.mifflin_st_jeor = nil
      subject.harris_benedict = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:base]).to include("At least one of mifflin_st_jeor or harris_benedict must be present")
    end

    it "is invalid without patient" do
      subject.patient = nil
      expect(subject).not_to be_valid
    end

    it "is invalid if mifflin_st_jeor is not a number" do
      subject.mifflin_st_jeor = "not a number"
      expect(subject).not_to be_valid
    end

    it "is invalid if harris_benedict is not a number" do
      subject.harris_benedict = "not a number"
      expect(subject).not_to be_valid
    end
  end
end
