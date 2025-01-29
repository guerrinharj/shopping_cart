class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  before_save :update_last_interaction

  scope :not_abandoned, -> { where(abandoned_at: nil) }
  scope :abandoned, -> { where.not(abandoned_at: nil) }
  scope :ready_for_abandonment, -> { not_abandoned.where("last_interaction_at < ?", 3.hours.ago) }
  scope :ready_for_deletion, -> { abandoned.where("abandoned_at < ?", 7.days.ago) }

  def update_total_price
    self.total_price = cart_items.sum(:total_price)
  end

  def mark_as_abandoned
    update!(abandoned_at: Time.current) if last_interaction_at < 3.hours.ago
  end

  def remove_if_abandoned
    destroy! if abandoned_at && abandoned_at < 7.days.ago
  end

  private

  def update_last_interaction
    self.last_interaction_at ||= Time.current
  end
end
