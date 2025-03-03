require "jwt"

module Api
  module Admin
    class ClubsController < BaseController
      before_action :authenticate_admin!

      def index
        clubs = ::Club.includes(:district, :street)
          .select("clubs.*, districts.name as district_name, streets.name as street_name")
          .joins(:district, :street)
          .order(created_at: :desc)

        if params[:name].present?
          clubs = clubs.where("clubs.name LIKE ?", "%#{params[:name]}%")
        end

        if params[:district_id].present?
          clubs = clubs.where(district_id: params[:district_id])
        end

        if params[:street_id].present?
          clubs = clubs.where(street_id: params[:street_id])
        end

        pagy, paginated_clubs = pagy(clubs, page: params[:page], limit: params[:per_page] || 10)

        render json: {
          clubs: paginated_clubs.as_json(
            methods: [ :district_name, :street_name ]
          ),
          pagination: {
            current_page: pagy.page,
            total_pages: pagy.pages,
            total_count: pagy.count,
            per_page: pagy.vars[:items]
          }
        }
      end

      def new
        @districts = ::District.all
        @streets = ::Street.all
        render json: { districts: @districts, streets: @streets }
      end

      def districts
        districts = ::District.all
        render json: districts
      end

      def streets
        streets = ::Street.where(district_id: params[:district_id])
        render json: streets
      end

      def create
        club = ::Club.new(club_params)

        club.assign_attributes(
          country_id: 1,
          city_id: 1,
          club_managers_attributes: [ { username: "admin", password: "12341234" } ]
        )

        club.country_id = 1
        club.city_id = 1

        if club.save
          render json: club, status: :created
        else
          render json: { errors: club.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def edit
        club = ::Club.find(params[:id])
        districts = ::District.all
        streets = ::Street.all

        render json: {
          club: club.as_json(),
          districts: districts,
          streets: streets
        }
      end

      def update
        club = ::Club.find(params[:id])

        if club.update(club_params)
          render json: club
        else
          render json: { errors: club.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        club = ::Club.find(params[:id])

        if club.destroy
          head :no_content
        else
          render json: { errors: club.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def activate
        club = ::Club.find(params[:id])

        if club.update(active: true)
          render json: club
        else
          render json: { errors: club.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def club_params
        params.require(:club).permit(:district_id, :street_id, :name, :address, :description, :email, :active)
      end
    end
  end
end
