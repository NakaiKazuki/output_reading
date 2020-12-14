class Chapter < ApplicationRecord
  belongs_to :user
  belongs_to :book
  default_scope -> { order(number: :asc) }
  mount_uploader :image, ChapterImageUploader

  validates :number,
            presence: true,
            numericality: { only_integer: true },
            uniqueness: { scope: :book_id,
                          message: 'が同じ投稿があります。' }
  validates :content,
            presence: true,
            length: { maximum: 4000 }
  validates :user_id,
            presence: true
  validates :book_id,
            presence: true
  validate  :image_size
end
