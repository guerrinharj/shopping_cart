class AddInteractionTrackingToCarts < ActiveRecord::Migration[7.0]
  def change
    add_column :carts, :last_interaction_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :carts, :abandoned_at, :datetime
  end
end
