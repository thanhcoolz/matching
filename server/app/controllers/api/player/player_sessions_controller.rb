module Api
  module Player
    class PlayerSessionsController < ApplicationController
      # Cho phép sử dụng cookies trong controller
      include ActionController::Cookies
      # Định nghĩa thời gian hết hạn của JWT là 24 giờ
      JWT_EXPIRATION = 24.hours

      # Đăng nhập player, tạo JWT và lưu vào cookie nếu xác thực thành công
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

      # Kiểm tra tính hợp lệ của JWT token trong cookie
      def verify_token
        token = cookies[:jwt]
        return render json: { authenticated: false }, status: :unauthorized unless token

        begin
          secret = ENV["JWT_SECRET"]
          raise JWT::DecodeError, "JWT_SECRET environment variable is not configured" unless secret

          payload = JWT.decode(token, secret, true, { algorithm: "HS256" }).first

          if Time.now.to_i > payload["exp"].to_i
            render json: { authenticated: false, error: "Token expired" }, status: :unauthorized
            return
          end

          @player = ::Player.find_by(id: payload["player_id"])
          if @player
            render json: {
              authenticated: true,
              player: player_response_data
            }, status: :ok
          else
            render json: { authenticated: false }, status: :unauthorized
          end
        rescue JWT::DecodeError => e
          render json: { authenticated: false, error: "Invalid token" }, status: :unauthorized
        rescue StandardError => e
          render json: { authenticated: false, error: "Authentication failed" }, status: :unauthorized
        end
      end

      # Đăng xuất player, xoá cookie JWT
      def destroy
        cookies.delete(:jwt, httponly: true)
        render json: { message: "Logged out successfully" }, status: :ok
      end

      private

      # Sinh ra JWT token cho player với thời gian hết hạn
      def generate_token(player)
        secret = ENV["JWT_SECRET"]
        raise JWT::EncodeError, "JWT_SECRET environment variable is not configured" unless secret

        payload = {
          player_id: player.id,
          exp: JWT_EXPIRATION.from_now.to_i
        }
        JWT.encode(payload, secret, "HS256")
      end

      # Trả về thông tin cơ bản của player (username và avatar_url)
      def player_response_data
        {
          username: @player.username,
          avatar_url: @player.avatar_url
        }
      end

      # Thiết lập cookie JWT với các tuỳ chọn bảo mật
      def set_jwt_cookie(token)
        cookies[:jwt] = {
          value: token,
          httponly: true,
          secure: Rails.env.production?,
          same_site: :strict,
          expires: JWT_EXPIRATION.from_now
        }
      end

      # Lấy và cho phép các tham số cần thiết khi đăng nhập
      def session_params
        params.require(:session).permit(:phone_number, :password)
      end
    end
  end
end