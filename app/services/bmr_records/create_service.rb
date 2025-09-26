# frozen_string_literal: true

module BmrRecords
  class CreateService

    def initialize(attributes)
      @patient = Patient.find(attributes[:patient_id])
      @formula = attributes[:formula]
    end
    def call
      mifflin_value = CalculateMifflinStJeor.new.call(@patient)
      harris_value = CalculateHarrisBenedict.new.call(@patient)

      bmr_record = BmrRecord.new(patient: @patient)
      bmr_record.mifflin_st_jeor = @formula == 'mifflin_st_jeor' ? mifflin_value : nil
      bmr_record.harris_benedict = @formula == 'harris_benedict' ? harris_value : nil

      if bmr_record.save
        Serializers::BmrRecordSerializer.new.call(bmr_record)
      else
        { errors: bmr_record.errors.full_messages }
      end
    end
  end
end
