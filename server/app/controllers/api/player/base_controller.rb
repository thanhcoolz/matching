module Api
  module Player
    class BaseController < ApplicationController
      # Bắt buộc xác thực player trước khi thực hiện bất kỳ action nào
      before_action :authenticate_player!

      private

      # Hàm xác thực player dựa trên JWT lưu trong cookie
      def authenticate_player!
        token = cookies[:jwt] # Lấy token JWT từ cookie

        # Nếu không có token thì trả về lỗi Unauthorized
        return render json: { error: "Unauthorized" }, status: :unauthorized unless token

        begin
          secret = ENV["JWT_SECRET"] # Lấy secret key từ biến môi trường
          raise JWT::DecodeError, "JWT_SECRET environment variable is not configured" unless secret
          # Giải mã token JWT, lấy payload
          payload = JWT.decode(token, secret, true, { algorithm: "HS256" }).first

          # Kiểm tra token hết hạn chưa
          if Time.now.to_i > payload["exp"].to_i
            render json: { error: "Token expired" }, status: :unauthorized
            return
          end

          # Tìm player theo id trong payload, nếu không có thì sẽ raise lỗi
          @current_player = ::Player.find(payload["player_id"])
        rescue JWT::DecodeError => e
          Rails.logger.error "JWT Decode Error: #{e.message}"
          render json: { error: "Invalid token" }, status: :unauthorized
        end
      end
    end
  end
end