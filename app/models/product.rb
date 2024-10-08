class Product < ApplicationRecord
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  PRODUCT_PARAMS = [:name, :description,
  :quantity_in_stock, :price_cents, :currency, :category_id, {images: []}]
                   .freeze

  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_one :cart_item, dependent: :destroy
  has_one :discount, dependent: :destroy
  has_many :reviews, dependent: :destroy, as: :reviewable
  has_many_attached :images

  monetize :price_cents, with_model_currency: :currency, allow_nil: true

  accepts_nested_attributes_for :category

  validates :name, :price_cents, :currency, :quantity_in_stock, :category_id,
            presence: true

  # settings index: {number_of_shards: 1} do
  #   mappings dynamic: "false" do
  #     indexes :name, analyzer: "english"
  #     indexes :description, analyzer: "english"
  #   end
  # end

  # def self.search query
  #   {
  #     query: {
  #       multi_match: {
  #         query:,
  #         fields: %w(name description),
  #         fuzziness: "AUTO"
  #       }
  #     }
  #   }
  # end

  scope :order_by_name, ->{order :name}

  scope :global_search, lambda {|query|
    return if query.blank?

    where("name LIKE :query OR description LIKE :query ", query: "%#{query}%")
  }

  scope :min_price, lambda {|price|
    where("price_cents >= ?", convert_to_vnd(price)) if price.present?
  }

  scope :max_price, lambda {|price|
    where("price_cents <= ?", convert_to_vnd(price)) if price.positive?
  }

  scope :filter_by_category_id, lambda {|category_id|
    where(category_id:) if category_id.present?
  }

  ransack_alias :search_all_text,
                :name_or_description_cont

  class << self
    def ransackable_attributes auth_object
      if auth_object&.admin?
        %w(search_all_text category_id created_at currency
        delivery_quantity description id name price_cents
        quantity_in_stock updated_at)
      else
        %w(currency description name price_cents currency)
      end
    end

    def ransackable_associations auth_object
      if auth_object&.admin?
        %w(cart_item category discount images_attachments
          images_blobs order_items reviews)
      else
        %w(category)
      end
    end

    def convert_to_vnd price
      if I18n.locale == :en
        (price * Settings.exchange_rate_24).round
      else
        price
      end
    end
  end
end
