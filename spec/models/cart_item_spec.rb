require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context 'when validating' do
    let(:cart) { Cart.create!(total_price: 0) }
    let(:product) { Product.create!(name: "Sample Product", price: 10.0) }
    let(:cart_item) { CartItem.new(cart: cart, product: product) }

    it 'validates presence of cart' do
      cart_item.cart = nil
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors[:cart]).to include("must exist")
    end

    it 'validates presence of product' do
      cart_item.product = nil
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors[:product]).to include("must exist")
    end

    it 'validates quantity is greater than 0' do
      cart_item.quantity = 0
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors[:quantity]).to include("must be greater than 0")
    end

    it 'validates total_price is greater than or equal to 0' do
      cart_item.total_price = -1
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  context 'when saving' do
    let(:cart) { Cart.create!(total_price: 0) }
    let(:product) { Product.create!(name: "Sample Product", price: 10.0) }
    let(:cart_item) { CartItem.new(cart: cart, product: product, quantity: 2) }

    it 'calculates total_price before save' do
      cart_item.save!
      expect(cart_item.total_price).to eq(20.0) # 10.0 * 2
    end
  end
end
