class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products, primary_key: "product_id", force: :cascade do |t|
      t.string :title
      t.decimal :price
      t.text :description
      t.string :category
      t.string :image
      t.float :rating_rate
      t.integer :rating_count
      
      t.timestamps
    end
  end
end
