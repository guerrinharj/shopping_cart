class Product < ApplicationRecord
  validates_presence_of :name, :price
  validates_numericality_of :price, greater_than_or_equal_to: 0

  belongs_to :cart, optional: true

  attribute :quantity, :integer, default: 1
  attribute :total_price, :decimal, default: 0.0
end
