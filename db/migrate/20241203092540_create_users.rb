class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, primary_key: "user_id", force: :cascade do |t|
      t.string :name
      t.string :email , index: { unique: true, name: "unique_emails" }
      t.string :password_digest
      t.timestamps
    end
  end
end
