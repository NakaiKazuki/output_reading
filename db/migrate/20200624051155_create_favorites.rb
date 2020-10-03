class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true,null: false
      t.references :book, foreign_key: true,null: false

      t.timestamps
    end
    add_index :favorites,[:user_id, :book_id], unique: true
  end
end
