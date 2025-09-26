# frozen_string_literal: true

module BmrRecords
  module Serializers
    class BmrRecordSerializer
      def call(bmr_record)
        {
          id:              bmr_record.id,
          patient_id:      bmr_record.patient_id,
          mifflin_st_jeor: bmr_record.mifflin_st_jeor,
          harris_benedict: bmr_record.harris_benedict,
          created_at:      bmr_record.created_at
        }
      end
    end
  end
end
