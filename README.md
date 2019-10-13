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
ruby 2.6.4p104 (2019-08-28 revision 67798) [x86_64-linux]

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

Scaffold `Restaurant` and remove all actions except :index

```sh
rails generate scaffold Restaurant name:string stars:integer price:integer category:string
```

Add root route and set restaurants resource to only generate routes for :index

```rb
# config/routes.rb
resources :restaurants, only: :index
root "restaurants#index"
```

### 6

Add some exciting restaurants to check out using the wonderful Faker testing library.

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

### 7

Create formatting helpers for the restaurants resource in `app/helpers/restaurants_helper.rb`

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

### 8

Created `config/initializers/filters.rb` and define an array of frozen strings representing all of the criteria available for sorting.

```rb
FILTERS = %w[name stars price category].freeze
```

### 9

Update `app/views/restaurants/index.html.erb` so that table column headers are wired to the StimulusReflex action `filter`, passing in the current active filter as an attribute.

```rb
  <thead>
    <tr class="text-left bg-gray-800 text-white">
      <% FILTERS.each do |filter| %>
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

### 11

Setup encrypted cookies-based session management for ActionCable, as described in the [StimulusReflex documentation for Security](https://docs.stimulusreflex.com/security). This code is literally cut-and-pasted into `app/controllers/application_controller.rb` and `app/channels/application_cable/connection.rb`.

### 12

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
