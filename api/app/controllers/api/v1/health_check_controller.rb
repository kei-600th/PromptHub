module Api
  module V1
    class HealthCheckController < ApplicationController
      # xhr_request?をスキップ
      skip_before_action :xhr_request?

      def index
        head :ok
      end
    end
  end
end
