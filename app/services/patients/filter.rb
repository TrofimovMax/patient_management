# frozen_string_literal: true

module Patients
  class Filter
    def initialize(params, initial_scope = Patient.all)
      @params = params
      @scope = initial_scope
    end

    def call
      filter_by_full_name
      filter_by_gender
      filter_by_age_range
      filter_by_id

      @scope
    end

    private

    def filter_by_full_name
      if @params[:full_name].present?
        patients_table = Patient.arel_table
        query = "%#{@params[:full_name]}%"

        condition = patients_table[:first_name].matches(query).or(
          patients_table[:last_name].matches(query)
        ).or(
          patients_table[:middle_name].matches(query)
        )

        @scope = @scope.where(condition)
      end
    end

    def filter_by_gender
      @scope = @scope.where(gender: @params[:gender]) if @params[:gender].present?
    end

    def filter_by_age_range
      today = Date.today
      if @params[:start_age].present?
        max_dob = today - @params[:start_age].to_i.years
        @scope = @scope.where('birthday <= ?', max_dob)
      end
      if @params[:end_age].present?
        min_dob = today - @params[:end_age].to_i.years
        @scope = @scope.where('birthday >= ?', min_dob)
      end
    end

    def filter_by_id
      @scope = @scope.where(id: @params[:id]) if @params[:id].present?
    end
  end
end
