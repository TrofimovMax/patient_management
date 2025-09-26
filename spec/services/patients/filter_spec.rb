# frozen_string_literal: true

# spec/services/patients/filter_spec.rb
require 'rails_helper'

RSpec.describe Patients::Filter do
  subject(:filter) { described_class.new(filter_attributes).call }

  let!(:first_patient) do
    create(:patient,
           first_name: "Ivan",
           last_name: "Ivanov",
           middle_name: "Ivanovich",
           birthday: Date.today - 35.years,
           gender: "male"
    )
  end

  let!(:second_patient) do
    create(:patient,
           first_name: "Maria",
           last_name: "Petrova",
           middle_name: "Sergeevna",
           birthday: Date.today - 25.years,
           gender: "female"
    )
  end

  let!(:third_patient) do
    create(:patient,
           first_name: "Ivan",
           last_name: "Sidorov",
           middle_name: "Petrovich",
           birthday: Date.today - 50.years,
           gender: "male"
    )
  end

  let(:filter_attributes) {}

  describe '#call' do
    context 'filter by full_name' do
      let(:filter_attributes) {{ full_name: 'Ivan' }}

      it 'returns patients matching full_name in any name field' do
        expect(filter).to include(first_patient, third_patient)
        expect(filter).not_to include(second_patient)
      end
    end

    context 'filter by gender' do
      let(:filter_attributes) {{ gender: 'female' }}

      it 'returns patients matching gender' do
        expect(filter).to include(second_patient)
        expect(filter).not_to include(first_patient, third_patient)
      end
    end

    context 'filter by start_age' do
      let(:filter_attributes) {{ start_age: 40 }}

      it 'returns patients older than start_age' do
        expect(filter).to include(third_patient)
        expect(filter).not_to include(first_patient, second_patient)
      end
    end

    context 'filter by end_age' do
      let(:filter_attributes) {{ end_age: 30 }}

      it 'returns patients younger than end_age' do
        expect(filter).to include(second_patient)
        expect(filter).not_to include(first_patient, third_patient)
      end
    end

    context 'filter by id' do
      let(:filter_attributes) {{ id: second_patient.id }}

      it 'returns patient with specific id' do
        expect(filter).to contain_exactly(second_patient)
      end
    end

    context 'combined filters' do
      let(:filter_attributes) {{ full_name: 'Ivan', gender: 'male', start_age: 40 }}

      it 'applies multiple filters correctly' do
        expect(filter).to contain_exactly(third_patient)
      end
    end

    context 'no params returns all' do
      let(:filter_attributes) {{}}

      it 'returns all patients if no params given' do
        expect(filter).to contain_exactly(first_patient, second_patient, third_patient)
      end
    end
  end
end
