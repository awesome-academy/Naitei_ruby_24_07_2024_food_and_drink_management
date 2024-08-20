class Product < ApplicationRecord
  belongs_to :category
  has_one :order_items, dependent: :destroy
  has_one :cart_item, dependent: :destroy
  has_one :discount, dependent: :destroy
  has_many :reviews, dependent: :destroy, as: :reviewable

  scope :global_search, lambda {|query|
    where("name LIKE :query OR description LIKE :query ", query: "%#{query}%")
  }

  scope :min_price, ->(price){where("price >= ?", price)}

  scope :max_price, ->(price){where("price <= ?", price)}

  scope :filter_by_category_id, ->(category_id){where categories: category_id}
end
