class CreateWallets < ActiveRecord::Migration[8.0]
  def change
    create_table :wallets, primary_key: "wallet_id", force: :cascade do |t|
      t.integer :wallet_number
      t.decimal :balance
      t.references :user, null: false, foreign_key: { to_table: :users, primary_key: :user_id }, index: true

      t.timestamps
    end
  end
end
