module Api
  module Club
    class ClubSessionsController < BaseController
      # Cho phép sử dụng cookies trong controller
      include ActionController::Cookies
      # Định nghĩa thời gian hết hạn của JWT là 24 giờ
      JWT_EXPIRATION = 24.hours

      # Đăng nhập club manager, tạo JWT và lưu vào cookie nếu xác thực thành công
      def create
        @club = ::Club.active.find(params[:club_id])
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

      # Đăng xuất club manager, xoá cookie JWT
      def destroy
        cookies.delete(:jwt, httponly: true)
        render json: { message: "Logged out successfully" }, status: :ok
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

          club_manager = ::ClubManager.find_by(id: payload["club_manager_id"])
          club = ::Club.find_by(id: payload["club_id"])

          if club_manager && club
            render json: {
              authenticated: true,
              club_manager: club_manager,
              current_club: club
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

      private

      # Sinh ra JWT token cho club manager với thời gian hết hạn
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
        params.require(:session).permit(:email, :password, :club_id)
      end
    end
  end
end