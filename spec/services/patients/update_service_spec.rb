# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patients::UpdateService, type: :service do
  subject(:service) { described_class.new(patient, attributes).call }

  let(:patient) { instance_double(Patient, attending_physicians: []) }

  let(:valid_attributes) do
    {
      first_name: "Ivan",
      last_name: "Ivanov",
      middle_name: "Ivanovich",
      birthday: Date.today - 30.years,
      gender: "male",
      height: 175.0,
      weight: 70.0,
      attending_physicians_ids: [1, 2]
    }
  end

  let(:invalid_attributes) { valid_attributes.merge(first_name: nil) }

  let(:attributes) { }

  describe '#call' do
    context 'with valid attributes' do
      let(:mock_relation) { double('ActiveRecord::Relation') }
      let(:attributes) { valid_attributes }

      before do
        allow(AttendingPhysician).to receive(:where).with(id: valid_attributes[:attending_physicians_ids]).and_return(mock_relation)
      end
      it 'updates patient and returns serialized json' do
        validator_double = instance_double('Patients::Validations::UpdateValidator',
                                           valid?: true,
                                           filtered_attributes: valid_attributes.except(:attending_physicians_ids),
                                           errors: double(full_messages: []))
        allow(Patients::Validations::UpdateValidator).to receive(:new).with(valid_attributes).and_return(validator_double)

        mock_relation = double('ActiveRecord::Relation')
        allow(AttendingPhysician).to receive(:where).with(id: valid_attributes[:attending_physicians_ids]).and_return(mock_relation)

        expect(patient).to receive(:update).with(validator_double.filtered_attributes).and_return(true)
        expect(patient).to receive(:attending_physicians=).with(mock_relation)

        serializer_double = instance_double('Serializers::PatientSerializer',
                                            as_json: { id: 1, first_name: 'Ivan' })
        allow(Patients::Serializers::PatientSerializer).to receive(:new).with(patient).and_return(serializer_double)

        expect(service).to eq({ id: 1, first_name: 'Ivan' })
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { invalid_attributes }

      let(:validator_double) do
        instance_double(
          Patients::Validations::UpdateValidator,
          valid?: false,
          errors: double(full_messages: ["first_name can't be blank"])
        )
      end

      before do
        allow(Patients::Validations::UpdateValidator).to receive(:new).with(invalid_attributes)
                                                                      .and_return(validator_double)
      end
      it 'returns validation errors' do
        expect(service).to eq({ errors: ["first_name can't be blank"] })
      end
    end

    context 'when update fails' do
      let(:attributes) { valid_attributes }
      let(:validator_double) do
        instance_double(
          Patients::Validations::UpdateValidator,
          valid?: true,
          filtered_attributes: valid_attributes.except(:attending_physicians_ids),
          errors: double(full_messages: [])
        )
      end

      before do
        allow(Patients::Validations::UpdateValidator).to receive(:new).with(valid_attributes)
                                                                      .and_return(validator_double)
        allow(patient).to receive(:errors).and_return(double(full_messages: ['update failed']))
      end

      it 'returns model errors' do
        expect(patient).to receive(:update).with(validator_double.filtered_attributes).and_return(false)
        expect(service).to eq({ errors: ['update failed'] })
      end
    end
  end
end
