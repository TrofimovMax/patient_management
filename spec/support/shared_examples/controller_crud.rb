# frozen_string_literal: true

RSpec.shared_examples "a JSON CRUD controller" do
  describe "GET #index" do
    it "returns a success response with paginated collection" do
      first_record = model_class.create!(valid_attributes)
      second_record = model_class.create!(valid_attributes.merge(first_name: 'Second'))
      third_record = model_class.create!(valid_attributes.merge(first_name: 'Third'))

      get url_helper(:index), params: { limit: 1, offset: 1 }

      expect(response).to have_http_status(:ok)

      expect(json_response.size).to eq(1)
      expect(json_response.first['id']).to eq(second_record.id)
    end
  end

  describe "GET #show" do
    it "returns a success response with the record" do
      record = model_class.create!(valid_attributes)
      get url_helper(:show, record), params: { id: record.id }
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(record.id)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new record" do
        expect {
          post url_helper(:create), params: { model_symbol => valid_attributes }
        }.to change(model_class, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "does not create new record and returns errors" do
        expect {
          post url_helper(:create), params: { model_symbol => invalid_attributes }
        }.to_not change(model_class, :count)
        expect(response).to have_http_status(:unprocessable_content)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      it "updates the requested record" do
        record = model_class.create!(valid_attributes)
        patch url_helper(:update, record), params: { id: record.id, model_symbol => new_attributes }
        expect(response).to have_http_status(:ok)
        record.reload
        new_attributes.each do |key, value|
          actual = record.send(key)
          expected = value

          expected = Date.parse(expected) if actual.is_a?(Date) && expected.is_a?(String)

          expect(actual).to eq(expected)
        end
      end
    end

    context "with invalid params" do
      it "does not update the record and returns errors" do
        record = model_class.create!(valid_attributes)  # добавьте эту строку
        patch url_helper(:update, record), params: { id: record.id, model_symbol => invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested record" do
      record = model_class.create!(valid_attributes)
      expect {
        delete url_helper(:destroy, record), params: { id: record.id }
      }.to change(model_class, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  # Helper to translate action to URL helper method dynamically
  def url_helper(action, record = nil)
    route = Rails.application.routes.url_helpers
    controller_name = model_symbol.to_s.pluralize
    case action
    when :index, :create
      route.send("#{controller_name}_path")
    when :show, :update, :destroy
      raise "Record must be provided for this action" unless record
      route.send("#{controller_name.singularize}_path", record)
    else
      raise "Unknown action #{action}"
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end