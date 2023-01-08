# frozen_string_literal: true

class StarController < ApplicationController
  def index
    @stars = Star.includes(:latest_hist, :begined_hist).where(user: current_user)
  end

  def create
    @star = Star.new(user_id: current_user.id, object_id: extract_object_id(permited_params[:url]))
    @star.save!
  end

  private

  def permited_params
    params.permit(:url)
  end

  def extract_object_id(url)
    url[/apartments\/(\d+)/, 1]
  end
end
