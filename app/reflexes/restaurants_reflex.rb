class RestaurantsReflex < StimulusReflex::Reflex
  def filter
    session[:filter_order] = filter_order
    session[:filter] = element.dataset[:filter]
  end

  private

  def filter_order
    return :reverse if session[:filter] == element.dataset[:filter] && session[:filter_order] != :reverse
    :forward
  end
end
