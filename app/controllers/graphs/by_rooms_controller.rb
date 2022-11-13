# frozen_string_literal: true

module Graphs
  class ByRoomsController < ApplicationController
    def index
      @data = Rails.cache.fetch("ByRoomsController#index", expires_in: 1.hours) do
        Repositories::Flats::ByRooms.new.call
      end

      respond_to do |format|
        format.json { render json: @data }
      end
    end

    def split
      @data = Rails.cache.fetch("ByRoomsController#split", expires_in: 1.hours) do
        FlatsHist.recent.group(:rooms).count
      end

      respond_to do |format|
        format.json { render json: @data.to_json }
      end
    end
  end
end
