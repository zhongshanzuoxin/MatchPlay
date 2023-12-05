class ProfileIcon < ApplicationRecord
  has_one_attached :image, service: :amazon_original

  # リサイズされた画像のURLを生成するメソッド
  def resized_image_url
    if image.attached?
      "https://match-play-bucket.s3.amazonaws.com/#{resized_image_key}"
    end
  end

  # リサイズされた画像のS3キーを生成するメソッド
  def resized_image_key
    "#{image.key.split('.')[0]}-thumbnail.#{image.filename.extension}" if image.attached?
  end

  # プロファイルアイコンが破棄された時にリサイズされた画像も削除する
  after_destroy :delete_resized_image

  private

  def delete_resized_image
    return unless image.attached?

    s3_client = Aws::S3::Client.new(region: ENV['AWS_REGION'])
    s3_client.delete_object(bucket: 'match-play-bucket', key: resized_image_key)
  rescue Aws::S3::Errors::ServiceError => e
    Rails.logger.error "Failed to delete resized image: #{e.message}"
  end
end
