class ProfileIcon < ApplicationRecord
  has_one_attached :image
  
    # S3バケット内の画像URLを返すメソッド
  def image_url
    if image.attached?
      image.service_url
    end
  end
end
