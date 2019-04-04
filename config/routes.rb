MinikasPayable::Engine.routes.draw do
  resources :batches, only: %w[index show create update destroy]
  resources :transfers, only: %w[destroy]
end
