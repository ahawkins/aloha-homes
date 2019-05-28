class DashboardController < ApplicationController
  def show
    @posts = [ ]

    @posts.concat(scrape_hicentral)
    @posts.concat(scrape_craigslist)
    # @posts.concat(dummy_results)

    @posts.sort! do |p1, p2|
      p2.date <=> p1.date
    end
  end

  private
  def dummy_results
    [Post.new({
      price: 2300,
      bedrooms: 3,
      bathrooms: 2,
      cover: '/foo.jpg',
      link: 'https://dummy.com',
      date: Date.today,
      location: 'Fake'
    })]
  end

  def scrape_craigslist
    Rails.cache.fetch([ :feed, :craigslist ], expires: 1.hour) do
      rss = open('https://honolulu.craigslist.org/search/oah/apa?availabilityMode=0&format=rss&hasPic=1&housing_type=4&housing_type=6&housing_type=9&max_price=3000&min_bathrooms=2&min_bedrooms=2&pets_dog=1')
      feed = SimpleRSS.parse(rss)
      feed.items.map do |item|
        title = CGI.unescapeHTML(item.title)

        location = title.match(/.+\(([^\)]+)/)
        price = title.match(/\$(\d+)/)
        bedrooms = title.match(/(\d+)bd/)
        bathrooms = title.match(/(\d+)ba/)

        Post.new({
          price: price[1].to_i,
          bedrooms: bedrooms[1],
          bathrooms: bathrooms ? bathrooms[1] : '?',
          cover: item[:enc_enclosure_resource],
          link: item.link,
          date: item.dc_date,
          location: location ? location[1] : nil,
        })
      end
    end
  end

  def scrape_hicentral
    Rails.cache.fetch([ :feed, :hicentral ], expires: 1.hour) do
      first_page = 'http://propertysearch.hicentral.com/HBR/ForRent/?/Results/Neighborhood///295//128////////1/////3/////2/2//////////////2///'

      html = Nokogiri::HTML(open(first_page))

      posts = scrape_hicentral_results(html)

      page_links = html.css('div.P-ResultsHeader a').select do |element|
        element.text =~ /\d+/ && !first_page.ends_with?(element['href'])
      end.map do |element|
        element['href']
      end.uniq

      page_links.each_with_object(posts) do |path, bucket|
        html = Nokogiri::HTML(open("http://propertysearch.hicentral.com/#{path}"))

        bucket.concat(scrape_hicentral_results(html))
      end
    end
  end

  def scrape_hicentral_results(html)
    html.css('ul.P-Results > li.P-Active').map do |li|
      text = li.css('div.P-Results2').text.strip.lines.map(&:chomp).reject(&:blank?).join("\n")

      price = text.lines[0].gsub(/\D+/, '').to_i
      rooms = text.lines[1].split(', ')
      bed_rooms = rooms[0].split(' ').first
      bath_rooms = rooms[1].split(' ').first
      sqft = text.lines.last.split(' ').first.gsub(/\D+/, '').to_i

      text2 = li.css('div.P-Results1').text.strip.lines.map(&:chomp).reject(&:blank?).join("\n")
      text3 = li.css('div.P-Results3').text.strip.lines.map(&:chomp).reject(&:blank?).join("\n")

      date = Date.strptime(text3.lines.last.split(': ').last, '%m/%d/%Y')

      Post.new({
        price: price,
        bedrooms: bed_rooms,
        bathrooms: bath_rooms,
        sqft: sqft,
        cover: li.css('img').first['src'],
        location: text2.lines.last.split(', ').first.strip,
        link: "http://propertysearch.hicentral.com/HBR/ForRent/#{li.css('a').first['href']}",
        date: date
      })
    end
  end
end
