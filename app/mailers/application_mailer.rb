class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com'#, charset: 'ISO-2022-JP' #これ+gem入れるとターミナルでの文字化けなくなるが、
                                                               #テストでエラーになる。viewで確認するとurlは正しい。
                                                               #有効化したいならターミナルでactivated: trueでok!
  layout 'mailer'
end
