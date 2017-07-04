FactoryGirl.define do
  THEATRE_LONGITUDE = Faker::Number.decimal(2, 5)
  THEATRE_LATITUDE = Faker::Number.decimal(2, 5)
  factory :theatre do
    title    { Faker::App.name }
    longitude { THEATRE_LONGITUDE }
    latitude { THEATRE_LATITUDE }
    address { Faker::Address.street_address }
    latlon {
      RGeo::ActiveRecord::SpatialFactoryStore.instance
                                             .factory(:geo_type => 'point')
                                             .point(THEATRE_LATITUDE, THEATRE_LONGITUDE)
    }
  end
end
