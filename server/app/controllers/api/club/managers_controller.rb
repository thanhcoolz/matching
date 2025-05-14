module Api
  module Club
    class ManagersController < BaseController
      # Bắt buộc xác thực club manager trước khi thực hiện bất kỳ action nào
      before_action :authenticate_club_manager!

      # Lấy danh sách các club manager (trừ chính mình), có thể lọc theo username
      def index
        managers = @club.club_managers.where.not(id: @current_manager.id)

        if params[:username].present?
          managers = managers.where("username LIKE ?", "%#{params[:username]}%")
        end

        render json: managers
      end

      # Tạo mới một club manager cho club hiện tại
      def create
        manager = @club.club_managers.new(create_params)

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

        if manager.update(update_params)
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

      # Cập nhật lại số lượng bàn của club (tăng/giảm số bàn)
      def update_table_numbers
        ActiveRecord::Base.transaction do
          current_table_count = @club.tables.count
          new_table_count = params[:table_numbers].to_i

          if new_table_count > current_table_count
            # Tạo thêm bàn mới nếu số lượng mới lớn hơn hiện tại
            (current_table_count + 1..new_table_count).each do |i|
              @club.tables.create!(name: "Table #{i}")
            end
          elsif new_table_count < current_table_count
            # Xoá các bàn thừa, ưu tiên xoá bàn tạo sau và không có reservation đang sử dụng
            tables_to_delete = @club.tables
              .where.not(id: @club.reservations.where(status: :confirmed).select(:table_id))
              .order(created_at: :desc)
              .limit(current_table_count - new_table_count)

            if tables_to_delete.count < (current_table_count - new_table_count)
              return render json: { errors: ["Cannot reduce tables: Some tables are currently in use"] }, status: :unprocessable_entity
            end

            tables_to_delete.destroy_all
          end

          if @club.update(table_numbers: new_table_count)
            render json: @club
          else
            render json: { errors: @club.errors.full_messages }, status: :unprocessable_entity
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: [e.message] }, status: :unprocessable_entity
      end

      private

      # (Không sử dụng trong controller này) - Hàm lấy club theo club_id từ params
      def fetch_club
        @club = ::Club.find(params[:club_id])
      end

      # Chỉ cho phép các trường này khi tạo manager
      def create_params
        params.require(:club_manager).permit(:username, :password, :password_confirmation)
      end

      # Chỉ cho phép các trường này khi cập nhật manager
      def update_params
        params.require(:club_manager).permit(:password, :password_confirmation)
      end
    end
  end
end