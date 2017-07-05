class SheduleController < ApplicationController
  def low_price
    respond_to do |f|
      f.html { render :low_price }
    end
  end

  def search
    shows = if search_params['near_me'] && search_params['with_time']
             ShowSearcher.new.find_nearest_by_time(longitude: search_params['longitude'],
                                                   latitude: search_params['latitude'],
                                                   time: search_params['show_time'],
                                                   title: search_params['title'])
           elsif search_params['near_me']
             ShowSearcher.new.find_nearest(longitude: search_params['longitude'],
                                           latitude: search_params['latitude'],
                                           title: search_params['title'])
           elsif search_params['with_time']
             ShowSearcher.new.find_by_time(title: search_params['title'], time: search_params['show_time'])
           else
             ShowSearcher.new.find_cheapest(title: search_params['title'])
           end
    render json: build_json(shows)
  end

  def build_json(shows)
    shows.map do |show|
      {cinema: {name: show.theatre.title, address: show.theatre.address},
       show: {time: show.show_time.in_time_zone('Moscow').strftime('%H:%M'), price: show.price}}
    end.to_json
  end

  def search_params
    params.require(:search).permit(:show_time, :near_me, :title, :with_time, :latitude, :longitude)
  end
end
