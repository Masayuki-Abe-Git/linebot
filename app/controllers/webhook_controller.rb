class WebhookController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'  

  # callbackアクションのCSRFトークン認証を無効  
  protect_from_forgery :except => [:callback]  

  def client  
    @client ||= Line::Bot::Client.new { |config|  
      config.channel_secret = ENV[0f7bf2f88271bcd2781ce722e4bf005e]  
      config.channel_token = ENV[qPjKyL7yJoX81s5S8alOL4h7FrPDoyn3BCK18/nPWL25e0tCq7DFo+IiavwYxcGPLLrbPYnE5rjUXfwn+FC2QbKOhJ63s9Ao4pV0APey1Yw0SstZC2w/ADoAbCFK1GMgm01MzkBbT9WG1wNlF9gC2wdB04t89/1O/w1cDnyilFU=]  
    }  
  end  

  def callback  
    body = request.body.read  

    signature = request.env['HTTP_X_LINE_SIGNATURE']  
    unless client.validate_signature(body, signature)  
      error 400 do 'Bad Request' end  
    end  

    events = client.parse_events_from(body)  

    events.each { |event|  
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
    }  

    head :ok  
  end
end
