class Movie < ApplicationRecord
  has_many :shows
  has_many :theatres, through: :shows

  scope :with_shows, -> {where(has_shows: true)}
  def has_shows?
    has_shows
  end
end
