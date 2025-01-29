class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  before_save :set_total_price

  private

  def set_total_price
    self.total_price = product.price * quantity
  end
end