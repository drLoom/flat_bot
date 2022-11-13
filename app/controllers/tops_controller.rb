# frozen_string_literal: true

class TopsController < ApplicationController
  def top_flats
    @top_flats = Rails.cache.fetch("TopsController#top_flats_#{rooms}", expires_in: 1.hours) do
      FlatsHist.recent.where(rooms: rooms).order(price_usd: :desc).limit(10)
    end
  end

  private

  def rooms
    params[:rooms]
  end
end
