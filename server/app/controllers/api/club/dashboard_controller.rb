module Api
  module Club
    class DashboardController < BaseController
      before_action :authenticate_club_manager!

      def index
        confirmed_count = @club.reservations.where(status: 'confirmed').count
        stats = {
          total_reservations: @club.reservations.count,
          active_reservations: confirmed_count,
          revenue: confirmed_count * 80000, # 80.000 VND per confirmed reservation
          recent_reservations: @club.reservations.order(created_at: :desc).limit(5).as_json(
            include: {
              player: { only: [:id, :username, :phone_number], methods: [:avatar_url] }
            }
          )
        }

        render json: stats
      end
    end
  end
end