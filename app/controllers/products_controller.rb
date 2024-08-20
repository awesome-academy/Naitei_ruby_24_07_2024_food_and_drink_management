class ProductsController < ApplicationController
  def index
    @products = Product.all
    binding.pry
    if params.dig(:search, :query).present?
    binding.pry
      @products = Product.all.global_search(params.dig(:search, :query))
    end

    if params.dig(:search, :min_price).present?
      binding.pry
      min_price = params.dig(:search, :min).to_d
      @products = @products.min_price(min_price)
    end

    if params.dig(:search, :max_price).present?
      max_price = params.dig(:search, :max).to_d
      @products = @products.max_price(max_price)
    end
    if params.dig(:search, :category_id).present?
      @products = Product.all.filter_by_category_id(
        params.dig(:search, :category_id)
      )
    end
    @pagy, @products = pagy(@products, items: Settings.page_10)
  end
end
