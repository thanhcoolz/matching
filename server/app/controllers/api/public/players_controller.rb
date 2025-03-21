module Api
  module Public
    class PlayersController < ApplicationController
      def register
        player = ::Player.new(player_params)
        player.country_id = 1
        player.city_id = 1

        if player_params[:avatar].present?
          player.avatar.attach(player_params[:avatar])
        end

        if player.save
          render json: { status: 'ok' }, status: :created
        else
          render json: { errors: player.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def player_params
        params.require(:player).permit(
          :username, :phone_number, :password, :password_confirmation,
          :district_id, :street_id, :age, :gender,
          :avatar,
        )
      end
    end
  end
end
