class SheduleController < ApplicationController
  def low_price
    respond_to do |f|
      f.html { render :low_price }
    end
  end
end
