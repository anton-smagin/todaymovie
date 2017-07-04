class CreateTheatres < ActiveRecord::Migration[5.1]
  def change
    create_table :theatres do |t|
      t.string :title
      t.float :longitude
      t.float :latitude
      t.string :address

      t.timestamps
    end
  end
end
