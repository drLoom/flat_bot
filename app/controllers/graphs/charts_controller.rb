# frozen_string_literal: true

module Graphs
  class ChartsController < ApplicationController

    layout 'theme'

    def index
      @charts = {
        'meter'   => { url: graphs_meter_index_path, controller: 'meter' },
        'old-new' => { url: graphs_old_new_index_path, controller: 'old-new' },
        'doubles' => { url: graphs_doubles_path, controller: 'doubles' },
      }
    end
  end
end
