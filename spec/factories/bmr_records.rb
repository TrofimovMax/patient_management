# frozen_string_literal: true

FactoryBot.define do
  factory :bmr_record do
    patient
    mifflin_st_jeor { 1500.5 }
    harris_benedict { nil }
  end
end
