class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :price, :info

  def info
    ProductService.get("/products/#{object.product_id}")
  end

end
