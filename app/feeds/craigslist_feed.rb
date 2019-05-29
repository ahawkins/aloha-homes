class CraigslistFeed
  FEED = 'https://honolulu.craigslist.org/search/oah/apa?availabilityMode=0&format=rss&hasPic=1&housing_type=4&housing_type=6&housing_type=9&max_price=3000&min_bathrooms=2&min_bedrooms=2&pets_dog=1'

  def scrape
    feed = SimpleRSS.parse(open(FEED))
    feed.items.map do |item|
      title = CGI.unescapeHTML(item.title)

      location = title.match(/.+\(([^\)]+)/)
      price = title.match(/\$(\d+)/)
      bedrooms = title.match(/(\d+)bd/)
      bathrooms = title.match(/(\d+)ba/)

      Post.seed(item.link) do |post|
        post.price = price[1].to_i
        post.bedrooms = bedrooms[1].to_i
        post.bathrooms = bathrooms ? bathrooms[1] : nil
        post.cover = item[:enc_enclosure_resource]
        post.date = item.dc_date
        post.location = location ? location[1] : nil
      end.tap do |post|
        yield post if block_given?
      end
    end
  end
end
