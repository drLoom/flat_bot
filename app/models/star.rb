# frozen_string_literal: true

class Star < ApplicationRecord
  belongs_to :user

  belongs_to :flat_view,
    class_name: 'FlatView', inverse_of: :star, foreign_key: :object_id, primary_key: :object_id
end
