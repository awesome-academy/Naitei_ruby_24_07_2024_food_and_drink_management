class ProductsController < ApplicationController
  def index
    @pagy, @products = pagy(Product.all, limit: Settings.page_10)
  end
end
