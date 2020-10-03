class CreateChapters < ActiveRecord::Migration[6.0]
  def change
    create_table :chapters do |t|
      t.integer :number,null: false
      t.text :content,null: false
      t.references :user, foreign_key: true,null: false
      t.references :book, foreign_key: true,null: false

      t.timestamps
    end
    add_index :chapters, [:number,:book_id],unique: true
    add_index :chapters, [:user_id,:created_at]
  end
end
