module Api
  module Player
    class BaseController < ApplicationController
      before_action :authenticate_player!

      private

      def authenticate_player!
        token = cookies[:jwt]

        return render json: { error: "Unauthorized" }, status: :unauthorized unless token

        begin
          secret = ENV["JWT_SECRET"]
          raise JWT::DecodeError, "JWT_SECRET environment variable is not configured" unless secret
          payload = JWT.decode(token, secret, true, { algorithm: "HS256" }).first

          if Time.now.to_i > payload["exp"].to_i
            render json: { error: "Token expired" }, status: :unauthorized
            return
          end

          @current_player = ::Player.find(payload["player_id"])
        rescue JWT::DecodeError => e
          Rails.logger.error "JWT Decode Error: #{e.message}"
          render json: { error: "Invalid token" }, status: :unauthorized
        end
      end
    end
  end
end
