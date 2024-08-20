class OrdersController < ApplicationController
  before_action :set_order, only: [:destroy]

  def index
    if current_user.admin?
      @orders = Order.all
    else
      @orders = current_user.orders
    end
  end

  def failed
    @orders = filter_orders_by_status(0)
    render :index
  end

  def succeeded
    @orders = filter_orders_by_status(1)
    render :index
  end

  def confirming
    @orders = filter_orders_by_status(2)
    render :index
  end

  def destroy
    if @order.status == "confirming"
      @order.destroy
      redirect_to root_path, notice: t("orders.destroy_notice")
    else
      redirect_to @order, alert: t("orders.cannot_destroy_notice")
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def filter_orders_by_status status
    if current_user.admin?
      Order.where(status:)
    else
      current_user.orders.where(status:)
    end
  end
end
