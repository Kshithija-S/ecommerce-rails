class OrderItem < ApplicationRecord
    belongs_to :order
    after_save :update_total_price
    after_destroy :update_total_price

    validates :product_id, presence: true

    def update_total_price
        updated_total = self.order.order_item.sum { |item| item.price * item.quantity }
        self.order.update(total_price: updated_total)
    end
end
