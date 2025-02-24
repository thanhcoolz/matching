module Api
  class ClubsController < ApplicationController
    def index
      if params[:name].present?
        @clubs = ::Club.where("name LIKE ?", "%#{params[:name]}%")
                    .select(:id, :name)
      else
        @clubs = []
      end

      render json: @clubs
    end
  end
end
