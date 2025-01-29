require 'rails_helper'

RSpec.describe "/cart", type: :request do
  describe "POST /cart/add_item" do
    let(:cart) { Cart.create!(total_price: 0) }
    let(:product) { Product.create!(name: "Test Product", price: 10.0) }
    let!(:cart_item) { cart.cart_items.create!(product: product, quantity: 1) }

    context 'when the product is already in the cart' do
      before do
        post "/cart/add_item", params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect(cart_item.reload.quantity).to eq(2)
      end
    end
  end
end
