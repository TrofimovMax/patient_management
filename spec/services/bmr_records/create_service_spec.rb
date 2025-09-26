# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BmrRecords::CreateService do
  let(:patient) { create(:patient) }
  let(:attributes) { { patient_id: patient.id, formula: formula } }
  let(:formula) { 'mifflin_st_jeor' }

  subject(:service) { described_class.new(attributes) }

  describe '#call' do
    let(:mifflin_value) { 1600.0 }
    let(:harris_value) { 1550.0 }

    before do
      allow_any_instance_of(BmrRecords::CalculateMifflinStJeor).to receive(:call).with(patient).and_return(mifflin_value)
      allow_any_instance_of(BmrRecords::CalculateHarrisBenedict).to receive(:call).with(patient).and_return(harris_value)
    end

    context 'when formula is mifflin_st_jeor' do
      it 'creates BmrRecord with mifflin value and nil harris value' do
        result = service.call

        expect(result[:mifflin_st_jeor]).to eq(mifflin_value)
        expect(result[:harris_benedict]).to be_nil
      end

      it 'persists BmrRecord' do
        expect { service.call }.to change(BmrRecord, :count).by(1)
      end
    end

    context 'when formula is harris_benedict' do
      let(:formula) { 'harris_benedict' }

      it 'creates BmrRecord with harris value and nil mifflin value' do
        result = service.call

        expect(result[:harris_benedict]).to eq(harris_value)
        expect(result[:mifflin_st_jeor]).to be_nil
      end
    end

    context 'when BmrRecord save fails' do
      before do
        allow_any_instance_of(BmrRecord).to receive(:save).and_return(false)
        allow_any_instance_of(BmrRecord).to receive_message_chain(:errors, :full_messages).and_return(['error message'])
      end

      it 'returns errors' do
        expect(service.call).to eq(errors: ['error message'])
      end
    end
  end
end
