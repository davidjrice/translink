class IphoneController < ApplicationController
  
  # GET /(index.html)
  def index
    @areas = Area.find(:all)
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

end