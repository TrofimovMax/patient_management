# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :set_patient, only: %i[show edit update destroy]

  def index
    filtered_scope = Patients::Filter.new(params).call
    patients = filtered_scope.limit(params[:limit] || 20).offset(params[:offset] || 0)
    render json: patients
  end

  def show
    render json: @patient
  end

  def new
    @patient = Patient.new
    render json: @patient
  end

  def create
    service = Patients::CreateService.new(patient_params)
    result = service.call
    if result[:errors]
      render json: result, status: :unprocessable_content
    else
      render json: result, status: :created
    end
  end

  def edit
    render json: @patient
  end

  def update
    service = Patients::UpdateService.new(@patient, patient_params)
    result = service.call
    if result[:errors]
      render json: result, status: :unprocessable_content
    else
      render json: result
    end
  end

  def destroy
    @patient.destroy
    head :no_content
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(
      :first_name, :last_name, :middle_name, :birthday, :gender, :height, :weight
    )
  end
end
