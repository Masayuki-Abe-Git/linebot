require 'line/bot'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :validate_signature

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["0f7bf2f88271bcd2781ce722e4bf005e"]
      config.channel_token = ENV["qPjKyL7yJoX81s5S8alOL4h7FrPDoyn3BCK18/nPWL25e0tCq7DFo+IiavwYxcGPLLrbPYnE5rjUXfwn+FC2QbKOhJ63s9Ao4pV0APey1Yw0SstZC2w/ADoAbCFK1GMgm01MzkBbT9WG1wNlF9gC2wdB04t89/1O/w1cDnyilFU="]
      # ローカルで動かすだけならベタ打ちでもOK
      # config.channel_secret = "your channel secret"
      # config.channel_token = "your channel token"
    }
  end
end
