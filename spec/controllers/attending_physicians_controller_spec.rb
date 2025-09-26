# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/controller_crud'

RSpec.describe AttendingPhysiciansController, type: :request do
  let(:valid_attributes) do
    {
      first_name: 'Ivan',
      last_name: 'Ivanov',
      middle_name: 'Ivanovich'
    }
  end

  let(:invalid_attributes) do
    {
      first_name: nil,
      last_name: nil
    }
  end

  let(:new_attributes) do
    {
      first_name: 'Eva',
      last_name: 'Ivanova',
      middle_name: 'Ivanovna'
    }
  end

  let(:model_class) { AttendingPhysician }
  let(:model_symbol) { :attending_physician }

  it_behaves_like "a JSON CRUD controller"
end
