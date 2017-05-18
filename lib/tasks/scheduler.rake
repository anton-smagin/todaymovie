desc "This task is called by the Heroku scheduler add-on"
task :update_movies => :environment do
  puts "Updating movies..."
  MovieCollector.new.collect
  puts "done."
end
