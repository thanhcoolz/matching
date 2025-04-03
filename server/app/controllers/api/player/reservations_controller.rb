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

      def index
        reservations = @current_player.reservations
          .includes(:club)
          .order(start_time: :desc)
          .map do |reservation|
            {
              id: reservation.id,
              club_name: reservation.club.name,
              start_time: reservation.start_time,
              duration_hours: reservation.duration_hours,
              reservation_type: reservation.reservation_type,
              number_of_player: reservation.number_of_player,
              status: reservation.status
            }
          end

        render json: reservations
      rescue StandardError => e
        Rails.logger.error "Error fetching reservations: #{e.message}"
        render json: { error: "An unexpected error occurred" }, status: :internal_server_error
      end

      def update_payment_status
        reservation = Reservation.find(params[:id])
        
        if reservation.update(status: :paid)
          render json: reservation
        else
          render json: { error: reservation.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Reservation not found' }, status: :not_found
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
          :status,
          :number_of_player
        )
      end
    end
  end
end
