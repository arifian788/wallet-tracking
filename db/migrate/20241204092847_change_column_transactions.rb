class ChangeColumnTransactions < ActiveRecord::Migration[8.0]
  def change
    change_table :transactions do |t|
      t.rename :source_wallet_id, :source_wallet_number
      t.rename :target_wallet_id, :target_wallet_number
    end
  end
end
