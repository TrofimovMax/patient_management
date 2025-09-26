# frozen_string_literal: true

module Patients
  class CreateService
    def initialize(attributes)
      @attributes = attributes
    end

    def call
      validator = Validations::CreateValidator.new(@attributes)
      if validator.valid?
        patient = Patient.new(validator.filtered_attributes)
        if patient.save
          assign_attending_physicians(patient)
          success_response(patient)
        else
          error_response(patient.errors.full_messages)
        end
      else
        error_response(validator.errors.full_messages)
      end
    end

    private

    def assign_attending_physicians(patient)
      if @attributes[:attending_physicians_ids].present?
        ids = @attributes[:attending_physicians_ids].map(&:to_i)
        patient.attending_physicians = AttendingPhysician.where(id: ids)
      end
    end

    def success_response(patient)
      Serializers::PatientSerializer.new(patient).as_json
    end

    def error_response(errors)
      { errors: errors }
    end
  end
end
