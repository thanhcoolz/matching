module Api
  class ClubsController < ApplicationController
    # Action trả về danh sách các club đang hoạt động, có thể lọc theo tên
    def index
      if params[:name].present?
        # Nếu có tham số name, lọc các club theo tên (LIKE)
        @clubs = ::Club.active.where("name LIKE ?", "%#{params[:name]}%")
                    .select(:id, :name, :email)
      else
        # Nếu không có tham số name, trả về mảng rỗng
        @clubs = []
      end

      # Trả về danh sách club dưới dạng JSON
      render json: @clubs
    end
  end
end