# frozen_string_literal: true

FactoryBot.define do
  factory :patient do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    middle_name { nil }
    birthday { Faker::Date.birthday(min_age: 0, max_age: 90) }
    gender { :male }
    height { Faker::Number.between(from: 150.0, to: 200.0) }
    weight { Faker::Number.between(from: 50.0, to: 120.0) }

    trait :with_two_attending_physicians do
      after(:create) do |patient|
        doctors = create_list(:attending_physician, 2)
        patient.attending_physicians << doctors
      end
    end
  end
end
