Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'qrcode#index'
  get '/generate_code' => 'qrcode#generate_code'
  post '/scan_code' => 'qrcode#scan_code'
end
