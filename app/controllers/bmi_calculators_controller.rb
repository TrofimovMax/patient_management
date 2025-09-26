# frozen_string_literal: true

class BmiCalculatorsController < ApplicationController
  # POST /bmi_calculator
  def create
    weight = params[:weight]
    height = params[:height]

    if weight.blank? || height.blank?
      return render json: { error: 'weight and height are required params' }, status: :unprocessable_content
    end

    service = ApiBmi::CalculatorService.new
    result = service.calculate(weight: weight.to_f, height: height.to_f)

    if result[:error].present?
      render json: { error: result[:error] }, status: :bad_gateway
    else
      serialized = ApiBmi::Serializers::BaseSerializer.new.call(result)
      render json: serialized, status: :ok
    end
  end
end
