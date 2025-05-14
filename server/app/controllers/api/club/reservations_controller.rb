module Api
  module Club
    class ReservationsController < BaseController
      # Bắt buộc xác thực club manager trước khi thực hiện bất kỳ action nào
      before_action :authenticate_club_manager!

      # Lấy danh sách các reservation của club, có thể lọc theo trạng thái
      def index
        reservations = @club.reservations.order(created_at: :desc)

        if params[:status].present?
          reservations = reservations.where(status: params[:status])
        end

        render json: reservations
      end

      # Cập nhật trạng thái của một reservation (ví dụ: xác nhận, huỷ, ...)
      def update_status
        reservation = @club.reservations.find(params[:id])
        
        ActiveRecord::Base.transaction do
          if reservation.update(status: params[:status])
            # Nếu xác nhận reservation và chưa có ReservationParty cho player này thì tạo mới
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
        # Nếu không tìm thấy reservation, trả về lỗi 404
        render json: { error: 'Reservation not found' }, status: :not_found
      rescue ActiveRecord::RecordInvalid => e
        # Nếu có lỗi khi tạo ReservationParty, trả về lỗi 422
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      #Hàm lấy club theo club_id từ params
      def fetch_club
        @club = ::Club.find(params[:club_id])
      end
    end
  end
end