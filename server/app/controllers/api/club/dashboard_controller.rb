module Api
  module Club
    class DashboardController < BaseController
      # Bắt buộc xác thực club manager trước khi truy cập dashboard
      before_action :authenticate_club_manager!

      # Action trả về các thống kê tổng quan cho dashboard của club
      def index
        confirmed_count = @club.reservations.where(status: 'confirmed').count # Đếm số lượt đặt bàn đã xác nhận
        stats = {
          total_reservations: @club.reservations.count, # Tổng số lượt đặt bàn của club
          active_reservations: confirmed_count, # Số lượt đặt bàn đã xác nhận
          revenue: confirmed_count * 80000, # Doanh thu tạm tính (80.000 VND cho mỗi lượt đặt đã xác nhận)
          recent_reservations: @club.reservations.order(created_at: :desc).limit(5).as_json(
            include: {
              player: { only: [:id, :username, :phone_number], methods: [:avatar_url] } # Thông tin người chơi của từng lượt đặt
            }
          )
        }

        # Trả về dữ liệu thống kê dưới dạng JSON
        render json: stats
      end
    end
  end
end