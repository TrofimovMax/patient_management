# frozen_string_literal: true

class AddUniqueIndexToPatients < ActiveRecord::Migration[8.0]
  def change
    add_index :patients, [:first_name, :last_name, :middle_name, :birthday], unique: true, name: 'index_patients_on_name_and_birthday'
  end
end
