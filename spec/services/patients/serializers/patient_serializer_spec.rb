# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patients::Serializers::PatientSerializer do
  subject(:serializer) { described_class.new(patient) }

  let(:patient) { create(:patient) }
  let(:first_physician) { create(:attending_physician) }
  let(:second_physician) { create(:attending_physician) }

  before do
    patient.attending_physicians << [first_physician, second_physician]
  end

  describe '#as_json' do
    it 'returns expected JSON structure' do
      json = serializer.as_json

      expect(json[:id]).to eq(patient.id)
      expect(json[:first_name]).to eq(patient.first_name)
      expect(json[:last_name]).to eq(patient.last_name)
      expect(json[:middle_name]).to eq(patient.middle_name)
      expect(json[:birthday]).to eq(patient.birthday)
      expect(json[:gender]).to eq(patient.gender)
      expect(json[:height]).to eq(patient.height)
      expect(json[:weight]).to eq(patient.weight)

      expect(json[:attending_physicians].size).to eq(2)
      expect(json[:attending_physicians]).to all(a_hash_including(:id, :first_name, :last_name, :middle_name))

      physician_ids = json[:attending_physicians].map { _1[:id] }
      expect(physician_ids).to contain_exactly(first_physician.id, second_physician.id)
    end
  end
end
