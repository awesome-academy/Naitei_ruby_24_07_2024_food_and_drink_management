class Product < ApplicationRecord
  belongs_to :category
  has_one :order_items, dependent: :destroy
  has_one :cart_item, dependent: :destroy
  has_one :discount, dependent: :destroy
  has_many :reviews, dependent: :destroy, as: :reviewable

  def self.ransackable_attributes(auth_object = nil)
    %w(name description price category_id quantity_in_stock delivery_quantity)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(category)
  end
end
