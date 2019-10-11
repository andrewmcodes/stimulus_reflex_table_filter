class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.integer :stars
      t.integer :price
      t.string :category

      t.timestamps
    end
  end
end
