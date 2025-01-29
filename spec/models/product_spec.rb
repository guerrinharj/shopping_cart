require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'when validating' do
    let(:product) { Product.new }

    it 'validates presence of name' do
      product.price = 100
      expect(product.valid?).to be_falsey
      expect(product.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of price' do
      product.name = 'name'
      expect(product.valid?).to be_falsey
      expect(product.errors[:price]).to include("is not a number")
    end

    it 'validates numericality of price' do
      product.price = -1
      expect(product.valid?).to be_falsey
      expect(product.errors[:price]).to include("must be greater than or equal to 0")
    end
  end
end
