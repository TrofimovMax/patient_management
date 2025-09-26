# frozen_string_literal: true

module ApiBmi
  module Serializers
    class BaseSerializer
      def call(bmi_record)
        {
          category: bmi_record['Category'],
          bmi:      bmi_record['bmi'],
          height:   bmi_record['height'],
          weight:   bmi_record['weight'],
        }
      end
    end
  end
end
