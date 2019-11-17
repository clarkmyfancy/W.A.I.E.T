# require 'yelp/fusion'
# @@client = Yelp::Fusion::Client.new("d-yJQSQLB6kXGGMW3-FDyGNeBXW-j89QbZxiWayPSg_9zKqo3IGyKhLZCXpDxM45ClJLMVoJzLt-w-FJBP4G4muQEq-PrNVw35r56-frAONXuqGPNlGGGFEqeZjGXHYx")

class ResultsController < ApplicationController

    def index 
        @cat = params[:categories]? [params[:categories].join(' ')] : ['food']
        @prices = params[:prices]? [params[:prices].join(',')] : ['1,2,3,4']
        restaurants = Client.search(@cat, @prices)
        @restaurants = restaurants["businesses"].uniq {|biz| biz["name"] } unless restaurants == nil
    end

    def create
        if params[:restCategory] && params[:restPrice]
            redirect_to results_path(categories: params[:restCategory], prices: params[:restPrice])
        elsif params[:restCategory]
            redirect_to results_path(categories: params[:restCategory])
        elsif params[:restPrice]
            redirect_to results_path(prices: params[:restPrice])
        else
            redirect_to results_path()
        end
    end
end
