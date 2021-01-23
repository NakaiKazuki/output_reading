RakutenWebService.configure do |c|
  c.application_id = Rails.application.credentials.dig(:rakuten, :app_id)
  c.affiliate_id = Rails.application.credentials.dig(:rakuten, :aff_id)
end
