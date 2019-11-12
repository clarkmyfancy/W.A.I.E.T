require "json"
require "http"
require "optparse"

class Client < ApplicationRecord
  # Place holders for Yelp Fusion's API key. Grab it
  # from https://www.yelp.com/developers/v3/manage_app
  API_KEY = "d-yJQSQLB6kXGGMW3-FDyGNeBXW-j89QbZxiWayPSg_9zKqo3IGyKhLZCXpDxM45ClJLMVoJzLt-w-FJBP4G4muQEq-PrNVw35r56-frAONXuqGPNlGGGFEqeZjGXHYx"
  
  # Constants, do not change these
  API_HOST = "https://api.yelp.com"
  SEARCH_PATH = "/v3/businesses/search"
  BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
  
  DEFAULT_BUSINESS_ID = "yelp-san-francisco"
  DEFAULT_TERM = ['food']
  DEFAULT_LOCATION = "College Station, TX"
  DEFAULT_PRICE = "1"
  DEFAULT_OPEN = true
  SEARCH_LIMIT = 20
  
  term = ["breakfast", "dinner", "lunch", "mexican", "italian", "asian", "american", "vegetarian", "vegan", "fast food"]
  price = ["1", "2", "3"]
  
  
  # Make a request to the Fusion search endpoint. Full documentation is online at:
  # https://www.yelp.com/developers/documentation/v3/business_search
  #
  # term - search term used to find businesses
  # location - what geographic location the search should happen
  #
  # Examples
  #
  #   search("burrito", "san francisco")
  #   # => {
  #          "total": 1000000,
  #          "businesses": [
  #            "name": "El Farolito"
  #            ...
  #          ]
  #        }
  #
  #   search("sea food", "Seattle")
  #   # => {
  #          "total": 1432,
  #          "businesses": [
  #            "name": "Taylor Shellfish Farms"
  #            ...
  #          ]
  #        }
  #
  # Returns a parsed json object of the request
  def self.search(term=DEFAULT_TERM, price=DEFAULT_PRICE, open_now=DEFAULT_OPEN)
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
      term: term,
      location: DEFAULT_LOCATION,
      price: price,
      open_now: open_now,
      limit: SEARCH_LIMIT
    }
  
    response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
    response.parse
  end
  
  
  # Look up a business by a given business id. Full documentation is online at:
  # https://www.yelp.com/developers/documentation/v3/business
  # 
  # business_id - a string business id
  #
  # Examples
  # 
  #   business("yelp-san-francisco")
  #   # => {
  #          "name": "Yelp",
  #          "id": "yelp-san-francisco"
  #          ...
  #        }
  #
  # Returns a parsed json object of the request
  def business(business_id)
    url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}"
  
    response = HTTP.auth("Bearer #{API_KEY}").get(url)
    response.parse
  end
  
  
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Example usage: ruby sample.rb (search|lookup) [options]"
  
    opts.on("-tTERM", "--term=TERM", "Search term (for search)") do |term|
      options[:term] = term
    end
    
    opts.on("-pPRICE", "--price=PRICE", "Search price (for search)") do |price|
      options[:price] = price
    end
    
    opts.on("-oOPEN", "--open_now=OPEN", "Search open restaurants (for search)") do |open_now|
      options[:open_now] = open_now
    end
  
    opts.on("-bBUSINESS_ID", "--business-id=BUSINESS_ID", "Business id (for lookup)") do |id|
      options[:business_id] = id
    end
  
    opts.on("-h", "--help", "Prints this help") do
      puts opts
      exit
    end
  end.parse!
  
  
  command = ARGV
  
  
  case command.first
  when "search"
    term = options.fetch(:term, DEFAULT_TERM)
    price = options.fetch(:price, DEFAULT_PRICE)
    open_now = options.fetch(:open_now, DEFAULT_OPEN)
  
    raise "business_id is not a valid parameter for searching" if options.key?(:business_id)
  
    response = search(term, price, open_now)
  
    #puts "Found #{response["total"]} businesses. Listing #{SEARCH_LIMIT}:"
    businesses = response["businesses"].uniq {|biz| biz["name"] }
    businesses.each { |b| puts b["name"] }
    
  when "lookup"
    business_id = options.fetch(:business_id, DEFAULT_BUSINESS_ID)
  
    raise "term is not a valid parameter for lookup" if options.key?(:term)
    raise "price is not a valid parameter for lookup" if option.key?(:price)
    raise "open now is not a valid parameter for lookup" if option.key?(:open_now)
  
    response = business(business_id)
  
    puts "Found business with id #{business_id}:"
    puts JSON.pretty_generate(response)
  else
    puts "Please specify a command: search or lookup"
  end
end