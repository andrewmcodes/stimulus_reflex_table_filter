# == Schema Information
#
# Table name: restaurants
#
#  id         :integer          not null, primary key
#  name       :string
#  stars      :integer
#  price      :integer
#  category   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Restaurant < ApplicationRecord
  validates_inclusion_of :stars, :in => 0..5
  validates_inclusion_of :price, :in => 1..3
end
