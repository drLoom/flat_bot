# frozen_string_literal: true

module Graphs
  class ByRoomsController < ApplicationController
    def index
      @data = Rails.cache.fetch("ByRoomsController#data", expires_in: 1.hours) do
        Repositories::Flats::ByRooms.new.call
      end

      respond_to do |format|
        format.json { render json: @data }
      end
    end
  end
end
