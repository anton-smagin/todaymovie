class Show < ApplicationRecord
  belongs_to :movie
  belongs_to :theatre

  scope :future, -> { where('show_time > ? AND price != 0', Time.zone.now) }
  scope :at, -> (show_time) { where('show_time > ? AND show_time < ?', show_time, show_time + 1.hour) }
end
