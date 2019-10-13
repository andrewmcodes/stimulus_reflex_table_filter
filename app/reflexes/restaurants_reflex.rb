class RestaurantsReflex < StimulusReflex::Reflex
  def filter
    session[:filter_order] = filter_order
    session[:filter] = element.dataset[:filter]
  end

  private

  def filter_order
    return :normal unless session[:filter] == element.dataset[:filter]
    if session[:filter_order] != :reverse
      :reverse
    else
      :normal
    end
  end
end
