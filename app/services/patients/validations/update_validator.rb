# frozen_string_literal: true

module Patients
  module Validations
    class UpdateValidator
      include ActiveModel::Model

      attr_accessor :attributes

      validates :first_name, presence: true, length: { maximum: 100 }
      validates :last_name, presence: true, length: { maximum: 100 }
      validates :middle_name, length: { maximum: 100 }, allow_blank: true
      validates :birthday, presence: true
      validates :gender, presence: true, inclusion: { in: %w[male female other] }
      validates :height, presence: true, numericality: { greater_than: 0 }
      validates :weight, presence: true, numericality: { greater_than: 0 }

      def initialize(attributes)
        @attributes = attributes
        assign_attributes
      end

      def assign_attributes
        attributes.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      attr_accessor :first_name, :last_name, :middle_name, :birthday, :gender, :height, :weight

      def filtered_attributes
        attributes.slice(
          :first_name, :last_name, :middle_name,
          :birthday, :gender, :height, :weight
        )
      end
    end
  end
end
