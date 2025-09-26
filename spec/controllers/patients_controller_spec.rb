require 'rails_helper'

RSpec.describe "Patients", type: :request do
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

  def json
    JSON.parse(response.body)
  end

  describe "GET /index" do
    it "returns a successful response with patients list" do
      patient = Patient.create! valid_attributes
      get patients_path
      expect(response).to be_successful
      expect(json).to contain_exactly(
        a_hash_including(
          'id' => patient.id,
          'first_name' => patient.first_name,
          'last_name' => patient.last_name
        )
      )
    end
  end

  describe "GET /show" do
    it "returns a successful response with patient" do
      patient = Patient.create! valid_attributes
      get patient_path(patient)
      expect(response).to be_successful
      expect(json).to a_hash_including(
        'id' => patient.id,
        'first_name' => patient.first_name,
        'last_name' => patient.last_name
      )
    end
  end

  describe "GET /new" do
    it "returns a new patient json object" do
      get new_patient_path
      expect(response).to be_successful
      expect(json).to a_hash_including(
        'id' => nil,
        'first_name' => nil,
        'last_name' => nil
      )
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Patient" do
        expect {
          post patients_path, params: { patient: valid_attributes }
        }.to change(Patient, :count).by(1)
      end

      it "returns created patient json with status 201" do
        post patients_path, params: { patient: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(json).to a_hash_including(
          'first_name' => 'Ivan',
          'last_name' => 'Ivanov'
        )
      end
    end

    context "with invalid parameters" do
      it "does not create a new Patient" do
        expect {
          post patients_path, params: { patient: invalid_attributes }
        }.not_to change(Patient, :count)
      end

      it "returns errors json with status 422" do
        post patients_path, params: { patient: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
        expect(json['errors']).to a_hash_including("First name can't be blank")
      end
    end
  end

  describe "GET /edit" do
    it "returns the existing patient as json" do
      patient = Patient.create! valid_attributes
      get edit_patient_path(patient)
      expect(response).to be_successful
      expect(json).to a_hash_including('id' => patient.id)
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) { { first_name: "Peter" } }

    context "with valid parameters" do
      it "updates the requested patient" do
        patient = Patient.create! valid_attributes
        patch patient_path(patient), params: { patient: new_attributes }
        patient.reload
        expect(patient.first_name).to eq("Peter")
      end

      it "returns the updated patient json" do
        patient = Patient.create! valid_attributes
        patch patient_path(patient), params: { patient: new_attributes }
        expect(response).to be_successful
        expect(json).to a_hash_including('first_name' => 'Peter')
      end
    end

    context "with invalid parameters" do
      it "does not update the patient" do
        patient = Patient.create! valid_attributes
        patch patient_path(patient), params: { patient: invalid_attributes }
        patient.reload
        expect(patient.first_name).to eq("Ivan")
      end

      it "returns errors json with status 422" do
        patient = Patient.create! valid_attributes
        patch patient_path(patient), params: { patient: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
        expect(json['errors']).to a_hash_including("First name can't be blank")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested patient" do
      patient = Patient.create! valid_attributes
      expect {
        delete patient_path(patient)
      }.to change(Patient, :count).by(-1)
    end

    it "returns no content status" do
      patient = Patient.create! valid_attributes
      delete patient_path(patient)
      expect(response).to have_http_status(:no_content)
    end
  end
end
