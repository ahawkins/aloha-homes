class DashboardController < ApplicationController
  def show
    @posts = Post.order(date: :desc).to_a

    if(params[:liked])
      @posts.select!(&:liked?)
    end

    if(params[:discarded])
      @posts.select!(&:discarded?)
    else
      @posts.reject!(&:discarded?)
    end
  end
end
