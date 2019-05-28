require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    Rails.cache.clear
  end

  test "liking" do
    post = Post.new({
      link: 'https://example.com'
    })

    refute post.liked?

    Post.toggle!(id: post.id, flag: :liked)

    assert post.liked?

    Post.toggle!(id: post.id, flag: :liked)

    refute post.liked?
  end

  test "discarding" do
    post = Post.new({
      link: 'https://example.com'
    })

    refute post.discarded?

    Post.toggle!(id: post.id, flag: :discarded)

    assert post.discarded?

    Post.toggle!(id: post.id, flag: :discarded)

    refute post.discarded?
  end
end
