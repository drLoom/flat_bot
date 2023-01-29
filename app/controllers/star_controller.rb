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

    render partial: 'add_url_form'
  end

  def destroy
    @star = Star.find_by(user: current_user, id: params[:id])
    @star.destroy

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
    Star.includes(:flats_hists).where(user: current_user)
  end
end
