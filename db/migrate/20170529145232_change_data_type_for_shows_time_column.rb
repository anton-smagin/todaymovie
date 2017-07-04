class ChangeDataTypeForShowsTimeColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :shows, :time
    add_column :shows, :time, :datetime
  end
end
