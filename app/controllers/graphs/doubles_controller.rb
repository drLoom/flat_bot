# frozen_string_literal: true

module Graphs
  class DoublesController < ApplicationController
    def index
      @doubles = Rails.cache.fetch("DoublesController#doubles", expires_in: 1.hours) do
        Repositories::Flats::Doubles.new.call
      end

      respond_to do |format|
        format.json { render json: @doubles }
      end
    end
  end
end
