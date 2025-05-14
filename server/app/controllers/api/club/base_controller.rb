require "jwt"

module Api
  module Club
    class BaseController < ApplicationController
      private

      # Hàm xác thực club manager dựa trên JWT lưu trong cookie
      def authenticate_club_manager!
        token = cookies[:jwt] # Lấy token JWT từ cookie
        Rails.logger.info "JWT Token: #{token.inspect}"
        # Nếu không có token thì trả về lỗi Unauthorized
        return render json: { error: "Unauthorized" }, status: :unauthorized unless token

        begin
          secret = ENV["JWT_SECRET"] # Lấy secret key từ biến môi trường
          raise JWT::DecodeError, "JWT_SECRET environment variable is not configured" unless secret
          # Giải mã token JWT, lấy payload
          payload = JWT.decode(token, secret, true, { algorithm: "HS256" }).first
          Rails.logger.info "Decoded Payload: #{payload.inspect}"

          # Kiểm tra token hết hạn chưa
          if Time.now.to_i > payload["exp"].to_i
            render json: { error: "Token expired" }, status: :unauthorized
            return
          end

          # Tìm club theo id trong payload, nếu không có thì báo lỗi
          @club = ::Club.find_by(id: payload["club_id"])
          raise StandardError, "Club not found" unless @club

          # Tìm club manager theo id trong club, nếu không có thì báo lỗi Unauthorized
          @current_manager = @club.club_managers.find_by(id: payload["club_manager_id"])
          render json: { error: "Unauthorized" }, status: :unauthorized unless @current_manager
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