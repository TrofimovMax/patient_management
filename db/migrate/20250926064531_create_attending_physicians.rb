# frozen_string_literal: true

class CreateAttendingPhysicians < ActiveRecord::Migration[8.0]
  def up
    create_table :attending_physicians do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.timestamps
    end
  end

  def down
    drop_table :attending_physicians
  end
end
