Rails.application.routes.draw do
  root "pages#home"

  get  "/rooms/join", to: "rooms#join"

  resources :rooms, param: :code, only: [:show, :create] do
    post :join, on: :member
    post :start_round, on: :member, to: "rounds#create"
  end

  resources :rounds, only: [] do
    post :submit_clue, on: :member
    post :go_later, on: :member
    post :done_arranging, on: :member
    post :reveal, on: :member
  end

  resources :players, only: [:create, :destroy]
end
