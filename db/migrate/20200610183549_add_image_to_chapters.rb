class AddImageToChapters < ActiveRecord::Migration[5.2]
  def change
    add_column :chapters, :image, :string
  end
end
