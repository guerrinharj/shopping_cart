require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = Cart.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe 'scopes' do
    let!(:cart) { Cart.create!(total_price: 0, last_interaction_at: 3.hours.ago) }
    let!(:abandoned_cart) { Cart.create!(total_price: 0, abandoned_at: 8.days.ago) }

    it 'includes inactive carts in ready_for_abandonment' do
      expect(Cart.ready_for_abandonment).to include(cart)
    end

    it 'includes old abandoned carts in ready_for_deletion' do
      expect(Cart.ready_for_deletion).to include(abandoned_cart)
    end
  end
end
