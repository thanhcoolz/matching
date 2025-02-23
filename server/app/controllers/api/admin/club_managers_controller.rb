module Api
  module Admin
    class ClubManagersController < BaseController
      before_action :authenticate_admin!
      before_action :fetch_club

      def index
        managers = @club.club_managers

        if params[:username].present?
          managers = managers.where("username LIKE ?", "%#{params[:username]}%")
        end

        render json: managers
      end

      def create
        manager = @club.club_managers.new(manager_params)

        if manager.save
          render json: manager, status: :created
        else
          render json: { errors: manager.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        manager = @club.club_managers.find(params[:id])

        render json: manager
      end

      def update
        manager = @club.club_managers.find(params[:id])

        if manager.update(manager_params)
          render json: manager
        else
          render json: { errors: manager.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        manager = @club.club_managers.find(params[:id])
        if manager.destroy
          head :no_content
        else
          render json: { errors: manager.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def fetch_club
        @club = Club.find(params[:club_id])
      end

      def manager_params
        params.require(:club_manager).permit(:username, :password, :password_confirmation)
      end
    end
  end
end
