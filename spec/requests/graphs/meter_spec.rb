# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Graph Meter controller  ", type: :request do
  context 'chart data' do
    let!(:flats_hist1) { create(:flats_hist) }
    let!(:flats_hist2) { create(:flats_hist) }

    it "get data for average meter price" do
      get "/graphs/meter.json"

      expect(assigns(:hists)).to eq([{ "avg" => "0.09","count":2,"date" => "2022-08-01","id" => nil }].to_json)
    end
  end
end
