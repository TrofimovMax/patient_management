# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BmrRecords::Serializers::BmrRecordSerializer do
  let(:patient) { create(:patient) }
  let(:bmr_record) do
    create(:bmr_record,
           patient: patient,
           mifflin_st_jeor: 1600.5,
           harris_benedict: 1550.2,
           created_at: Time.current
    )
  end

  subject(:serializer) { described_class.new.call(bmr_record) }

  describe '#call' do
    it 'returns expected serialized hash' do
      expect(serializer[:id]).to eq(bmr_record.id)
      expect(serializer[:patient_id]).to eq(patient.id)
      expect(serializer[:mifflin_st_jeor]).to eq(1600.5)
      expect(serializer[:harris_benedict]).to eq(1550.2)
      expect(serializer[:created_at].to_i).to eq(bmr_record.created_at.to_i)
    end
  end
end
