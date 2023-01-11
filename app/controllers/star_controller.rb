# frozen_string_literal: true

class StarController < ApplicationController
  layout 'theme'

  def index

  end

  def table
    @stars = get_stars

    render partial: 'table'
  end

  def stars_graphs
    stars = get_stars
    @data = Repositories::Stars::Flats.new.call(stars.map(&:object_id))

    respond_to do |format|
      format.json { render json: @data }
    end
  end

  def new
    render partial: 'add_url_form'
  end

  def create
    @star = Star.new(user_id: current_user.id, object_id: extract_object_id(permited_params[:url]))
    @star.save!

    clear_cache

    render partial: 'add_url_form'
  end

  def destroy
    @star = Star.find_by(user: current_user, id: params[:id])
    @star.destroy

    clear_cache

    @stars = get_stars

    render partial: 'table'
  end

  private

  def permited_params
    params.permit(:url)
  end

  def extract_object_id(url)
    url[/apartments\/(\d+)/, 1]
  end

  def get_stars
    Rails.cache.fetch(cache_key, expires_in: 1.hours) do
      Star.includes(flat_view: [:latest_hist, :begined_hist]).where(user: current_user)
    end
  end

  def clear_cache
    Rails.cache.delete(cache_key)
  end

  def cache_key
    "StarController#index#{current_user.id}"
  end
end
