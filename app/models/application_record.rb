class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  # アップロードされた画像のサイズをバリデーションする
    def image_size
      return unless image.size > 5.megabytes

      errors.add(:image, 'は5MB未満にしてください')
    end
end
