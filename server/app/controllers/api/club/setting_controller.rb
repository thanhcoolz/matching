require "jwt"

module Api
  module Club
    class SettingController < BaseController
      before_action :authenticate_club_manager!
      include Rails.application.routes.url_helpers
      
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

      def club_profile_params
        params.require(:club).permit(
          :name, :email, :description, :main_image, sub_images: []
        )
      end
    end
  end
end
