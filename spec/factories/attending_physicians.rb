# frozen_string_literal: true

FactoryBot.define do
  factory :attending_physician do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    middle_name { nil }

    trait :with_two_patients do
      after(:create) do |doctor|
        patients = create_list(:patient, 2)
        doctor.patients << patients
      end
    end
  end
end
