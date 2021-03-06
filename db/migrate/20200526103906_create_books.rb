class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title,null: false
      t.references :user, foreign_key: true,null: false

      t.timestamps
    end
    add_index :books, [:user_id, :created_at]
  end
end
