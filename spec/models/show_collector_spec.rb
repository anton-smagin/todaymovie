require 'spec_helper'

describe ShowCollector do
  context 'after collection of shows and theatres from fixture file' do
    before(:each) do
      @movie = create(:movie, :fixture)
      expect(Net::HTTP).to receive(:get) { File.read(Rails.root.join('spec','support','fixtures', 'parse.html')) }
      ShowCollector.new.collect_all_shows
    end
    it 'creates theatres' do
      expect(Theatre.all.count).to eq 32
    end

    it 'creates shows' do
     expect(@movie.shows.count).to eq 39
    end

    it 'has theatre baltika with right coordinates' do
      baltika = Theatre.find_by(title: 'Кинотеатр «Балтика»')
      expect(baltika.longitude).to eq(37.444069)
      expect(baltika.latitude).to eq(55.850394)
    end

    it 'has theatre baltika with right address' do
       baltika = Theatre.find_by(title: 'Кинотеатр «Балтика»')
       expect(baltika.address).to match 'ул. Сходненская, д. 56'
    end

    it 'has cheapest show price 169' do
      show = Show.where('price = ?', Show.minimum(:price)).first
      expect(show.price).to eq(169)
      expect(show.show_time).to eq('19:15'.to_time)
    end

    it 'has cheapest show has theatre' do
      show = Show.where('price = ?', Show.minimum(:price)).first
      expect(show.theatre.title).to match('Час Кино (Бибирево)')
    end
  end
end
