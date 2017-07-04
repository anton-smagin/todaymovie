class CreateShows < ActiveRecord::Migration[5.1]
  def change
    create_table :shows do |t|
      t.integer :movie_id
      t.integer :theatre_id
      t.integer :price
      t.time :time

      t.timestamps
    end
  end
end
