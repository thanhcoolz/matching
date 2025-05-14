require "jwt"

module Api
  module Club
    class SettingController < BaseController
      # Bắt buộc xác thực club manager trước khi thực hiện bất kỳ action nào
      before_action :authenticate_club_manager!
      # Cho phép sử dụng các helper để sinh URL cho ảnh
      include Rails.application.routes.url_helpers
      
      # Trả về thông tin profile của club hiện tại (bao gồm cả link ảnh)
      def show
        render json: {
          club: {
            id: @club.id,
            name: @club.name,
            email: @club.email,
            description: @club.description,
            main_image_url: @club.main_image.attached? ? url_for(@club.main_image) : nil,
            sub_image_urls: @club.sub_images.attached? ? @club.sub_images.map { |img| url_for(img) } : []
          }
        }
      end

      # Cập nhật thông tin profile của club (bao gồm cả ảnh đại diện và ảnh phụ)
      def update_profile
        if @club.update(club_profile_params)
          render json: {
            message: "Profile updated successfully",
            club: {
              id: @club.id,
              name: @club.name,
              email: @club.email,
              description: @club.description,
              main_image_url: @club.main_image.attached? ? url_for(@club.main_image) : nil,
              sub_image_urls: @club.sub_images.attached? ? @club.sub_images.map { |img| url_for(img) } : []
            }
          }
        else
          render json: { errors: @club.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # Chỉ cho phép các trường này được truyền vào khi cập nhật profile club
      def club_profile_params
        params.require(:club).permit(
          :name, :email, :description, :main_image, sub_images: []
        )
      end
    end
  end
end