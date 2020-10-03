class AddImageToChapters < ActiveRecord::Migration[6.0]
  def change
    add_column :chapters, :image, :string
  end
end
