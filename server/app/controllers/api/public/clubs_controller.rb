module Api
  module Public
    class ClubsController < ApplicationController
      include Pagy::Backend

      Pagy::DEFAULT[:items] = 12

      def index
        clubs = ::Club.is_active.includes(:district, :street)
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
        @club = ::Club.is_active.includes(:district, :street)
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

      def register
        club = ::Club.new(club_register_params)

        club.assign_attributes(
          country_id: 1,
          city_id: 1,
          club_managers_attributes: [{
            username: "admin",
            password: "12341234",
            password_confirmation: "12341234"
          }]
        )

        # Build tables if table_numbers is present
        if club.table_numbers.to_i > 0
          club.table_numbers.to_i.times do |i|
            club.tables.build(name: "Table #{i + 1}")
          end
        end

        if club.save
          render json: {
            message: "Club registered successfully",
            club_id: club.id
          }, status: :created
        else
          render json: { errors: club.errors.full_messages }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: { errors: ["An unexpected error occurred"] }, status: :internal_server_error
      end

      private

      def club_register_params
        params.require(:club).permit(
          :name, :address, :description, :district_id,
          :street_id, :email, :table_numbers,
          :main_image, sub_images: [],
        )
      end
    end
  end
end
