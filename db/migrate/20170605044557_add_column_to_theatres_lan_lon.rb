class AddColumnToTheatresLanLon < ActiveRecord::Migration[5.1]
  def change
    add_column :theatres, :latlon, :geography, limit: {:srid=>4326, :type=>"point", :geographic=>true}, null: false
  end
end
