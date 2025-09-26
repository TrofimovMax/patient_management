# frozen_string_literal: true

class AttendingPhysician < ApplicationRecord
  has_many :patient_attending_physicians
  has_many :patients, through: :patient_attending_physicians

  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
end
