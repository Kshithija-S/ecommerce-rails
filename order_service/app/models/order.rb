class Order < ApplicationRecord
    has_many :order_item, dependent: :destroy

    STATUSES = ["cart", "pending", "checkout", "payment", "completed", "cancelled"]
    
    validates :user_id, presence: true
    validates :status, inclusion: { in: STATUSES }
end
