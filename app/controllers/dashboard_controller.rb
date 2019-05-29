class DashboardController < ApplicationController
  def show
    @posts = Post.order(date: :desc)

    if(params[:liked])
      @posts = @posts.where(liked: true)
    end

    if(params[:discarded])
      @posts = @posts.where(discarded: true)
    else
      @posts = @posts.where(discarded: false)
    end
  end
end
