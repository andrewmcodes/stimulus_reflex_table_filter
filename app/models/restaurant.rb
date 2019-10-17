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

  FILTERS = %w[name stars price category].freeze
end
