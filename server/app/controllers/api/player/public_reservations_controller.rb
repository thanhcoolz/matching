# frozen_string_literal: true

module Api
  module Player
    class PublicReservationsController < BaseController
      # Bắt buộc xác thực player trước khi thực hiện bất kỳ action nào
      before_action :authenticate_player!

      # Lấy danh sách các reservation công khai mà player hiện tại có thể tham gia
      def index
        public_reservations = Reservation
          .includes(:club)
          .where(reservation_type: :public, status: :confirmed)
          .where('start_time > ?', Time.current)
          .joins(:reservation_parties)
          .group('reservations.id')
          .having('reservations.number_of_player > COUNT(reservations_parties.id)')
          .where.not(
            id: ReservationParty.where(player_id: @current_player.id).select(:reservation_id)
          )
          .order(start_time: :asc)
          .map do |reservation|
            {
              id: reservation.id,
              club_name: reservation.club.name,
              start_time: reservation.start_time,
              duration_hours: reservation.duration_hours,
              number_of_player: reservation.number_of_player,
              current_players: reservation.reservation_parties.count
            }
          end

        render json: public_reservations
      rescue StandardError => e
        # Ghi log lỗi và trả về lỗi 500 nếu có lỗi bất ngờ xảy ra
        Rails.logger.error "Error fetching public reservations: #{e.message}"
        render json: { error: "An unexpected error occurred" }, status: :internal_server_error
      end

      # Cho phép player tham gia vào một reservation công khai
      def join
        reservation = Reservation.find(params[:id])
        
        # Kiểm tra reservation có phải là public không
        if reservation.reservation_type != 'public'
          return render json: { error: 'This is not a public reservation' }, status: :unprocessable_entity
        end

        # Kiểm tra reservation đã được xác nhận chưa
        if reservation.status != 'confirmed'
          return render json: { error: 'This reservation is not available' }, status: :unprocessable_entity
        end

        # Kiểm tra reservation đã bắt đầu chưa
        if reservation.start_time <= Time.current
          return render json: { error: 'This reservation has already started' }, status: :unprocessable_entity
        end

        current_players = reservation.reservation_parties.count
        # Kiểm tra reservation đã đủ số người chưa
        if current_players >= reservation.number_of_player
          return render json: { error: 'This reservation is full' }, status: :unprocessable_entity
        end

        # Kiểm tra player đã tham gia reservation này chưa
        if reservation.reservation_parties.exists?(player_id: @current_player.id)
          return render json: { error: 'You have already joined this reservation' }, status: :unprocessable_entity
        end

        # Thêm player vào reservation
        reservation_party = reservation.reservation_parties.create(player_id: @current_player.id)

        if reservation_party.persisted?
          render json: { message: 'Successfully joined the reservation' }, status: :created
        else
          render json: { error: reservation_party.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        # Nếu không tìm thấy reservation, trả về lỗi 404
        render json: { error: 'Reservation not found' }, status: :not_found
      rescue StandardError => e
        # Ghi log lỗi và trả về lỗi 500 nếu có lỗi bất ngờ xảy ra
        Rails.logger.error "Error joining reservation: #{e.message}"
        render json: { error: "An unexpected error occurred" }, status: :internal_server_error
      end
    end
  end
end