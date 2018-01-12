class MovieCollector
  include Capybara::DSL
  attr_accessor :url

  def collect
    ActiveRecord::Base.transaction do
      DatabaseCleaner.clean_with(:truncation, reset_ids: true, only: %w[movies])
      movies = []
      15.times do |page|
        page = page + 1
        visit "https://kinohod.ru/msk/movie/#=&page=#{page}"
        sleep 2
        break if has_content?('Фильмов по вашему запросу не найдено.')
        all(".info").each do |info|
          movies << {title: info.find('.head').text, link: info.all('a')[0]['href']}
        end
      end
      Movie.create(movies)
    end
  end
end
