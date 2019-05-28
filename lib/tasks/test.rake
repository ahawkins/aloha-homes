require 'open-uri'

namespace :scrape do
  task hicentral: :environment do
    open('http://propertysearch.hicentral.com/HBR/ForRent/?/Results/Neighborhood//3/295//128////////1/////3/////2/2//////////////2///') do |body|
      html = Nokogiri::HTML(body)
      html.css('div.P-ResultsHeader a').select do |element|
        element.text =~ /\d+/
      end.each do |element|
        puts element['href']
      end
      # html.css('ul.P-Results > li.P-Active').each do |li|
      #   text = li.css('div.P-Results2').text.strip.lines.map(&:chomp).reject(&:blank?).join("\n")
      #
      #   price = text.lines[0].gsub(/\D+/, '').to_i
      #   rooms = text.lines[1].split(', ')
      #   bed_rooms = rooms[0].split(' ').first
      #   bath_rooms = rooms[1].split(' ').first
      #   sqft = text.lines.last.split(' ').first.gsub(/\D+/, '').to_i
      #
      #   puts price, bed_rooms, bath_rooms, sqft
      # end
    end
  end
end
