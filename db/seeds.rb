# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
MovieCollector.new.collect
ShowCollector.new.collect_all_shows
# FactoryGirl.create(:show)
# Theatre.create(longitude: 1, latitude: 2, address: 'тестовый адрес', title:'кинотеатр')
