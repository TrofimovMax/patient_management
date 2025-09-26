# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BmiCalculatorsController, type: :controller do
  let(:valid_params) { { weight: '87.9', height: '1.75' } }
  let(:invalid_params) { { weight: '', height: '' } }
  let(:service_result) do
    {
      'Category' => 'Overweight',
      'bmi' => 28.702,
      'height' => 1.75,
      'weight' => 87.9
    }
  end

  subject { post :create, params: params }

  context 'when parameters are invalid' do
    let(:params) { invalid_params }

    it 'returns unprocessable_content and does not call service' do
      expect_any_instance_of(ApiBmi::CalculatorService).not_to receive(:calculate)
      subject

      expect(response).to have_http_status(:unprocessable_content)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('weight and height are required params')
    end
  end

  context 'when parameters are valid' do
    let(:params) { valid_params }
    let(:service_double) { instance_double(ApiBmi::CalculatorService) }

    before do
      allow(ApiBmi::CalculatorService).to receive(:new).and_return(service_double)
      allow(service_double).to receive(:calculate).with(weight: 87.9, height: 1.75).and_return(service_result)
    end

    it 'calls ApiBmi::CalculatorService and returns serialized result' do
      subject

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['category']).to eq('Overweight')
      expect(json['bmi']).to eq(28.702)
      expect(json['height']).to eq(1.75)
      expect(json['weight']).to eq(87.9)
    end
  end

  context 'when service returns an error' do
    let(:params) { valid_params }
    let(:service_double) { instance_double(ApiBmi::CalculatorService) }

    before do
      allow(ApiBmi::CalculatorService).to receive(:new).and_return(service_double)
      allow(service_double).to receive(:calculate).and_return(error: 'API error')
    end

    it 'returns bad_gateway with error message' do
      subject

      expect(response).to have_http_status(:bad_gateway)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('API error')
    end
  end
end
