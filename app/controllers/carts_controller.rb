class CartsController < ApplicationController
  before_action :set_cart, only: %i[show update destroy add_product remove_product]

  # GET /carts
  def index
    @carts = Cart.all
    render json: @carts, include: :products
  end

  # GET /cart
  def show
    render json: @cart, include: :products
  end

  # POST /cart
  def create
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
  
    product = Product.find_by(id: product_id)
  
    if product.nil?
      render json: { error: "Product not found" }, status: :not_found and return
    end
  
    @cart = Cart.new
    @cart.total_price = product.price * quantity
  
    if @cart.save
        @cart_data = {
        id: @cart.id,
        total_price: @cart.total_price,
        products: [
          {
            id: product.id,
            name: product.name,
            quantity: quantity,
            unit_price: product.price,
          }
        ]
      }
      render json: @cart_data, include: :products, status: :created
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end
  

  # PATCH/PUT /cart
  def update
    if @cart.update(cart_params)
      render json: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cart
  def destroy
    @cart.products.destroy_all # Ensure all associated products are removed
    @cart.destroy!
    head :no_content
  end

  # POST /cart/add_product
  def add_product
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
    product = Product.find_by(id: product_id)

    if product
      existing_product = @cart.products.find_by(id: product_id)

      if existing_product
        # Update quantity and total price
        existing_product.update!(
          quantity: existing_product.quantity + quantity,
          total_price: (existing_product.quantity + quantity) * existing_product.price
        )
      else
        # Add a new product to the cart
        @cart.products.create!(
          name: product.name,
          price: product.price,
          quantity: quantity,
          total_price: quantity * product.price
        )
      end

      update_cart_total_price
      render json: @cart, include: :products
    else
      render json: { error: "Product not found" }, status: :not_found
    end
  end

  # DELETE /cart/remove_product
  def remove_product
    product_id = params[:product_id]
    product = @cart.products.find_by(id: product_id)

    if product
      product.destroy
      update_cart_total_price
      render json: @cart, include: :products
    else
      render json: { error: "Product not found in cart" }, status: :not_found
    end
  end

  private

  # Set or initialize the current cart
  def set_cart
    @cart = Cart.first_or_create(total_price: 0)
  end

  # Update the total price of the cart
  def update_cart_total_price
    @cart.update!(total_price: @cart.products.sum(:total_price))
  end

  # Permit parameters for cart
  def cart_params
    params.require(:cart).permit(products: [:id, :name, :price, :quantity, :total_price])
  end
end
