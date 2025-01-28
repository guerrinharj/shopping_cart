class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    Cart.ready_for_abandonment.find_each do |cart|
      cart.update!(abandoned_at: Time.current)
    end

    Cart.ready_for_deletion.find_each(&:destroy!)
  end
end
