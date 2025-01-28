class AddCartToProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :cart, foreign_key: true, null: true
  end
end
