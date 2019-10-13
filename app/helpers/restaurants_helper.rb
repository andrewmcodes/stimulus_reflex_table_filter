module RestaurantsHelper
  def price_to_dollar_signs(price)
    "$" * price
  end

  def stars_to_symbol(stars)
    "★" * stars
  end

  def filter_css(filter)
    "selected" if session[:filter] == filter
  end
end
