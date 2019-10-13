class RestaurantsController < ApplicationController
  before_action :set_all_restaurants, only: :index
  before_action :set_filter, only: :index
  FILTERS = %w[name stars price category].freeze

  def index
    @filtered_restaurants = set_filter_ordered_restaurants
  end

  private

  def set_all_restaurants
    @restaurants = Restaurant.all
  end

  def set_filter
    session[:filter] = "name" unless filter_permitted?(session[:filter])
  end

  def set_filter_ordered_restaurants
    if session[:filter_order] == :reverse
      @restaurants.order(session[:filter]).reverse
    else
      @restaurants.order(session[:filter])
    end
  end

  def filter_permitted?(filter)
    FILTERS.include? filter
  end
end
