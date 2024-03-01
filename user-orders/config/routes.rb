Rails.application.routes.draw do

  get :order_histories, to: 'order_histories#fetch_order_histories'
  get '/order_histories/export_status/:user_id', to: 'order_histories#export_status', as: :export_order_histories_status
  get '/order_histories/export/:user_id', to: 'order_histories#export', as: :export_order_histories
end
