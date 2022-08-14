# frozen_string_literal: true

class TUsserNotification < ApplicationRecord
  belongs_to :t_user

  def name
    [
      rooms
    ].compact.join(' - ')
  end
end
