# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patients::CreateService, type: :service do
  subject(:service) { described_class.new(attributes).call }

  let(:valid_attributes) do
    {
      first_name: "Ivan",
      last_name: "Ivanov",
      middle_name: "Ivanovich",
      birthday: Date.new(1995, 1, 1),
      gender: "male",
      height: 175.0,
      weight: 70.0,
      attending_physicians_ids: [1, 2]
    }
  end

  let(:invalid_attributes) { valid_attributes.merge(first_name: nil) }

  let(:attributes) {}

  describe '#call' do
    let(:validator_double) do
      instance_double(
        Patients::Validations::CreateValidator,
        valid?: true,
        filtered_attributes: valid_attributes.except(:attending_physicians_ids))
    end

    let(:patient_double) { instance_double(Patient, id: 1, attending_physicians: []) }
    let(:serializer_double) do
      instance_double(Patients::Serializers::PatientSerializer, as_json: { id: patient_double.id })
    end

    context 'when valid attributes' do
      let(:attributes) { valid_attributes }

      before do
        allow(Patients::Validations::CreateValidator).to receive(:new).with(valid_attributes).and_return(validator_double)
        allow(Patients::Serializers::PatientSerializer).to receive(:new).with(patient_double).and_return(serializer_double)
      end
      it 'creates patient and returns serialized JSON' do
        expect(Patient).to receive(:new).with(validator_double.filtered_attributes).and_return(patient_double)
        expect(patient_double).to receive(:save).and_return(true)
        expect(patient_double).to receive(:attending_physicians=)
                                    .with(AttendingPhysician.where(id: valid_attributes[:attending_physicians_ids]))
        expect(service).to eq({ id: 1 })
      end
    end

    context 'when invalid attributes' do
      let(:attributes) { invalid_attributes }
      let(:validator_double) do
        instance_double(
          Patients::Validations::CreateValidator,
          valid?: false,
          errors: double(full_messages: ['first_name can\'t be blank'])
        )
      end

      before do
        allow(Patients::Validations::CreateValidator).to receive(:new).with(invalid_attributes)
                                                                      .and_return(validator_double)
      end
      it 'returns errors from validator' do
        expect(service).to eq({ errors: ["first_name can't be blank"] })
      end
    end

    context 'when save fails' do
      let(:attributes) { valid_attributes }
      let(:validator_double) do
        instance_double(
          Patients::Validations::CreateValidator,
          valid?: true,
          filtered_attributes: valid_attributes.except(:attending_physicians_ids)
        )
      end

      let(:patient_double) do
        instance_double(Patient, errors: double(full_messages: ['error saving']), attending_physicians: [])
      end

      before do
        allow(Patients::Validations::CreateValidator).to receive(:new).with(valid_attributes)
                                                                      .and_return(validator_double)
      end
      it 'returns patient save errors' do
        expect(Patient).to receive(:new).with(validator_double.filtered_attributes).and_return(patient_double)
        expect(patient_double).to receive(:save).and_return(false)

        expect(service).to eq({ errors: ['error saving'] })
      end
    end
  end
end
