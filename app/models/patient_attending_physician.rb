# frozen_string_literal: true

class PatientAttendingPhysician < ApplicationRecord
  belongs_to :patient
  belongs_to :attending_physician
end
