class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  before_save :initialize_products

  before_save :update_last_interaction

  scope :not_abandoned, -> { where(abandoned_at: nil) }
  scope :abandoned, -> { where.not(abandoned_at: nil) }
  scope :ready_for_abandonment, -> { not_abandoned.where("last_interaction_at < ?", 3.hours.ago) }
  scope :ready_for_deletion, -> { abandoned.where("abandoned_at < ?", 7.days.ago) }

  private

  def initialize_products
    self.products ||= []
  end

  def update_last_interaction
    self.last_interaction_at ||= Time.current
  end
end
