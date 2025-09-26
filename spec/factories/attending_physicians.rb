# frozen_string_literal: true

FactoryBot.define do
  factory :attending_physician do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    middle_name { nil }
  end
end
