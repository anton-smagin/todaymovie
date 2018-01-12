FactoryBot.define do
  theater_logitude = Faker::Number.decimal(2, 5)
  theatre_latitude = Faker::Number.decimal(2, 5)
  factory :theatre do
    title { Faker::App.name }
    longitude { theater_logitude }
    latitude { theatre_latitude }
    address { Faker::Address.street_address }
    latlon do
      RGeo::ActiveRecord::SpatialFactoryStore.instance
                                             .factory(geo_type: 'point')
                                             .point(theatre_latitude,
                                                    theater_logitude)
    end
  end
end
