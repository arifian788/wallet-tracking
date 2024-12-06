class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders, primary_key: "order_id", force: :cascade do |t|
      t.references :user, null: false, foreign_key: { to_table: :users, primary_key: :user_id }, index: true
      t.references :product, null: false, foreign_key: { to_table: :products, primary_key: :product_id }, index: true
      t.integer :price
      t.integer :quantity
      t.decimal :total_price
      t.string :notes

      t.timestamps
    end
  end
end
