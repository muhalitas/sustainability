Rails.application.routes.draw do


  get '/gcat' => 'welcome#gcat'
  post 'results' =>  'welcome#results'
  get '/index.html' => 'welcome#index'


  root 'welcome#index'

end
