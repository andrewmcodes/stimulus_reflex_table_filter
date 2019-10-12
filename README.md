# README

## StimulusReflex

Make sure you checkout [StimulusReflex](https://github.com/hopsoft/stimulus_reflex) for more information on how this awesomeness was achieved.

You can find documentation on the project [here](https://docs.stimulusreflex.com). If you run into trouble, reach out to me on [Twitter](https://twitter.com/andrewmcodes) and I will try to help!

## Setup instructions

1. Dependencies

Make sure you have ruby, node, and postgres installed and running.

Here is what I am using:

```
➜ rbenv -v
rbenv 1.1.2

➜ ruby -v
ruby 2.6.4p104 (2019-08-28 revision 67798) [x86_64-darwin18]

➜ nvm --version
0.35.0

➜ node -v
v12.11.1

➜ postgres --version
postgres (PostgreSQL) 11.5
```

2. Clone the repo

```
git clone https://github.com/andrewmcodes/stimulus_reflex_table_filter
cd stimulus_reflex_table_filter
```

3. `bundle install && yarn`

4. `rails db:create db:migrate db:seed`

5. `rails s`

6. Go to `localhost:3000` and see the magic.

7. Feel free to experiment and submit pull requests!

## Steps taken:

### 1

```sh
rails new stimulus_reflex_table_filter --skip-coffee --webpack=stimulus -d postgresql
cd stimulus_reflex_table_filter
rails db:create
```

### 2

```sh
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/andrewmcodes/stimulus_reflex_table_filter.git
git push -u origin master
```

### 3

Add stimulus_reflex, annotate, and standard to `Gemfile`

```sh
bundle
```

Add stimulus_reflex to our `package.json`

```sh
yarn add stimulus_reflex
```

### 4

Add Tailwind

```sh
yarn add tailwindcss --dev
./node_modules/.bin/tailwind init
```

Setup Tailwind: [instructions](https://dev.to/andrewmcodes/use-tailwind-css-1-0-in-your-rails-app-4pm4)


### 5

Scaffold `Restaurant`

```sh
rails generate scaffold Restaurant name:string stars:integer price:integer category:string
```

Add route

```rb
# config/routes.rb
root "restaurants#index"
```

### 6

Add seeds

```rb
# db/seeds.rb

101.times do
  Restaurant.create(
    name: Faker::Restaurant.name,
    stars: [1, 2, 3, 4, 5].sample,
    price: [0, 1, 2].sample,
    category: Faker::Restaurant.type,
  )
end
```

### 7

Update `app/helpers/restaurants_helper.rb`

```rb
module RestaurantsHelper
  def price_to_dollar_signs(price)
    ("$" * price) + "$"
  end

  def stars_to_symbol(stars)
    "★" * stars
  end
end
```

### 8

Update `restaurants_controller.rb`


```rb
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
```

### 9

Update `app/views/restaurants/index.html.erb`

```html
<h1 class="text-4xl my-8 text-gray-800 font-bold">Restaurants</h1>

<table class="table-auto bg-white w-full">
  <thead>
    <tr class="text-left bg-gray-800 text-white">
      <th class="px-4 py-2">
        <%= link_to "Name", "#", class: filter_css(:name), data: { reflex: "click->RestaurantsReflex#filter", room: session.id, filter: "name" } %>
      </th>
      <th class="px-4 py-2">
        <%= link_to "Stars", "#", class: filter_css(:stars), data: { reflex: "click->RestaurantsReflex#filter", room: session.id, filter: "stars" } %>
      </th>
      <th class="px-4 py-2">
        <%= link_to "Price", "#", class: filter_css(:price), data: { reflex: "click->RestaurantsReflex#filter", room: session.id, filter: "price" } %>
      </th>
      <th class="px-4 py-2">
        <%= link_to "Category", "#", class: filter_css(:category), data: { reflex: "click->RestaurantsReflex#filter", room: session.id, filter: "category" } %>
      </th>
    </tr>
  </thead>

  <tbody class="text-gray-900">
    <% @filtered_restaurants.each do |restaurant| %>
      <tr>
        <td class="border px-4 py-2"><%= restaurant.name %></td>
        <td class="border px-4 py-2"><%= stars_to_symbol(restaurant.stars) %></td>
        <td class="border px-4 py-2"><%= price_to_dollar_signs(restaurant.price) %></td>
        <td class="border px-4 py-2"><%= restaurant.category %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New Restaurant', new_restaurant_path %>
```

### 10

Create `app/reflexes/restaurants_reflex.rb`

```rb
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
```

### 11

Run Standard and Annotate

```sh
bundle exec annotate
bundle exec standardrb --fix
```

## Contributing

### Code of Conduct

Everyone interacting with StimulusReflex is expected to follow the [Code of Conduct](CODE_OF_CONDUCT.md)

### Coding Standards

This project uses [Standard](https://github.com/testdouble/standard) to minimize bike shedding related to code formatting.

Please run `bundle exec standardrb --fix` prior submitting pull requests.

### Contributing Guide

[Contributing Guide](/CONTRIBUTING.md)

## License

[MIT](/LICENSE.md)
