class CreatePatientAttendingPhysicians < ActiveRecord::Migration[8.0]
  def change
    create_table :patient_attending_physicians do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :attending_physician, null: false, foreign_key: true

      t.timestamps
    end

    add_index :patient_attending_physicians, [:patient_id, :attending_physician_id], unique: true, name: 'index_patient_physicians_on_patient_and_physician'
  end
end
