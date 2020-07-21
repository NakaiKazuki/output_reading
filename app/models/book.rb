class Book < ApplicationRecord
  belongs_to  :user
  has_many :chapters, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # has_many :favorite_users, through: :favorites, source: :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :image, BookImageUploader

  validates :title,
    presence: true,
    length: { maximum: 50 }
  validates :user_id,
    presence: true
  validate  :image_size
end
