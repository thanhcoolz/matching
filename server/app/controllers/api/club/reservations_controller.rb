module Api
  module Club
    class ReservationsController < BaseController
      before_action :authenticate_club_manager!

      def index
        reservations = @club.reservations.order(created_at: :desc)

        if params[:status].present?
          reservations = reservations.where(status: params[:status])
        end

        render json: reservations
      end

      def update_status
        reservation = @club.reservations.find(params[:id])
        
        ActiveRecord::Base.transaction do
          if reservation.update(status: params[:status])
            if params[:status] == 'confirmed' && !ReservationParty.exists?(reservation_id: reservation.id, player_id: reservation.player_id)
              ReservationParty.create!(
                reservation_id: reservation.id,
                player_id: reservation.player_id,
                is_host: true
              )
            end
            render json: reservation
          else
            render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
          end
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Reservation not found' }, status: :not_found
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def fetch_club
        @club = ::Club.find(params[:club_id])
      end
    end
  end
end