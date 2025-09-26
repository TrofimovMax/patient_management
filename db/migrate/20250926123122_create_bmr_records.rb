# frozen_string_literal: true

class CreateBmrRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :bmr_records do |t|
      t.float :mifflin_st_jeor
      t.float :harris_benedict
      t.references :patient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
