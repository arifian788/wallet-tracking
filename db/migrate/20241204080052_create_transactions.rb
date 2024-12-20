class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions, primary_key: "transaction_id", force: :cascade do |t|
      t.references :source_wallet, null: true, foreign_key: { to_table: :wallets, primary_key: :wallet_id }, index: true
      t.references :target_wallet, null: true, foreign_key: { to_table: :wallets, primary_key: :wallet_id }, index: true
      t.references :user, null: true, foreign_key: { to_table: :users, primary_key: :user_id }, index: true
      t.references :orders, null: true, foreign_key: { to_table: :orders, primary_key: :order_id }, index: true
      t.references :product, null: true, foreign_key: { to_table: :products, primary_key: :product_id }, index: true
      t.decimal :amount
      t.string :transaction_type
      t.string :notes

      t.timestamps
    end
  end
end
