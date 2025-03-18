module Api
  module Player
    class BaseController < ApplicationController
      before_action :authenticate_player!

      private

      def authenticate_player!

      end
    end
  end
end
