101.times do
  Restaurant.create(
    name: Faker::Restaurant.name,
    stars: [1, 2, 3, 4, 5].sample,
    price: [0, 1, 2].sample,
    category: Faker::Restaurant.type,
  )
end
