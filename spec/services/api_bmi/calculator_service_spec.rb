# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiBmi::CalculatorService do
  let(:service) { described_class.new }
  let(:weight) { 87.9 }
  let(:height) { 1.75 }

  it 'fetches and serializes BMI calculation' do
    VCR.use_cassette('bmi_calculation/87.9_1.75') do
      result = service.calculate(weight: weight, height: height)
      serialized = ApiBmi::Serializers::BaseSerializer.new.call(result)

      expect(serialized[:category]).to eq(result['Category'])
      expect(serialized[:bmi]).to be_within(0.001).of(result['bmi'])
      expect(serialized[:height]).to eq(height)
      expect(serialized[:weight]).to eq(weight)
    end
  end
end
