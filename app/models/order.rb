class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items
  belongs_to :user
  belongs_to :payment_method
  belongs_to :address

  enum status: {failed: 0, succecced: 1, confirming: 2}

  scope :failed, ->{where(status: 0)}
  scope :succeeded, ->{where(status: 1)}
  scope :confirming, ->{where(status: 2)}

  
  before_save :check_reason

  private

  def check_reason
    if status != 0
      self.reason = nil
    end
  end
end
