class Post < ApplicationRecord
  class << self
    def seed(link)
      if(exists?(link: link))
        post = Post.find_by_link!(link)
        yield post
        post.save!
        post
      else
        find_or_create_by!(link: link) do |post|
          yield post
        end
      end
    end
  end
end
