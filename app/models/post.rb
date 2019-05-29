class Post < ApplicationRecord
  class << self
    def toggle!(id:, flag:)
      if Rails.cache.exist?([ flag, id ])
        Rails.cache.increment([ flag, id ]) % 2 == 1
      else
        Rails.cache.write([ flag, id ], 1, raw: true)
        true
      end
    end

    def seed(link)
      if(exists?(link: link))
        Post.find_by_link!(link).save! do |post|
          yield post
        end
      else
        find_or_create_by!(link: link) do |post|
          yield post
        end
      end
    end
  end

  def liked?
    counter = Rails.cache.read([ :liked, id ]).to_i || 0
    (counter % 2 == 1).tap do |value|
      update_attribute(:liked, value) if self[:liked].nil?
    end
  end

  def discarded?
    counter = Rails.cache.read([ :discarded, id ]).to_i || 0
    (counter % 2 == 1).tap do |value|
      update_attribute(:discarded, value) if self[:liked].nil?
    end
  end

  def to_param
    id
  end

  def id
    Digest::MD5.hexdigest(link)
  end
end
