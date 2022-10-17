# frozen_string_literal: true

module Graphs
  class OldNewController < ApplicationController
    def index
      @old_new = Rails.cache.fetch("OldNewController#old_new", expires_in: 1.hours) do
        Repositories::Flats::OldNew.new.call
      end

      respond_to do |format|
        format.json { render json: @old_new }
      end
    end
  end
end
