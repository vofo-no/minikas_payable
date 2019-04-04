Rails.application.routes.draw do
  mount MinikasPayable::Engine => "/minikas_payable"
  root to: "dummy#hello"
  resources :dummy_payer
end
