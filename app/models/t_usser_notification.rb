# frozen_string_literal: true

class TUsserNotification < ApplicationRecord
  belongs_to :t_user

  def name
    n = [
      ("Комнат #{rooms}" if rooms.present?),
      ("м² #{meters}" if meters.present?),
      ("Цена #{price}" if price.present?),
      ("Направление цены #{price_direction_name}" if price_direction_name.present?),

    ].compact.join(', ').gsub('_', '-')

    n.present? ? n : '-'
  end

  def price_direction_name
    return if price_direction.blank?

    case price_direction
    when '+'
      '↑'
    when '-'
    '↓'
    when '='
    '↑↓'
    else
      nil
    end
  end
end
