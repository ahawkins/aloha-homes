class DashboardController < ApplicationController
  after_action :record_views

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

  private
  def record_views
    session[:viewed] ||= [ ]
    session[:viewed].concat(@posts.pluck(:id))
  end
end
