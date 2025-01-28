class CartsController < ApplicationController
  before_action :set_cart, only: %i[show update destroy add_product remove_product]

  def index
    @carts = Cart.all

    render json: @carts
  end

  def show
    render json: @cart
  end

  def create
    @cart = Cart.new(cart_params)
    @cart.products ||= []
    @cart.total_price ||= 0

    if @cart.save
      render json: @cart, status: :created, location: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  def update
    if @cart.update(cart_params)
      render json: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @cart.destroy!
  end

  def add_product
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
    product = find_product(product_id)

    if product
      existing_product = @cart.products.find { |p| p["id"] == product_id }

      if existing_product
        existing_product["quantity"] += quantity
        existing_product["total_price"] = existing_product["quantity"] * product[:unit_price]
      else
        @cart.products << {
          id: product_id,
          name: product[:name],
          quantity: quantity,
          unit_price: product[:unit_price],
          total_price: quantity * product[:unit_price]
        }
      end

      update_cart_total_price
      @cart.save
      render json: @cart
    else
      render json: { error: "Product not found" }, status: :not_found
    end
  end

  def remove_product
    product_id = params[:product_id]
    product = @cart.products.find { |p| p["id"] == product_id }

    if product
      @cart.products.delete(product)
      update_cart_total_price
      @cart.save
      render json: @cart
    else
      render json: { error: "Product not found in cart" }, status: :not_found
    end
  end

  private

  def set_cart
    @cart = Cart.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Cart not found'] }, status: :not_found
  end

  def find_product(product_id)
    Product.find_by(id: product_id)
  end

  def update_cart_total_price
    @cart.total_price = @cart.products.sum { |p| p["total_price"] }
  end

  def cart_params
    params.permit(:product_id, :quantity, :total_price, products: [])
  end  
end
