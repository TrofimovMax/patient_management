# frozen_string_literal: true

module Patients
  module Serializers
    class PatientSerializer
      def initialize(patient)
        @patient = patient
      end

      def as_json(*)
        {
          id: @patient.id,
          first_name: @patient.first_name,
          last_name: @patient.last_name,
          middle_name: @patient.middle_name,
          birthday: @patient.birthday,
          gender: @patient.gender,
          height: @patient.height,
          weight: @patient.weight,
          attending_physicians: serialized_attending_physicians
        }
      end

      private

      def serialized_attending_physicians
        @patient.attending_physicians.map do |physic|
          {
            id: physic.id,
            first_name: physic.first_name,
            last_name: physic.last_name,
            middle_name: physic.middle_name
          }
        end
      end
    end
  end
end
