class CreateTheatres < ActiveRecord::Migration[5.1]
  def change
    create_table :theatres do |t|
      t.string :title
      t.float :longitude
      t.float :latitude
      t.string :address
      t.st_point :latlon, limit: {:srid=>4326, :type=>"point", :geographic=>true}, null: false
      t.timestamps
    end
  end
end
