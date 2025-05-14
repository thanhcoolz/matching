module Api
  module Player
    class ReservationsController < BaseController
      # Bắt buộc xác thực player trước khi thực hiện bất kỳ action nào
      before_action :authenticate_player!

      # Lấy thông tin chi tiết một reservation theo id
      def show
        reservation = Reservation.find(params[:id])
        render json: {
          id: reservation.id,
          club_name: reservation.club.name,
          club_address: reservation.club.address,
          start_time: reservation.start_time.strftime("%Y-%m-%d %H:%M:%S"),
          duration_hours: reservation.duration_hours,
          reservation_type: reservation.reservation_type,
          number_of_player: reservation.number_of_player
        }
      rescue ActiveRecord::RecordNotFound
        # Nếu không tìm thấy reservation, trả về lỗi 404
        render json: { error: 'Reservation not found' }, status: :not_found
      end

      # Tạo mới một reservation cho player hiện tại
      def create
        Rails.logger.info "Creating reservation with params: #{reservation_params.inspect}"
        Rails.logger.info "Current player: #{@current_player.inspect}"

        club = ::Club.find(reservation_params[:club_id])

        # Kiểm tra club có tồn tại và đang hoạt động không
        if club.blank? || !club.active?
          return render json: { error: "Club not found or inactive" }, status: :not_found
        end

        # Gọi hàm kiểm tra và tạo reservation của club
        result = club.check_and_create_reservation(@current_player.id, reservation_params)

        if result[:success]
          render json: result[:reservation], status: :created
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      rescue StandardError => e
        # Ghi log lỗi và trả về lỗi 500 nếu có lỗi bất ngờ xảy ra
        Rails.logger.error "Error in reservation creation: #{e.message}"
        render json: { error: "An unexpected error occurred" }, status: :internal_server_error
      end

      # Lấy danh sách các reservation mà player hiện tại đã tham gia (trừ trạng thái pending)
      def index
        reservations = @current_player.reservation_parties
          .includes(reservation: :club)
          .joins(:reservation)
          .where.not(reservations: { status: :pending })
          .order('reservations.start_time DESC')
          .map do |party|
            reservation = party.reservation
            {
              id: reservation.id,
              club_name: reservation.club.name,
              start_time: reservation.start_time,
              duration_hours: reservation.duration_hours,
              reservation_type: reservation.reservation_type,
              number_of_player: reservation.number_of_player,
              status: reservation.status,
              is_host: party.is_host
            }
          end

        render json: reservations
      rescue StandardError => e
        # Ghi log lỗi và trả về lỗi 500 nếu có lỗi bất ngờ xảy ra
        Rails.logger.error "Error fetching reservations: #{e.message}"
        render json: { error: "An unexpected error occurred" }, status: :internal_server_error
      end

      # Cập nhật trạng thái thanh toán của reservation thành paid
      def update_payment_status
        reservation = Reservation.find(params[:id])
        
        if reservation.update(status: :paid)
          render json: reservation
        else
          render json: { error: reservation.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        # Nếu không tìm thấy reservation, trả về lỗi 404
        render json: { error: 'Reservation not found' }, status: :not_found
      end

      # Huỷ một reservation nếu chưa đến thời gian bắt đầu
      def cancel
        reservation = @current_player.reservations.find(params[:id])
        
        if reservation.start_time > Time.current
          if reservation.update(status: :canceled)
            render json: reservation
          else
            render json: { error: reservation.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Cannot cancel a reservation after its start time' }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        # Nếu không tìm thấy reservation, trả về lỗi 404
        render json: { error: 'Reservation not found' }, status: :not_found
      end

      private

      # (Không sử dụng trong controller này) - Hàm lấy reservation theo id trong club hiện tại
      def set_reservation
        @reservation = current_club.reservations.find(params[:id])
      end

      # Chỉ cho phép các trường này được truyền vào khi tạo reservation
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