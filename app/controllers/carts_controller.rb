class CartsController < ApplicationController
  before_action :set_cart, only: %i[show destroy add_item remove_item]
  before_action :refresh_last_interaction, only: %i[add_item remove_item]

  def show
    render json: format_cart_response(@cart)
  end

  def create
    product = Product.find_by(id: params[:product_id])
    return render json: { error: "Product not found" }, status: :not_found unless product

    quantity = params[:quantity].to_i
    return render json: { error: "Quantity must be greater than 0" }, status: :unprocessable_entity if quantity <= 0

    @cart = Cart.create(total_price: 0)

    @cart.cart_items.create!(
      product: product,
      quantity: quantity
    )

    @cart.update_total_price
    @cart.save!

    render json: format_cart_response(@cart), status: :created
  end

  def destroy
    @cart.destroy!
    head :no_content
  end

  def add_item
    product = Product.find_by(id: params[:product_id])
    return render json: { error: "Product not found" }, status: :not_found unless product

    cart_item = @cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity += params[:quantity].to_i
    cart_item.save!

    @cart.update_total_price
    @cart.save!

    render json: format_cart_response(@cart), status: :ok
  end

  def remove_item
    cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    return render json: { error: "Product not found in cart" }, status: :not_found unless cart_item

    cart_item.destroy

    @cart.update_total_price
    @cart.save!

    render json: format_cart_response(@cart), status: :ok
  end

  private

  def set_cart
    @cart = Cart.last || Cart.create(total_price: 0)
  end

  def refresh_last_interaction
    @cart.update!(last_interaction_at: Time.current)
  end

  def format_cart_response(cart)
    {
      id: cart.id,
      products: cart.cart_items.map do |cart_item|
        {
          id: cart_item.product.id,
          name: cart_item.product.name,
          quantity: cart_item.quantity,
          unit_price: cart_item.product.price,
          total_price: cart_item.total_price
        }
      end,
      total_price: cart.total_price
    }
  end
end
