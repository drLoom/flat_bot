# frozen_string_literal: true

class TUser < ApplicationRecord
  has_many :notifications, class_name: "TUsserNotification"
end
