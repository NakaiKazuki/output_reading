if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => 'AWS',
      :region                => Rails.application.credentials.s3[:s3_region],
      :aws_access_key_id     => Rails.application.credentials.s3[:s3_access_key],
      :aws_secret_access_key => Rails.application.credentials.s3[:s3_secret_key]
    }
    config.fog_directory     =  Rails.application.credentials.s3[:s3_bucket]
  end
end
