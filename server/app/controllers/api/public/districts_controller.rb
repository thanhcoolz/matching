module Api
  module Public
    class DistrictsController < ApplicationController
      def index
        districts = ::District.select(:id, :name)
        render json: districts
      end
    end
  end
end
