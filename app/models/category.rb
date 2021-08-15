class Category < ApplicationRecord
  validates :title, presence: true

  has_many :transactions, dependent: :destroy
end
