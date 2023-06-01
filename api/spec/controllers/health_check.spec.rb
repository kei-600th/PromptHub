require 'rails_helper'

RSpec.describe "Api::V1::HealthCheck", type: :request do
  describe 'GET /api/v1/health_check' do
    before do
      get '/api/v1/health_check'
    end

    it 'returns HTTP status 200' do
      expect(response).to have_http_status(200)
    end
  end
end
