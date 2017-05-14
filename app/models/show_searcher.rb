class ShowSearcher
  def find_cheapest

  end

  def find_cheapest(movie)
    # 'http://kinohod.ru/movie/9950/' .mb_chars.downcase.to_s
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
        time_table: showes
       }
    end
    cheapest_showes(movie_info)
  end

  private

  def cheapest_showes(movie_info)
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

  def beautify_cinema_theater(data)
    baloon = data.first.second['balloon'] # what?????
    {name: baloon['cinema_name'],
     address: baloon['cinema_address']}
  end

end
