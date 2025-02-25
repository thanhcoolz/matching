module Api
  module Public
    class StreetsController < ApplicationController
      def index
        streets = Street.select(:id, :name)

        if params[:district_id].present?
          streets = streets.where(district_id: params[:district_id])
        end

        render json: streets
      end
    end
  end
end
