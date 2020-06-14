class Chapter < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates   :content, presence: true, length: { maximum: 2000 }
  validates   :user_id, presence: true
  validates   :book_id, presence: true
  mount_uploader :image, ChapterImageUploader
  validate  :image_size
end
