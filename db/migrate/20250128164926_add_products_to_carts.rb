class AddProductsToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :products, :json
  end
end
