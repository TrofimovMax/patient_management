# frozen_string_literal: true

class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.date :birthday, null: false
      t.integer :gender, default: 0, null: false
      t.float :height, null: false
      t.float :weight, null: false

      t.timestamps
    end
  end
end
