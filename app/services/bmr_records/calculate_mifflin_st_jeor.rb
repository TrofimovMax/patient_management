# frozen_string_literal: true

module BmrRecords
  class CalculateMifflinStJeor
    include BmrHelper
    def call(patient)
      weight = patient.weight
      height = patient.height
      age = calculate_age(patient.birthday)
      gender = patient.gender

      base = 10 * weight + 6.25 * height - 5 * age
      gender == 'male' ? base + 5 : base - 161
    end
  end
end
