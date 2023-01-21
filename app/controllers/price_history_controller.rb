# frozen_string_literal: true

class PriceHistoryController < ApplicationController
  layout 'theme'

  def index
  end

  def create
    object_id = Onliner::Url.new(url: permitted_params[:url]).object_id

    @histories = Repositories::Flats::FlatHistory.new.call(object_id)
    @flat      = FlatsHist.recent.find_by(object_id: object_id)

    render partial: 'table'
  end

  private

  def permitted_params
    params.permit(:url)
  end
end
