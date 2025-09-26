# frozen_string_literal: true

class BmrRecordsController < ApplicationController
  # POST /bmr_records
  def create
    validator = BmrRecords::Validations::CreateValidator.new(params.permit(:patient_id, :formula))
    unless validator.valid?
      return render json: { errors: validator.errors }, status: :unprocessable_entity
    end

    service = BmrRecords::CreateService.new(params.permit(:patient_id, :formula))
    result = service.call

    if result[:errors]
      render json: result, status: :unprocessable_entity
    else
      render json: result, status: :created
    end
  end
end
