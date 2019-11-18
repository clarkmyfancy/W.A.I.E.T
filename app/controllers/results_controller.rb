# require 'yelp/fusion'
# @@client = Yelp::Fusion::Client.new("d-yJQSQLB6kXGGMW3-FDyGNeBXW-j89QbZxiWayPSg_9zKqo3IGyKhLZCXpDxM45ClJLMVoJzLt-w-FJBP4G4muQEq-PrNVw35r56-frAONXuqGPNlGGGFEqeZjGXHYx")

class ResultsController < ApplicationController
    @@liked_rests = []
    def index 
        @cat = params[:categories]? [params[:categories].join(' ')] : ['food']
        @price_range = params[:prices]? params[:prices] : ["1","2","3","4"]
        results = Client.search(@cat, @price_range)
        restaurants = results["businesses"].uniq {|biz| biz["name"] } unless results == nil
        
        @size = restaurants.length()
        randomized_ind = params[:random_ind].select{ |i| i.to_i < @size }
        @count = params[:counter].to_i
        
        if params[:liked_pos]
            @@liked_rests.push(restaurants[randomized_ind[@count-1].to_i]).uniq! {|rest| rest}
        end
        
        @curr_rest_ind = randomized_ind[@count].to_i
        @restaurant = restaurants[@curr_rest_ind]
        @photos = Client.business(@restaurant["id"])["photos"]
        
        @final_rests = params[:init]  ?  @@liked_rests : @@liked_rests.clear()
        @end_of_list = @count >= @size ? true : false
    end

    def create
        redirect_to results_path(categories: params[:categories], prices: params[:prices], init: params[:init], 
                                        counter: params[:counter], liked_pos: params[:liked_pos], random_ind: params[:random_ind])
    end
end
