class PostsController < ApplicationController
  def like
    @liked = Post.toggle!(id: params[:id], flag: :liked)
  end

  def discard
    @discarded = Post.toggle!(id: params[:id], flag: :discarded)
  end
end
