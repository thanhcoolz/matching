class Api::Admin::AdminSessionsController < ApplicationController
  def create
    admin = Admin.find_by(email: params[:email])

    if admin&.authenticate(params[:password])
      render json: { message: "Sign-in successful", token: generate_token(admin) }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def generate_token(admin)
    # Placeholder for token generation logic (e.g., JWT)
    "dummy_token_for_#{admin.id}"
  end
end
