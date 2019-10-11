class RestaurantsReflex < StimulusReflex::Reflex
  def filter
    session[:filter] = element.dataset[:filter]
    session[:filter_order] = filter_order
  end

  private

  def filter_order
    return :reverse if session[:filter] == element.dataset[:filter] && session[:filter_order] != :reverse

    :normal
  end
end
