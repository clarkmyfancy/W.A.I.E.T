# require 'yelp/fusion'
# @@client = Yelp::Fusion::Client.new("d-yJQSQLB6kXGGMW3-FDyGNeBXW-j89QbZxiWayPSg_9zKqo3IGyKhLZCXpDxM45ClJLMVoJzLt-w-FJBP4G4muQEq-PrNVw35r56-frAONXuqGPNlGGGFEqeZjGXHYx")

class ResultsController < ApplicationController
    
    def index 
        @cat = params[:categories]? [params[:categories].join(' ')] : ['food']
        @price_range = params[:prices]? [params[:prices].join(',')] : ['1,2,3,4']
        restaurants = Client.search(@cat, @price_range)
        restaurants = restaurants["businesses"].uniq {|biz| biz["name"] } unless restaurants == nil
        @size = restaurants.length()
        @count = params[:counter].to_i
        @restaurant = restaurants[@count]
    end

    def create
        redirect_to results_path(categories: params[:restCategory], prices: params[:restPrice], counter: params[:counter])
    end
end
