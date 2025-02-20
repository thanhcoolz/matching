require "jwt"

module Api
  module Admin
    class ClubsController < ApplicationController
      before_action :authenticate_admin!

      def new
        @districts = District.all
        @streets = Street.all
        render json: { districts: @districts, streets: @streets }
      end

      def create
        club = Club.new(club_params)
        club.country_id = 1
        club.city_id = 1

        if club.save
          render json: club, status: :created
        else
          render json: { errors: club.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def club_params
        params.require(:club).permit(:district_id, :street_id, :name, :address, :description)
      end

      def authenticate_admin!
        token = cookies[:jwt]
        Rails.logger.info "JWT Token: #{token.inspect}"
        return render json: { error: "Unauthorized" }, status: :unauthorized unless token

        begin
          secret = ENV["JWT_SECRET"]
          raise JWT::DecodeError, "JWT_SECRET environment variable is not configured" unless secret
          payload = JWT.decode(token, secret, true, { algorithm: "HS256" }).first
          Rails.logger.info "Decoded Payload: #{payload.inspect}"

          if Time.now.to_i > payload["exp"].to_i
            render json: { error: "Token expired" }, status: :unauthorized
            return
          end

          @current_admin = ::Admin.find_by(id: payload["admin_id"])
          render json: { error: "Unauthorized" }, status: :unauthorized unless @current_admin
        rescue JWT::DecodeError => e
          Rails.logger.error "JWT Decode Error: #{e.message}"
          render json: { error: "Invalid token" }, status: :unauthorized
        rescue StandardError => e
          Rails.logger.error "Authentication Error: #{e.message}"
          render json: { error: "Authentication failed" }, status: :unauthorized
        end
      end
    end
  end
end
