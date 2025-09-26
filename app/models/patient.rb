# frozen_string_literal: true

class Patient < ApplicationRecord
  enum :gender, { male: 0, female: 1, other: 2 }, prefix: true, validate: true, default: :male

  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
  validates :middle_name, length: { maximum: 100 }, allow_blank: true

  validates :birthday, presence: true

  validates :gender, presence: true, inclusion: { in: genders.keys }

  validates :height, presence: true, numericality: { greater_than: 0 }
  validates :weight, presence: true, numericality: { greater_than: 0 }

  validates :first_name, uniqueness: { scope: [:last_name, :middle_name, :birthday] }
end
