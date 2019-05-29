class HicentralFeed
  def scrape
    first_page = 'http://propertysearch.hicentral.com/HBR/ForRent/?/Results/Neighborhood///295//128////////1/////3/////2/2//////////////2///'

    html = Nokogiri::HTML(open(first_page))

    posts = scrape_page(html) do |post|
      yield post if block_given?
    end

    page_links = html.css('div.P-ResultsHeader a').select do |element|
      element.text =~ /\d+/ && !first_page.ends_with?(element['href'])
    end.map do |element|
      element['href']
    end.uniq

    page_links.each_with_object(posts) do |path, bucket|
      html = Nokogiri::HTML(open("http://propertysearch.hicentral.com/#{path}"))

      items = scrape_page(html) do |post|
        yield post if block_given?
      end

      posts.concat(items)
    end
  end

  def scrape_page(html)
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

      link = "http://propertysearch.hicentral.com/HBR/ForRent/#{li.css('a').first['href']}"

      Post.seed(link) do |post|
        post.price =  price,
        post.bedrooms =  bed_rooms
        post.bathrooms = bath_rooms
        post.sqft = sqft
        post.cover = li.css('img').first['src']
        post.location =  text2.lines.last.split(', ').first.strip
        post.date = date
      end.tap do |post|
        yield post if block_given?
      end
    end
  end
end
