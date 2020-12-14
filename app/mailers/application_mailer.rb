class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com' # , charset: 'ISO-2022-JP' #これ入れるとターミナルでの文字化けなくなるが、テストが失敗する。
  layout 'mailer'
end
