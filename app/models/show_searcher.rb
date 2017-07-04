class ShowSearcher
  # def find_cheapest

  # end

  def find_cheapest
    shows = Show.future
    shows.order(:price).take(100)
  end

  def find_nearest_by_time(longitude:, latitude:, time:)
    theatres = nearest_theatres(longitude: longitude, latitude: latitude)
    Show.at(time.to_time).where(theatre_id: theatres.keys).order(:price)
  end

  def find_nearest(location)
    theatres = nearest_theatres(location)
    Show.where(theatre_id: theatres.keys).order(:price)
  end

  def find_by_time(time)
    Show.at(time.to_time).order(:price)
  end

  def nearest_theatres(location)
    Theatre.nearest(longitude: location[:longitude], latitude: location[:latitude]).to_hash.group_by{|th| th['id']}
  end
end
