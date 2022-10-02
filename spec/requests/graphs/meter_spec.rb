# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Graph Meter controller  ", type: :request do
  context 'chart data' do
    let!(:flats_hist1) { create(:flats_hist) }
    let!(:flats_hist2) { create(:flats_hist) }

    it "get data for average meter price" do
      get "/graphs/meter"
      expect(response).to render_template(:index)

      expect(assigns(:hists)).to eq({ "2022-08-01" => "0.09" }.to_json)
    end
  end
end
