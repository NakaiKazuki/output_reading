class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  def hello
    render html: "こんにちは, 世界!"
  end
end
