# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BmrRecordsController, type: :controller do
  let(:patient) { create(:patient) }
  let(:valid_params) { { patient_id: patient.id, formula: 'mifflin_st_jeor' } }
  let(:invalid_params) { { patient_id: nil, formula: 'invalid_formula' } }
  let(:service_result) do
    {
      id: 1,
      patient_id: patient.id,
      mifflin_st_jeor: 1600.0,
      harris_benedict: nil,
      created_at: Time.current
    }
  end

  describe 'POST #create' do
    context 'with valid params' do
      before do
        validator_double = instance_double(BmrRecords::Validations::CreateValidator, valid?: true, errors: [])
        allow(BmrRecords::Validations::CreateValidator).to receive(:new).and_return(validator_double)

        service_double = instance_double(BmrRecords::CreateService, call: service_result)
        allow(BmrRecords::CreateService).to receive(:new).and_return(service_double)
      end

      it 'returns created status and json with bmr_record' do
        post :create, params: valid_params

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['id']).to eq(service_result[:id])
        expect(json['patient_id']).to eq(service_result[:patient_id])
        expect(json['mifflin_st_jeor']).to eq(service_result[:mifflin_st_jeor])
        expect(json['harris_benedict']).to eq(service_result[:harris_benedict])
      end
    end

    context 'with invalid params (validation fails)' do
      before do
        validator_double = instance_double(BmrRecords::Validations::CreateValidator, valid?: false, errors: ['Invalid params'])
        allow(BmrRecords::Validations::CreateValidator).to receive(:new).and_return(validator_double)
      end

      it 'returns unprocessable_content and error messages' do
        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json['errors']).to include('Invalid params')
      end
    end

    context 'when service returns errors' do
      before do
        validator_double = instance_double(BmrRecords::Validations::CreateValidator, valid?: true, errors: [])
        allow(BmrRecords::Validations::CreateValidator).to receive(:new).and_return(validator_double)

        service_double = instance_double(BmrRecords::CreateService, call: { errors: ['Save failed'] })
        allow(BmrRecords::CreateService).to receive(:new).and_return(service_double)
      end

      it 'returns unprocessable_content and service errors' do
        post :create, params: valid_params

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json['errors']).to include('Save failed')
      end
    end
  end

  describe "GET /bmr_records" do
    let(:patient) { create(:patient) }
    let!(:bmr_records) { create_list(:bmr_record, 25, patient:) }

    context "when patient_id is missing" do
      it "returns unprocessable entity status" do
        get :index
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('patient_id is required')
      end
    end

    context "when patient_id is present" do
      it "returns first page of paginated bmr records" do
        get :index, params: { patient_id: patient.id, page: 1 }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['bmr_records'].length).to eq(20)
        expect(json['meta']['current_page']).to eq(1)
        expect(json['meta']['total_pages']).to eq(2)
        expect(json['meta']['total_count']).to eq(25)
      end

      it "returns second page of paginated bmr records" do
        get :index, params: { patient_id: patient.id, page: 2 }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['bmr_records'].length).to eq(5)
        expect(json['meta']['current_page']).to eq(2)
      end
    end
  end
end
