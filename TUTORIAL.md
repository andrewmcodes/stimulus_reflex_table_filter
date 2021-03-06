
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

Add stimulus_reflex, annotate, faker, and standard to `Gemfile`. If you want to deploy the app to heroku, also add the redis gem.

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

Scaffold `Restaurant` and remove all actions except :index

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
class Restaurant < ApplicationRecord
  validates_inclusion_of :stars, in: 0..5
  validates_inclusion_of :price, in: 1..3

  FILTERS = %w[name stars price category].freeze
end
```

### 7

Go to `config/routes.rb` and add `root "restaurants#index`.

Your routes file should now look like:

```rb
Rails.application.routes.draw do
  root "restaurants#index"
end
```

### 8

Update `app/controllers/restaurants_controller.rb` to only support the `:index` method.

```rb
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
```

### 9

Update `app/views/restaurants/index.html.erb` so that table column headers are wired to the StimulusReflex action `filter`, passing in the current active filter as an attribute.

```rb
  <thead>
    <tr class="text-left bg-gray-800 text-white">
      <% Restaurant::FILTERS.each do |filter| %>
      <th class="px-4 py-2">
        <%= link_to filter.capitalize, "#", class: filter_css(filter), data: { reflex: "click->RestaurantsReflex#filter", room: session.id, filter: filter } %>
      </th>
      <% end %>
    </tr>
  </thead>
```

### 10

Create `filter` Reflex method.. The sorting order is `:normal` unless the user clicks again on the same column heading multiple times.

```rb
# app/reflexes/restaurants_reflex.rb
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
```

Now you should be able to click on table headers and have the list filter.

### 11

Setup encrypted cookies-based session management for ActionCable, as described in the [StimulusReflex documentation for Security](https://docs.stimulusreflex.com/security). This code is literally cut-and-pasted into `app/controllers/application_controller.rb` and `app/channels/application_cable/connection.rb`.

### 12

Let's add something fun... we'll fire off the confetti canon every time someone activates a Reflex.

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

### 13

Run Standard

```sh
bundle exec standardrb --fix
```
