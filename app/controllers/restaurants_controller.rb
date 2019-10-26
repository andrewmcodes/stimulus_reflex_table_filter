class RestaurantsController < ApplicationController
  def index
    session[:sort] = Restaurant::FILTERS.find { |f| f == session[:sort] } || "name"
    session[:page] ||= 1
    @restaurants = Restaurant
      .filtered(session[:filter])
      .sorted(session[:sort], session[:sort_order])
      .page(session[:page])
  end
end
