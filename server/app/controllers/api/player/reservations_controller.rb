module Api
  module Player
    class ReservationsController < BaseController
      before_action :authenticate_player!

      def create
        Rails.logger.info "Creating reservation with params: #{reservation_params.inspect}"
        Rails.logger.info "Current player: #{@current_player.inspect}"

        club = ::Club.find(reservation_params[:club_id])

        if club.blank? || !club.active?
          return render json: { error: "Club not found or inactive" }, status: :not_found
        end

        result = club.check_and_create_reservation(@current_player.id, reservation_params)

        if result[:success]
          render json: result[:reservation], status: :created
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      rescue StandardError => e
        Rails.logger.error "Error in reservation creation: #{e.message}"
        render json: { error: "An unexpected error occurred" }, status: :internal_server_error
      end

      private

      def set_reservation
        @reservation = current_club.reservations.find(params[:id])
      end

      def reservation_params
        params.require(:reservation).permit(
          :club_id,
          :table_id,
          :start_time,
          :duration_hours,
          :reservation_type,
          :status
        )
      end
    end
  end
end
