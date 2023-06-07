module Api
  module V1
    class HealthCheckController < ApplicationController
      def index
        head 200
        puts "Hello World!"
      end
    end
  end
end