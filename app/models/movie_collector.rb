class MovieCollector
  include Capybara::DSL
  attr_accessor :url

  def collect
    15.times do |page|
      page = page + 1
      visit "http://kinohod.ru/msk/movie/#=&page=#{page}"
      sleep 2
      break if has_content?('Фильмов по вашему запросу не найдено.')
      all(".info").each do |info|
        Movie.create(title: info.find('.head').text, link: info.all('a')[0]['href']).save!
      end
    end
  end
end

