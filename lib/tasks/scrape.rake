require 'open-uri'

namespace :scrape do
  desc 'Scrape all feeds'
  task all: [ :craigslist, :hicentral ]

  desc 'Scrape Craiglist'
  task craigslist: :environment do
    CraigslistFeed.new.scrape do |post|
      Rails.logger.info(:seed) { "Scraped #{post.link}" }
    end
  end

  desc 'Scrape HiCentral'
  task hicentral: :environment do
    HicentralFeed.new.scrape do |post|
      Rails.logger.info(:seed) { "Scraped #{post.link}" }
    end
  end
end
