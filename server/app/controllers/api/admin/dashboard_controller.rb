module Api
  module Admin
    class DashboardController < BaseController
      # Bắt buộc xác thực admin trước khi truy cập dashboard
      before_action :authenticate_admin!

      # Action trả về các thống kê tổng quan cho dashboard admin
      def index
        stats = {
          # Tổng số người chơi
          total_players: ::Player.count,
          # Tổng số câu lạc bộ
          total_clubs: ::Club.count,
          # Số câu lạc bộ đang hoạt động
          active_clubs: ::Club.where(active: true).count,
          # Tổng số lượt đặt bàn
          total_reservations: ::Reservation.count,
          # 5 người chơi mới nhất (kèm avatar_url)
          recent_players: ::Player.order(id: :desc).limit(5).as_json(
            only: [:id, :username, :phone_number],
            methods: [:avatar_url]
          ),
          # 5 câu lạc bộ mới nhất (kèm tên quận, phố)
          recent_clubs: ::Club.order(id: :desc).limit(5).as_json(
            only: [:id, :name, :active],
            include: {
              district: { only: [:name] },
              street: { only: [:name] }
            }
          )
        }

        # Trả về dữ liệu thống kê dưới dạng JSON
        render json: stats
      end
    end
  end
end