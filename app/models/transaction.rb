class Transaction < ApplicationRecord
  validates :amount, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :transactionTitle, presence: true
  validates :date, presence: true

  belongs_to :category, optional: true

  before_save :handle_category_id

  def as_json(options = {})
    super(options).merge({
                           "title": transactionTitle,
                           "type": transactionType,
                         })
                  .except!("transactionType", "transactionTitle") # delete transactionType and transactionTitle keys
  end

  def from_json(json, include_root = nil)
    puts json
    super
  end

  private
  def handle_category_id # set categoryID to null if it's passed as zero
    if categoryID == 0
      self.categoryID = nil
    end
  end
end
