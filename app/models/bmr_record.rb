# frozen_string_literal: true

class BmrRecord < ApplicationRecord
  belongs_to :patient

  validates :patient, presence: true
  validates :mifflin_st_jeor, numericality: true, allow_nil: true
  validates :harris_benedict, numericality: true, allow_nil: true
  validate :at_least_one_formula_present

  private

  def at_least_one_formula_present
    if mifflin_st_jeor.blank? && harris_benedict.blank?
      errors.add(:base, "At least one of mifflin_st_jeor or harris_benedict must be present")
    end
  end
end
