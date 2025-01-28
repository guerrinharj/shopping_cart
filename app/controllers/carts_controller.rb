class CartsController < ApplicationController
  before_action :set_cart, only: %i[show destroy add_product remove_product]
  before_action :refresh_last_interaction, only: %i[add_product remove_product]

  def show
    render json: @cart
  end

  def create
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    product = Product.find_by(id: product_id)
    if product.nil?
      render json: { error: "Product not found" }, status: :not_found and return
    end

    @cart = Cart.new
    @cart.products = [
      {
        id: product.id,
        name: product.name,
        quantity: quantity,
        unit_price: product.price,
        total_price: product.price * quantity
      }
    ]
    @cart.total_price = product.price * quantity

    if @cart.save
      render json: @cart, status: :created
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @cart.destroy!
    head :no_content
  end

  def add_product
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    product = Product.find_by(id: product_id)
    if product.nil?
      render json: { error: "Product not found" }, status: :not_found and return
    end

    existing_product = @cart.products.find { |p| p['id'] == product_id }

    if existing_product
      existing_product['quantity'] = existing_product['quantity'].to_i + quantity
      existing_product['total_price'] = existing_product['quantity'] * product.price
    else
      @cart.products << {
        id: product.id,
        name: product.name,
        quantity: quantity,
        unit_price: product.price,
        total_price: product.price * quantity
      }
    end

    update_cart_total_price

    if @cart.save
      render json: @cart, status: :ok
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  def remove_product
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
  
    product = @cart.products.find { |p| p['id'] == product_id }
  
    if product
      product['quantity'] = product['quantity'].to_i - quantity
  
      if product['quantity'] > 0
        product['total_price'] = product['quantity'].to_i * product['unit_price'].to_f
      else
        @cart.products.delete(product)
      end
  
      update_cart_total_price
  
      if @cart.save
        render json: @cart, status: :ok
      else
        render json: @cart.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Product not found in cart" }, status: :not_found
    end
  end


  private

  def set_cart
    @cart = Cart.last
  end

  def update_cart_total_price
    @cart.total_price = @cart.products.sum { |p| p['total_price'].to_f }
  end

  def refresh_last_interaction
    @cart.update!(last_interaction_at: Time.current)
  end
end
