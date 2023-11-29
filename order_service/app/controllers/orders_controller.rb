class OrdersController < ApplicationController
  before_action :authenticate_user
  before_action :set_order, only: [:index, :update_item, :destroy_item]

  def index
    if @order
      render json: @order, status: :ok
    else
      head :internal_server_error
    end
  end

  def create
    @order = Order.find_or_initialize_by(user_id: @current_user_id, status: "cart")

    @order_item = @order.order_item.find_by(product_id: order_item_params[:product_id])

    if @order_item
      @order_item.update(quantity: @order_item.quantity + order_item_params[:quantity])
    else
      @order.order_item.build(order_item_params)
    end

    if @order.save
        render json: @order, status: :created
    else
        render json: {error: @order_item.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order
      if @order.update(order_params)
        render json: @order, status: :created
      else
        head :internal_server_error
      end
    else
      render json: {error: "Order not found"}, status: :not_found 
    end
  end

  def update_item
    @order_item = @order.order_item.find_by(product_id: params[:product_id])

    if @order_item
      if @order_item.update(order_item_params)
        render json: @order, status: :created
      else
        render json: {error: @order_item.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error: "Product not found"}, status: :not_found
    end
  end

  def destroy_item
    @order_item = @order.order_item.find_by(product_id: params[:product_id])
    if @order_item
      if @order_item.destroy
        render status: :no_content
      else
        head :internal_server_error
      end
    else
      render json: {error: "Product Not Found"}, status: :not_found
    end
  end

  private

  def set_order
    @order = Order.find_by(user_id: @current_user_id, status: "cart")
    rescue ActiveRecord::RecordNotFound
      render json: {error: "Order not found"}, status: :not_found
  end

  def order_item_params
    params.require(:items).permit(:product_id, :quantity, :price)
  end

  def order_params
    params.permit(:status)
  end
end
