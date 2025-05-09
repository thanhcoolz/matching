module Api
  class ClubsController < ApplicationController
    def index
      if params[:name].present?
        @clubs = ::Club.active.where("name LIKE ?", "%#{params[:name]}%")
                    .select(:id, :name, :email)
      else
        @clubs = []
      end

      render json: @clubs
    end
  end
end
