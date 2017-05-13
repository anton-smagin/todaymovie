class Shedule
  def find_cheapest

  end

  def self.find_cheapest_by_title(movie)
    # 'http://kinohod.ru/movie/9950/'
    url = Movie.find_by(title: movie.mb_chars.downcase.to_s).link
    html = Net::HTTP.get(URI(url))
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
        time_table: showes
       }
    end
    cheapest_showes(movie_info)
  end

  def self.cheapest_showes(movie_info)
    cheapest_price = 100_000
    cheapest_showes = []
    movie_info.each do |show|
      show[:time_table].each do |s|
        if s[:price] < cheapest_price && s[:price] != 0
          cheapest_price = s[:price]
          cheapest_showes = [{ cinema: beautify_cinema_theater(show[:cinema_theater]),
                              show: {time: s[:time], price: s[:price]} }]
        elsif s[:price] == cheapest_price
          cheapest_showes << { cinema: beautify_cinema_theater(show[:cinema_theater]),
                               show: {time: s[:time], price: s[:price]} }
        end
      end
    end
    cheapest_showes
  end

  def self.beautify_cinema_theater(data)
    baloon = data.first.second['balloon'] # what?????
    {name: baloon['cinema_name'],
     address: baloon['cinema_address']}
  end

end
