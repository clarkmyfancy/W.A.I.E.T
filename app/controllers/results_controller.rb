# require 'yelp/fusion'
# @@client = Yelp::Fusion::Client.new("d-yJQSQLB6kXGGMW3-FDyGNeBXW-j89QbZxiWayPSg_9zKqo3IGyKhLZCXpDxM45ClJLMVoJzLt-w-FJBP4G4muQEq-PrNVw35r56-frAONXuqGPNlGGGFEqeZjGXHYx")

class ResultsController < ApplicationController
    @@liked_rests = []
    def index 
        @cat = params[:categories]? [params[:categories].join(' ')] : ['food']
        @price_range = params[:prices]? [params[:prices].join(',')] : ['1,2,3,4']
        results = Client.search(@cat, @price_range)
        restaurants = results["businesses"].uniq {|biz| biz["name"] } unless results == nil
        @size = restaurants.length()
        randomized_ind = params[:random_ind]
        @count = params[:counter].to_i
        @curr_rest_ind = randomized_ind[@count].to_i
        @restaurant = restaurants[@curr_rest_ind]
        if params[:liked_pos]
            @@liked_rests.push(restaurants[params[:liked_pos].to_i]).uniq! {|rest| rest}
        end
        @final_rests = params[:init]  ?  @@liked_rests : @@liked_rests.clear()
        @end_of_list = @count >= @size ? true : false
    end

    def create
        redirect_to results_path(categories: params[:restCategory], prices: params[:restPrice], init: params[:init], 
                                        counter: params[:counter], liked_pos: params[:liked_pos], random_ind: params[:random_ind])
    end
end
