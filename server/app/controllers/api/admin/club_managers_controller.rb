module Api
  module Admin
    class ClubManagersController < BaseController
      # Bắt buộc phải xác thực admin trước khi thực hiện bất kỳ action nào
      before_action :authenticate_admin!
      # Lấy thông tin club dựa vào params[:club_id] trước khi thực hiện action
      before_action :fetch_club

      # Lấy danh sách các club manager của một club, có thể lọc theo username
      def index
        managers = @club.club_managers

        if params[:username].present?
          managers = managers.where("username LIKE ?", "%#{params[:username]}%")
        end

        render json: managers
      end

      # Tạo mới một club manager cho club hiện tại
      def create
        manager = @club.club_managers.new(manager_params)

        if manager.save
          render json: manager, status: :created
        else
          render json: { errors: manager.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # Lấy thông tin chi tiết một club manager theo id
      def show
        manager = @club.club_managers.find(params[:id])

        render json: manager
      end

      # Cập nhật thông tin club manager theo id
      def update
        manager = @club.club_managers.find(params[:id])

        if manager.update(manager_params)
          render json: manager
        else
          render json: { errors: manager.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # Xoá một club manager theo id
      def destroy
        manager = @club.club_managers.find(params[:id])
        if manager.destroy
          head :no_content
        else
          render json: { errors: manager.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # Hàm lấy club dựa vào club_id truyền lên từ params
      def fetch_club
        @club = ::Club.find(params[:club_id])
      end

      # Chỉ cho phép các trường username, password, password_confirmation được truyền vào khi tạo/cập nhật manager
      def manager_params
        params.require(:club_manager).permit(:username, :password, :password_confirmation)
      end
    end
  end
end