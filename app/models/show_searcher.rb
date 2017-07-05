class ShowSearcher
  # def find_cheapest

  # end

  def find_cheapest(title:)
    shows = Show.future.where(movie: Movie.find_by(title: title))
    shows.order(:price).take(100)
  end

  def find_nearest_by_time(longitude:, latitude:, time:, title:)
    theatres = nearest_theatres(longitude: longitude, latitude: latitude)
    Show.at(Time.zone.parse time)
        .where(theatre_id: theatres.keys, movie: Movie.find_by(title: title))
        .order(:price)
  end

  def find_nearest(longitude:, latitude:, title:)
    theatres = nearest_theatres({longitude: longitude, latitude: latitude})
    Show.where(theatre_id: theatres.keys, movie: Movie.find_by(title: title)).order(:price)
  end

  def find_by_time(time: , title:)
    Show.at(time.in_time_zone('Moscow')).where(movie: Movie.find_by(title: title)).order(:price)
  end

  def nearest_theatres(location)
    Theatre.nearest(longitude: location[:longitude], latitude: location[:latitude]).to_hash.group_by{|th| th['id']}
  end
end
