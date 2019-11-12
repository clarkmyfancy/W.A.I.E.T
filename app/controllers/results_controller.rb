# require 'yelp/fusion'
# @@client = Yelp::Fusion::Client.new("d-yJQSQLB6kXGGMW3-FDyGNeBXW-j89QbZxiWayPSg_9zKqo3IGyKhLZCXpDxM45ClJLMVoJzLt-w-FJBP4G4muQEq-PrNVw35r56-frAONXuqGPNlGGGFEqeZjGXHYx")

class ResultsController < ApplicationController

    def index 
        @cat = [params[:categories].join(' ')]
        restaurants = Client.search(@cat)
        @restaurants = restaurants["businesses"].uniq {|biz| biz["name"] } unless restaurants == nil
    end

    def create
        if params[:restCategory]
            redirect_to results_path(categories: params[:restCategory])
        else
            redirect_to results_path(categories: ['food'])
        end
    end
end
