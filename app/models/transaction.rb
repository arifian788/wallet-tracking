class Transaction < ApplicationRecord
  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, inclusion: { in: %w[transfer topup purchase] }
  validates :notes, length: { maximum: 255 }
end
