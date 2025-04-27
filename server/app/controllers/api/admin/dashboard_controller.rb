module Api
  module Admin
    class DashboardController < BaseController
      before_action :authenticate_admin!

      def index
        stats = {
          total_players: ::Player.count,
          total_clubs: ::Club.count,
          active_clubs: ::Club.where(active: true).count,
          total_reservations: ::Reservation.count,
          recent_players: ::Player.order(id: :desc).limit(5).as_json(
            only: [:id, :username, :phone_number],
            methods: [:avatar_url]
          ),
          recent_clubs: ::Club.order(id: :desc).limit(5).as_json(
            only: [:id, :name, :active],
            include: {
              district: { only: [:name] },
              street: { only: [:name] }
            }
          )
        }

        render json: stats
      end
    end
  end
end