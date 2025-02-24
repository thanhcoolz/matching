module Api
  module Club
    class ClubSessionsController < BaseController
      include ActionController::Cookies
      JWT_EXPIRATION = 24.hours

      def create
        @club_manager = @club.club_managers.find_by(username: params[:username])

        if @club_manager&.authenticate(params[:password])
          token = generate_token(@club_manager)
          set_jwt_cookie(token)

          render json: {
            message: "Sign-in successful",
            club_manager: @club_manager,
            current_club: @club
          }, status: :ok
        else
          render json: {
            error: "Invalid email or password"
          }, status: :unauthorized
        end
      end

      def destroy
        cookies.delete(:jwt, httponly: true)
        render json: { message: "Logged out successfully" }, status: :ok
      end

      private

      def generate_token(club_manager)
        secret = ENV["JWT_SECRET"]
        raise JWT::EncodeError, "JWT_SECRET environment variable is not configured" unless secret

        payload = {
          club_manager_id: club_manager.id,
          club_id: @club.id,
          exp: JWT_EXPIRATION.from_now.to_i
        }
        JWT.encode(payload, secret, "HS256")
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
        params.require(:session).permit(:email, :password, :club_id)
      end
    end
  end
end
