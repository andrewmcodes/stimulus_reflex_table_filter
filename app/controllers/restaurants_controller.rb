class RestaurantsController < ApplicationController
  def index
    session[:filter] = "name" unless filter_permitted?(session[:filter])
    @filtered_restaurants = set_filter_ordered_restaurants
  end

  private

  def set_filter_ordered_restaurants
    if session[:filter_order] == :reverse
      Restaurant.order(session[:filter]).reverse
    else
      Restaurant.order(session[:filter])
    end
  end

  def filter_permitted?(filter)
    Restaurant::FILTERS.include? filter
  end
end
