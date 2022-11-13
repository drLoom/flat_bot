# frozen_string_literal: true

Rails.application.routes.draw do
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

  namespace :stats do
    get :totals, to: 'main_page#totals'
  end

  get :top_flats, to: 'tops#top_flats'

  root 'graphs/charts#index'
end
