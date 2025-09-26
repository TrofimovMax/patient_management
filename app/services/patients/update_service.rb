# frozen_string_literal: true

# frozen_string_literal: true

module Patients
  class UpdateService
    def initialize(patient, attributes)
      @patient = patient
      @attributes = attributes
    end

    def call
      validator = Validations::UpdateValidator.new(@attributes)
      return error_response(validator.errors.full_messages) unless validator.valid?

      if @patient.update(validator.filtered_attributes)
        assign_attending_physicians
        success_response(@patient)
      else
        error_response(@patient.errors.full_messages)
      end
    end

    private

    def assign_attending_physicians
      if @attributes[:attending_physicians_ids].present?
        ids = @attributes[:attending_physicians_ids].map(&:to_i)
        @patient.attending_physicians = AttendingPhysician.where(id: ids)
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
