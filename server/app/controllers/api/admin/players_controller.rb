module Api
  module Admin
    class PlayersController < BaseController
      before_action :authenticate_admin!

      def index
        players = ::Player.all.order(id: :desc)

        if params[:search].present?
          players = players.where('username LIKE :search OR phone_number LIKE :search', search: "%#{params[:search]}%")
        end

        pagy, paginated_players = pagy(players, page: params[:page], items: params[:per_page] || 10)

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
        render json: { error: 'Player not found' }, status: :not_found
      end
    end
  end
end