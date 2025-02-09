class InvoiceItem < ApplicationRecord
  enum status: { packaged: 0, pending: 1, shipped: 2 }

  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :unit_price, presence: true, numericality: { only_integer: true }
  validates :status, presence: true, inclusion: { in: InvoiceItem.statuses.keys }

  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :discounts, through: :merchants

  def full_amount
    (unit_price * quantity)/100.00
  end

  def invoice_item_discount
    item.merchant.discounts.where('discounts.threshold <= ?', quantity).order(percentage: :desc).first
  end

  def revenue_after_discount
    if !invoice_item_discount.blank?
      (full_amount * (1 - (invoice_item_discount.percentage / 100.00)))
    else
      full_amount
    end
  end
end
