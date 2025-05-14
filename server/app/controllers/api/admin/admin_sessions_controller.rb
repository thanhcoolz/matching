require "jwt"

class Api::Admin::AdminSessionsController < ApplicationController
  # Bao gồm module để sử dụng cookies trong controller
  include ActionController::Cookies
  # Định nghĩa thời gian hết hạn của JWT là 24 giờ
  JWT_EXPIRATION = 24.hours

  # Đăng nhập admin, tạo JWT và lưu vào cookie nếu xác thực thành công
  def create
    admin = ::Admin.find_by(email: params[:email])

    if admin&.authenticate(params[:password])
      token = generate_token(admin)
      set_jwt_cookie(token)
      render json: { status: :ok, admin: admin.as_json(only: [:email]) }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  # Đăng xuất admin, xoá cookie JWT
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

      admin = ::Admin.find_by(id: payload["admin_id"])
      if admin
        render json: { authenticated: true }, status: :ok
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

  # Sinh ra JWT token cho admin với thời gian hết hạn
  def generate_token(admin)
    secret = ENV["JWT_SECRET"]
    raise JWT::EncodeError, "JWT_SECRET environment variable is not configured" unless secret

    payload = {
      admin_id: admin.id,
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
end