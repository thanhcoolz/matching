module Api
  module Club
    class BaseController < ApplicationController
      before_action :find_club

      private

      def find_club
        @club = ::Club.find(params[:club_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Club not found" }, status: :not_found
      end
    end
  end
end
