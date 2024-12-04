class Wallet < ApplicationRecord
  belongs_to :user

  def self.wallet_number
    rand(1_000_000_000)
  end
end
