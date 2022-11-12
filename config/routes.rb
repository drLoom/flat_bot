# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :graphs do
    resources :charts, only: %i[index]
    resources :meter, only: %i[index]
    resources :old_new, only: %i[index]
    resources :doubles, only: %i[index]
    resources :by_rooms, only: %i[index]
  end

  namespace :stats do
    get :totals, to: 'main_page#totals'
  end

  root 'graphs/charts#index'
end
