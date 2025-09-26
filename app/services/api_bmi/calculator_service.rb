# frozen_string_literal: true

require 'httparty'

module ApiBmi
  class CalculatorService
    include HTTParty
    base_uri 'https://bmicalculatorapi.vercel.app'

    def calculate(weight:, height:)
      response = self.class.get("/api/bmi/#{weight}/#{height}")

      if response.success?
        response.parsed_response
      else
        { error: "API error: #{response.code}" }
      end
    rescue StandardError => e
      { error: "Request failed: #{e.message}" }
    end
  end
end
