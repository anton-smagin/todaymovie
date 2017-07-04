require 'spec_helper'

describe Theatre do
  context '#nearest' do
    it 'search nearest theatre' do
      closest_theatre = create(:theatre,
                               longitude: 37.46521,
                               latitude: 55.86882,
                               latlon:  RGeo::ActiveRecord::SpatialFactoryStore.instance
                                                                               .factory(:geo_type => 'point')
                                                                               .point(55.86882, 37.46521))
       create(:theatre,
               longitude: 0.0001,
               latitude: 0.0001,
               latlon:  RGeo::ActiveRecord::SpatialFactoryStore.instance
                                                               .factory(:geo_type => 'point')
                                                               .point(0.0001, 0.0001))
      result = Theatre.nearest(longitude:37.46522,latitude: 55.86882)
      expect(Theatre.count).to eq(2)
      expect(result.count).to eq(1)
      expect(result.first['title']).to eq(closest_theatre.title)
    end
  end

end
