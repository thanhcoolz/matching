require "jwt"
class Api::Admin::AdminSessionsController < ApplicationController
  include ActionController::Cookies
  JWT_SECRET = Rails.application.credentials.jwt_secret
  JWT_EXPIRATION = 24.hours

  def create
    admin = Admin.find_by(email: params[:email])

    if admin&.authenticate(params[:password])
      token = generate_token(admin)
      set_jwt_cookie(token)
      render json: { message: "Sign-in successful" }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    cookies.delete(:jwt, httponly: true)
    render json: { message: "Logged out successfully" }, status: :ok
  end

  private

  def generate_token(admin)
    payload = {
      admin_id: admin.id,
      exp: JWT_EXPIRATION.from_now.to_i
    }
    JWT.encode(payload, JWT_SECRET, "HS256")
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
end
