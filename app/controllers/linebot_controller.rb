class WebhookController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  protect_from_forgery except: [:callback] # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["0f7bf2f88271bcd2781ce722e4bf005e"]
      config.channel_token = ENV["qPjKyL7yJoX81s5S8alOL4h7FrPDoyn3BCK18/nPWL25e0tCq7DFo+IiavwYxcGPLLrbPYnE5rjUXfwn+FC2QbKOhJ63s9Ao4pV0APey1Yw0SstZC2w/ADoAbCFK1GMgm01MzkBbT9WG1wNlF9gC2wdB04t89/1O/w1cDnyilFU="]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
    end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end

    "OK"
  end
end