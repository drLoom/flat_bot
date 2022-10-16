# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :graphs do
    resources :meter, only: %i[index]
    resources :old_new, only: %i[index]
  end

  root 'graphs/meter#index'
end
