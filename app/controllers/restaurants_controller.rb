class RestaurantsController < ApplicationController
  before_action :set_all_restaurants, only: :index
  before_action :set_filter, only: :index
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  FILTERS = %w[name stars price category].freeze
  # GET /restaurants
  # GET /restaurants.json
  def index
    @filtered_restaurants = set_filter_ordered_restaurants
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: "Restaurant was successfully created." }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to @restaurant, notice: "Restaurant was successfully updated." }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: "Restaurant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

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

  # Never trust parameters from the scary internet, only allow the white list through.
  def restaurant_params
    params.require(:restaurant).permit(:name, :stars, :price, :category)
  end

  def filter_permitted?(filter)
    FILTERS.include? filter
  end
end
