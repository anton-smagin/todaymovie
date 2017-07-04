class ChangeColumnNameShow < ActiveRecord::Migration[5.1]
  def change
    rename_column :shows, :time, :show_time
  end
end
