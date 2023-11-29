class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :total_price, :items

  def items
    ActiveModel::SerializableResource.new(object.order_item,  each_serializer: OrderItemSerializer)
  end
end
