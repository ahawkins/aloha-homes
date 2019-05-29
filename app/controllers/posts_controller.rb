class PostsController < ApplicationController
  def like
    @post = Post.find(params[:id])
    @post.toggle!(:liked)
  end

  def discard
    @post = Post.find(params[:id])
    @post.toggle!(:discarded)
  end
end
