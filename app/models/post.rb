class Post
  include ActiveModel::Model

  attr_accessor :price
  attr_accessor :bedrooms, :bathrooms
  attr_accessor :sqft, :location
  attr_accessor :cover, :link
  attr_accessor :date

  class << self
    def toggle!(id:, flag:)
      if Rails.cache.exist?([ flag, id ])
        Rails.cache.increment([ flag, id ]) % 2 == 1
      else
        Rails.cache.write([ flag, id ], 1)
        true
      end
    end
  end

  def liked?
    counter = Rails.cache.read([ :liked, id ]) || 0
    counter % 2 == 1
  end

  def discarded?
    counter = Rails.cache.read([ :discarded, id ]) || 0
    counter % 2 == 1
  end

  def to_param
    id
  end

  def id
    Digest::MD5.hexdigest(link)
  end
end
