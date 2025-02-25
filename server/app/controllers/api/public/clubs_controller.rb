module Api
  module Public
    class ClubsController < ApplicationController
      include Pagy::Backend

      Pagy::DEFAULT[:items] = 12

      def index
        clubs = ::Club.includes(:district, :street)
                    .with_attached_main_image
                    .order(created_at: :desc)

        # Apply filters
        clubs = clubs.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
        clubs = clubs.where(district_id: params[:district_id]) if params[:district_id].present?
        clubs = clubs.where(street_id: params[:street_id]) if params[:street_id].present?

        @pagy, @clubs = pagy(clubs, page: params[:page], limit: params[:per_page] || 10)

        render json: {
          clubs: @clubs.map { |club|
            {
              id: club.id,
              name: club.name,
              address: club.full_address,
              description: club.description,
              main_image_url: club.main_image.attached? ? url_for(club.main_image) : nil
            }
          },
          pagination: {
            current_page: @pagy.page,
            total_pages: @pagy.pages,
            total_count: @pagy.count
          }
        }
      end

      def show
        @club = ::Club.includes(:district, :street)
                   .with_attached_main_image
                   .with_attached_sub_images
                   .find(params[:id])

        render json: {
          id: @club.id,
          name: @club.name,
          address: @club.full_address,
          description: @club.description,
          district_name: @club.district.name,
          street_name: @club.street.name,
          main_image_url: @club.main_image.attached? ? url_for(@club.main_image) : nil,
          sub_image_urls: @club.sub_images.map { |image| url_for(image) }
        }
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Club not found" }, status: :not_found
      end
    end
  end
end
