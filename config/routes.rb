Rails.application.routes.draw do
  root 'application#hello'  
  post '/callback' => 'linebot#callback'  
end
