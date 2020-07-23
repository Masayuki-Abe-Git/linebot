Rails.application.routes.draw do
  root 'application#hello'  
  post '/callback', to: 'webhook#callback'
end
