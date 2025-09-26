# frozen_string_literal: true

class BmrRecordsController < ApplicationController

  # GET /bmr_records?patient_id=&page=
  def index
    patient_id = params[:patient_id]
    unless patient_id.present?
      return render json: { error: 'patient_id is required' }, status: :unprocessable_content
    end

    bmr_records = BmrRecord.where(patient_id: patient_id)
                           .order(created_at: :desc)
                           .page(params[:page])
                           .per(20)
    serialized = bmr_records.map { |record| BmrRecords::Serializers::BmrRecordSerializer.new.call(record) }

    render json: {
      bmr_records: serialized,
      meta: {
        current_page: bmr_records.current_page,
        total_pages: bmr_records.total_pages,
        total_count: bmr_records.total_count
      }
    }, status: :ok
  end

  # POST /bmr_records
  def create
    validator = BmrRecords::Validations::CreateValidator.new(params.permit(:patient_id, :formula))
    unless validator.valid?
      return render json: { errors: validator.errors }, status: :unprocessable_content
    end

    service = BmrRecords::CreateService.new(params.permit(:patient_id, :formula))
    result = service.call

    if result[:errors]
      render json: result, status: :unprocessable_content
    else
      render json: result, status: :created
    end
  end
end
