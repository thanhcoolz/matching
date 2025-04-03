module Api
  module Club
    class ReservationsController < BaseController
      before_action :authenticate_club_manager!

      def index
        reservations = @club.reservations

        if params[:status].present?
          reservations = reservations.where(status: params[:status])
        end

        render json: reservations
      end

      def update_status
        reservation = @club.reservations.find(params[:id])
        
        if reservation.update(status: params[:status])
          render json: reservation
        else
          render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Reservation not found' }, status: :not_found
      end

      private

      def fetch_club
        @club = ::Club.find(params[:club_id])
      end
    end
  end
end