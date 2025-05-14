require "jwt"

module Api
  module Admin
    class ClubsController < BaseController
      # Bắt buộc xác thực admin trước khi thực hiện bất kỳ action nào
      before_action :authenticate_admin!

      # Lấy danh sách các club, có thể lọc theo tên, quận, phố và phân trang
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

      # Lấy danh sách tất cả quận và phố để phục vụ cho việc tạo mới club
      def new
        @districts = ::District.all
        @streets = ::Street.all
        render json: { districts: @districts, streets: @streets }
      end

      # Lấy danh sách tất cả quận
      def districts
        districts = ::District.all
        render json: districts
      end

      # Lấy danh sách các phố thuộc quận được truyền vào
      def streets
        streets = ::Street.where(district_id: params[:district_id])
        render json: streets
      end

      # Tạo mới một club, đồng thời tạo luôn club manager mặc định và các bàn (table)
      def create
        club = ::Club.new(club_params)

        club.assign_attributes(
          country_id: 1,
          city_id: 1,
          club_managers_attributes: [
            {
              username: "club_manager",
              password: "123456",
              password_confirmation: "123456"
            }
          ]
        )

        if club.table_numbers.to_i > 0
          club.table_numbers.to_i.times do |i|
            club.tables.build(name: "Table #{i + 1}")
          end
        end

        if club.save
          render json: club, status: :created
        else
          render json: { errors: club.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # Lấy thông tin chi tiết một club để phục vụ cho việc chỉnh sửa
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

      # Cập nhật thông tin club
      def update
        club = ::Club.find(params[:id])

        if club.update(club_params)
          render json: club
        else
          render json: { errors: club.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # Xoá một club
      def destroy
        club = ::Club.find(params[:id])

        if club.destroy
          head :no_content
        else
          render json: { errors: club.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # Kích hoạt club (set active = true)
      def activate
        club = ::Club.find(params[:id])

        if club.update(active: true)
          render json: club
        else
          render json: { errors: club.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # Chỉ cho phép các trường này được truyền vào khi tạo/cập nhật club
      def club_params
        params.require(:club).permit(:district_id, :street_id, :name, :address, :description, :email, :active)
      end
    end
  end
end