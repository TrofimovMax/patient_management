# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :set_patient, only: %i[show edit update destroy]

  def index
    @patients = Patient.all
    render json: @patients
  end

  def show
    render json: @patient
  end

  def new
    @patient = Patient.new
    render json: @patient
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      render json: @patient, status: :created
    else
      render json: { errors: @patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    render json: @patient
  end

  def update
    if @patient.update(patient_params)
      render json: @patient
    else
      render json: { errors: @patient.errors.full_messages }, status: :unprocessable_entity
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
