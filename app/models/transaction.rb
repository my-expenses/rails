class Transaction < ApplicationRecord
  validates :amount, presence: true, numericality: {greater_than: 0, only_integer: true}
  validates :title, presence: true
  validates :type, presence: true
  validates :date, presence: true
end
