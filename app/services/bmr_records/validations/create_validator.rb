# frozen_string_literal: true

module BmrRecords
  module Validations
    class CreateValidator
      SUPPORTED_FORMULAS = %w[mifflin_st_jeor harris_benedict]

      def initialize(attributes)
        @attributes = attributes
        @errors = []
      end

      def valid?
        validate_patient_id
        validate_formula
        @errors.empty?
      end

      def errors
        @errors
      end

      private

      def validate_patient_id
        if @attributes[:patient_id].blank? || !Patient.exists?(@attributes[:patient_id])
          @errors << "Invalid or missing patient_id"
        end
      end

      def validate_formula
        formula = @attributes[:formula]
        unless SUPPORTED_FORMULAS.include?(formula)
          @errors << "Unsupported formula"
        end
      end
    end
  end
end
