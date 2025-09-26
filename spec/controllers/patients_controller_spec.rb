# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/controller_crud'

RSpec.describe PatientsController, type: :request do
  let(:model_class) { Patient }
  let(:model_symbol) { :patient }
  let(:valid_attributes) do
    {
      first_name: 'Ivan',
      last_name: 'Ivanov',
      middle_name: 'Ivanovich',
      birthday: '1980-01-01',
      gender: 'male',
      height: 175.0,
      weight: 70.0
    }
  end

  let(:invalid_attributes) do
    {
      first_name: nil
    }
  end

  let(:new_attributes) do
    {
      first_name: 'Eva',
      last_name: 'Ivanova',
      middle_name: 'Ivanovna',
      birthday: '1985-01-01',
      gender: 'female',
      height: 165.0,
      weight: 60.0
    }
  end

  it_behaves_like "a JSON CRUD controller"
end
