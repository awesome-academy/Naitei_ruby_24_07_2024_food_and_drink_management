class ProductsController < ApplicationController
  def index
      @q = Product.ransack(params[:q])
      @pagy, @products = pagy(@q.result, items: Settings.page_10)

  end

end
