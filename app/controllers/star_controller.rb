# frozen_string_literal: true

class StarController < ApplicationController
  def index
  end

  def create
    binding.irb
    Star.new(user_id: current_user.id)
  end

  private

  def permited_params
    params.permit(:url)
  end
end
