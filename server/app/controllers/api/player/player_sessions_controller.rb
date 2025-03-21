module Api
  module Player
    class PlayerSessionsController < ApplicationController
      include ActionController::Cookies
      JWT_EXPIRATION = 24.hours

      def create
        @player = ::Player.find_by(phone_number: params[:phone_number])

        if @player&.authenticate(params[:password])
          token = generate_token(@player)
          set_jwt_cookie(token)

          render json: {
            status: 'ok',
            player: player_response_data
          }
        else
          render json: { error: "Invalid phone number or password" }, status: :not_found
        end
      end

      private

      def generate_token(player)
        secret = ENV["JWT_SECRET"]
        raise JWT::EncodeError, "JWT_SECRET environment variable is not configured" unless secret

        payload = {
          player_id: player.id,
          exp: JWT_EXPIRATION.from_now.to_i
        }
        JWT.encode(payload, secret, "HS256")
      end

      def player_response_data
        {
          username: @player.username,
          avatar_url: @player.avatar_url
        }
      end

      def set_jwt_cookie(token)
        cookies[:jwt] = {
          value: token,
          httponly: true,
          secure: Rails.env.production?,
          same_site: :strict,
          expires: JWT_EXPIRATION.from_now
        }
      end

      def session_params
        params.require(:session).permit(:phone_number, :password)
      end
    end
  end
end
