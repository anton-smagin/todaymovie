class Theatre < ApplicationRecord
  has_many :shows
  has_many :movies, through: :shows

  KM10 = 10_000

  def self.nearest(location = {})
    # theatres = Arel::Table.new(:theatres)
    # query = theatres.project(theatres[:id],
    #                           theatres[:title],
    #                           theatres[:address],
    #                           "ST_Distance(theatres.latlon, ST_point(#{location[:latitude]}, #{location[:longitude]}))
    #                           as distance")
    #                 .where("ST_DWithin(theatres.latlon, ST_point(#{location[:latitude]}, #{location[:longitude]}), #{KM10})")
    #                 .order(:distance)
    #                 .take(20)
     ActiveRecord::Base.connection.exec_query(nearest_query(location))
  end

  def self.nearest_query(location)
    "SELECT id,
            title,
            address,
            ST_Distance(latlon, ST_point(55.86879, 37.46509)) AS distance
     FROM theatres
     WHERE ST_DWithin(latlon, ST_point('#{location[:latitude]}', '#{location[:longitude]}'), #{KM10})
     ORDER BY distance"
  end
end
