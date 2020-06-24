class AddNumberToChapters < ActiveRecord::Migration[5.2]
  def change
    add_column :chapters, :number, :integer, after: :id
  end
  add_index :chapters, [:number]
end
