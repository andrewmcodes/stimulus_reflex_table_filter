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
ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin18]

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

Add stimulus_reflex, annotate, faker, and standard to `Gemfile`

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

Scaffold some files

```sh
rails generate model Restaurant name:string stars:integer price:integer category:string
rails generate controller restaurants index
```

These commands should have generated:
- `db/migrate/20191013003319_create_restaurants.rb`
- `app/models/restaurant.rb`
- `test/models/restaurant_test.rb`
- `test/fixtures/restaurants.yml`
- `app/controllers/restaurants_controller.rb`
- `app/views/restaurants`
- `app/views/restaurants/index.html.erb`
- `test/controllers/restaurants_controller_test.rb`
- `app/helpers/restaurants_helper.rb`
- `app/assets/stylesheets/restaurants.scss`

Lets check the generated migration and modify that slighly:

```rb
class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.integer :stars, null: false, default: 0
      t.integer :price, null: false, default: 1
      t.string :category, null: false

      t.timestamps
    end
  end
end
```

Lets also add some seeds:

```rb
# db/seeds.rb

101.times do
  Restaurant.create(
    name: Faker::Restaurant.name,
    stars: [1, 2, 3, 4, 5].sample,
    price: [1, 2, 3].sample,
    category: Faker::Restaurant.type,
  )
end
```

Ok now lets run `rails db:migrate db:seed` to run our migration and add some records to our database. Let's also run `bundle exec annotate` to annotate some of our files with our table info.

### 6

Let's update `app/models/restaurant.rb`

```rb
# == Schema Information
#
# Table name: restaurants
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  stars      :integer          default("0"), not null
#  price      :integer          default("1"), not null
#  category   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Restaurant < ApplicationRecord
  validates_inclusion_of :stars, in: 0..5
  validates_inclusion_of :price, in: 1..3
end
```


### 7

Go to `config/routes.rb` and add `root "restaurants#index`.

Your routes file should now look like:

```rb
Rails.application.routes.draw do
  get "restaurants/index"
  root "restaurants#index"
end
```

### 8

Update `app/controllers/restaurants_controller.rb`


```rb
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

```

### 9

Update `app/helpers/restaurants_helper.rb`

```rb
module RestaurantsHelper
  def price_to_dollar_signs(price)
    "$" * price
  end

  def stars_to_symbol(stars)
    "★" * stars
  end
end
```


Update `app/views/restaurants/index.html.erb`

```html
<h1 class="mt-8 text-4xl text-gray-800 font-bold">Restaurants</h1>
<h2 class="mb-8 text-gray-800">Currently filtering by: <%= session[:filter].capitalize %></h2>

<table class="table-auto bg-white w-full" data-controller="restaurants">
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

Now you should be able to click on table headers and have the list filter.

### 11

Let's add something fun.

`yarn add dom-confetti`

Create a stimulus controller.

```js
// app/frontend/controllers/restaurants_controller.js
import { Controller } from 'stimulus'
import StimulusReflex from 'stimulus_reflex'
import { confetti } from 'dom-confetti'

export default class extends Controller {
  connect () {
    StimulusReflex.register(this)
  }

  afterReflex (anchorElement) {
    confetti(anchorElement)
  }
}
```

NOTE: If you did not follow my tailwind tutorial than this file will be at `app/javascript/controllers/restaurants_controller.js` not `app/frontend/controllers/restaurants_controller.js`

Now clicking on the table headers should give a fun burst of confetti!

### 12

Run Standard

```sh
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
