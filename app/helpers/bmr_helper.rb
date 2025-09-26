# frozen_string_literal: true

module BmrHelper
  def calculate_age(birthday)
    today = Date.today
    age = today.year - birthday.year
    if today.month < birthday.month || (today.month == birthday.month && today.day < birthday.day)
      age -= 1
    end
    age
  end
end
