# frozen_string_literal: true

class TUsserNotification < ApplicationRecord
  belongs_to :t_user

  def name
    [
      ("Комнат #{rooms}" if rooms.present?),
      ("м² #{meters}" if meters.present?),
      ("Цена #{price}" if price.present?),
    ].compact.join(', ').gsub('_', '-')
  end
end
