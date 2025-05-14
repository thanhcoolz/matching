module Api
  module Admin
    class PlayersController < BaseController
      # Bắt buộc xác thực admin trước khi thực hiện bất kỳ action nào
      before_action :authenticate_admin!

      # Lấy danh sách người chơi, có thể tìm kiếm theo username hoặc số điện thoại, và phân trang
      def index
        players = ::Player.all.order(id: :desc)

        # Nếu có tham số tìm kiếm, lọc theo username hoặc số điện thoại
        if params[:search].present?
          players = players.where('username LIKE :search OR phone_number LIKE :search', search: "%#{params[:search]}%")
        end

        # Phân trang kết quả trả về
        pagy, paginated_players = pagy(players, page: params[:page], items: params[:per_page] || 10)

        # Trả về danh sách người chơi cùng thông tin phân trang
        render json: {
          players: paginated_players.as_json(
            only: [:id, :username, :phone_number, :age, :gender],
            methods: [:avatar_url],
            include: {
              country: { only: [:id, :name] },
              city: { only: [:id, :name] },
              district: { only: [:id, :name] },
              street: { only: [:id, :name] }
            }
          ),
          pagination: {
            current_page: pagy.page,
            total_pages: pagy.pages,
            total_count: pagy.count,
            per_page: pagy.vars[:items]
          }
        }
      end

      # Lấy thông tin chi tiết một người chơi theo id
      def show
        player = ::Player.find(params[:id])
        render json: player.as_json(
          only: [:id, :username, :phone_number, :age, :gender],
          methods: [:avatar_url],
          include: {
            country: { only: [:id, :name] },
            city: { only: [:id, :name] },
            district: { only: [:id, :name] },
            street: { only: [:id, :name] }
          }
        )
      rescue ActiveRecord::RecordNotFound
        # Nếu không tìm thấy player, trả về lỗi 404
        render json: { error: 'Player not found' }, status: :not_found
      end
    end
  end
end