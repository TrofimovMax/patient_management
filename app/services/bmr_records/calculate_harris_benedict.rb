# frozen_string_literal: true

module BmrRecords
  class CalculateHarrisBenedict
    include BmrHelper
    def call(patient)
      weight = patient.weight
      height = patient.height
      age = calculate_age(patient.birthday)
      gender = patient.gender

      if gender == 'male'
        88.362 + 13.397 * weight + 4.799 * height - 5.677 * age
      else
        447.593 + 9.247 * weight + 3.098 * height - 4.330 * age
      end
    end
  end
end
