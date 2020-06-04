class Book < ApplicationRecord
  belongs_to  :user
  has_many :chapters
  has_many :chapters, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates   :title, presence: true, length: { maximum: 50 }
  validates   :user_id, presence: true
end
