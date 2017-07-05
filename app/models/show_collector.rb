class ShowCollector
  attr_accessor :theatres, :shows, :movies
  def collect_all_shows
    ActiveRecord::Base.transaction do
      DatabaseCleaner.clean_with(:truncation, reset_ids: true, only: %w(shows))
      movies = Movie.all.to_a
      movies.each do |movie|
        save_shows(movie)
      end
      Show.create(shows)
      movies_with_shows = shows.map{ |show| show[:movie_id]}
      Movie.where(id:movies_with_shows).update_all(has_shows: true)
    end
  end

  def save_shows(movie)
    shedule(movie).each do |show|
      create_show(movie, show)
    end
  end

  def create_show(movie, show)
    theatre = theatres[beautify_cinema_theater(show[:cinema_theater])[:title]].try(:first) || Theatre.find_or_create_by(beautify_cinema_theater(show[:cinema_theater]))
    show[:time_table].each do |s|
      next if s[:price].zero?
      time = s[:time].in_time_zone
      time = time + 1.day if time.utc.to_date == DateTime.yesterday
      shows << {theatre_id: theatre.id,
                movie_id: movie.id,
                price: s[:price],
                show_time: time}
    end
  end

  def shedule(movie)
    html = Net::HTTP.get(URI(movie.link))
    doc = Nokogiri::HTML(html)
    movie_info = []
    doc.css('.mblock').each do |block|
      showes = []
      block.css('.time').css('.root').each do |tblock|
        showes << { time: tblock.css('h1').text, price: tblock.css('.second').text.scan(/\d+/).first.to_i}
      end
      movie_info <<
       {
        cinema_theater: JSON.parse(block['data-cinema']),
        time_table: showes,
        movie: movie
       }
    end
    movie_info
  end

  def cheapest_shows(movie_info)
    cheapest_price = 100_000
    cheapest_shows = []
    movie_info.each do |show|
      show[:time_table].each do |s|
        if s[:price] < cheapest_price && s[:price] != 0
          cheapest_price = s[:price]
          cheapest_shows = [{ cinema: beautify_cinema_theater(show[:cinema_theater]),
                              show: {time: s[:time], price: s[:price]} }]
        elsif s[:price] == cheapest_price
          cheapest_shows << { cinema: beautify_cinema_theater(show[:cinema_theater]),
                               show: {time: s[:time], price: s[:price]} }
        end
      end
    end
    cheapest_shows
  end

  def beautify_cinema_theater(data)
    baloon = data.first.second['balloon'] # what?????
    geocords = data.first.second['geoCoords']
    {
    title: baloon['cinema_name'],
    address: baloon['cinema_address'],
    latlon:  RGeo::Geographic.spherical_factory(srid: 4326).point(geocords['latitude'],  geocords['longitude']),
    longitude: geocords['longitude'],
    latitude: geocords['latitude']
    }
  end

  def movies
    @movies ||= []
  end

  def theatres
    @theatres ||= Theatre.all.group_by(&:title)
  end

  def shows
    @shows ||= []
  end
end
