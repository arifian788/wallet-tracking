class Transaction < ApplicationRecord
  belongs_to :sender_wallet, class_name: "Wallet", foreign_key: "source_wallet_number"
  belongs_to :receiver_wallet, class_name: "Wallet", foreign_key: "target_wallet_number"
  belongs_to :product

  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, inclusion: { in: %w[transfer topup purchase] }
  validates :notes, length: { maximum: 255 }
end
