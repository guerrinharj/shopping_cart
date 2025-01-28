class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  before_save :initialize_products

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado

  private

  def initialize_products
    self.products ||= []
  end
end
