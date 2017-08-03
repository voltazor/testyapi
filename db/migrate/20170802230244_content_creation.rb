class ContentCreation < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password, null: false
      t.string :name
      t.timestamps
    end

    add_index :users, :id

    create_table :posts do |t|
      t.string :text
      t.string :image_url
      t.integer :user_id
      t.timestamps
    end

    add_index :posts, :id
    add_foreign_key :posts, :users
  end

  def rollback_db_transaction
    drop_table :users
    drop_table :posts
  end
end
