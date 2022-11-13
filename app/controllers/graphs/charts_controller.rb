# frozen_string_literal: true

module Graphs
  class ChartsController < ApplicationController

    layout 'theme'

    def index
      @charts = {
        'meter'    => { url: graphs_meter_index_path, controller: 'meter' },
        'inc-dec'  => { url: inc_dec_graphs_meter_index_path, controller: 'inc-dec' },
        'split'    => { url: split_graphs_by_rooms_path, controller: 'split' },
        'old-new'  => { url: graphs_old_new_index_path, controller: 'old-new' },
        'by-rooms' => { url: graphs_by_rooms_path, controller: 'by-rooms' },
        'doubles'  => { url: graphs_doubles_path, controller: 'doubles' },
      }
    end
  end
end
