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
  end
end
