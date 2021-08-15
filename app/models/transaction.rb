class Transaction < ApplicationRecord
  validates :amount, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :transactionTitle, presence: true
  validates :date, presence: true

  def as_json(options = {})
    super(options).merge({
                           "type": transactionType,
                         })
                  .except!("transactionType") # delete transactionType key
  end

  def from_json(json, include_root = nil)
    puts json
    super
  end
end
