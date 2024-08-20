class Category < ApplicationRecord
  has_many :products, dependent: :nullify

  def self.ransackable_attributes _auth_object = nil
    %w(name)
  end
end
