# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BmrRecords::Validations::CreateValidator do
  let(:patient) { create(:patient) }
  let(:attributes) { { patient_id: patient.id, formula: 'mifflin_st_jeor' } }

  subject(:validator) { described_class.new(attributes) }

  describe '#valid?' do
    context 'with valid attributes' do
      it 'returns true' do
        expect(validator.valid?).to be true
        expect(validator.errors).to be_empty
      end
    end

    context 'when patient_id is missing' do
      before { attributes[:patient_id] = nil }

      it 'returns false with an error' do
        expect(validator.valid?).to be false
        expect(validator.errors).to include('Invalid or missing patient_id')
      end
    end

    context 'when patient_id does not exist' do
      before { attributes[:patient_id] = 0 }

      it 'returns false with an error' do
        expect(validator.valid?).to be false
        expect(validator.errors).to include('Invalid or missing patient_id')
      end
    end

    context 'when formula is missing' do
      before { attributes[:formula] = nil }

      it 'returns false with an error' do
        expect(validator.valid?).to be false
        expect(validator.errors).to include('Unsupported formula')
      end
    end

    context 'when formula is unsupported' do
      before { attributes[:formula] = 'invalid_formula' }

      it 'returns false with an error' do
        expect(validator.valid?).to be false
        expect(validator.errors).to include('Unsupported formula')
      end
    end
  end
end
