# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :graphs do
    resources :charts, only: %i[index]
    resources :meter, only: %i[index] do
      collection do
        get :inc_dec
      end
    end
    resources :old_new, only: %i[index]
    resources :doubles, only: %i[index]
    resources :by_rooms, only: %i[index] do
      collection do
        get :split
      end
    end
  end

  resources :star, only: %i[index new create destroy] do
    collection do
      get :table
      get :stars_graphs
    end
  end

  resources :price_history, only: %i[index create]

  namespace :stats do
    get :totals, to: 'main_page#totals'
  end

  %i[top_flats top_newly].each do |act|
    get act, to: "tops##{act}"
  end

  root 'graphs/charts#index'
end
