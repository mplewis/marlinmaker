Rails.application.routes.draw do
  root to: 'frontend#app'
  post '/validate', to: 'compile#validate'
end
