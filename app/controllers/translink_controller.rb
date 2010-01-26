class TranslinkController < ApplicationController
  
  # GET /(index.html)
  
  # GET /areas.json
  # GET /areas
  #
  def areas
    @areas = Area.find(:all)
    respond_to do |format|
      format.json { render :json => @areas.to_json }
      format.html { render }
    end
  end
  
  # GET /services.json
  # GET /services
  #
  def services
    @services = Service.find(:all, :order => "area_id, code")
    respond_to do |format|
      format.json { render :json => @services.to_json }
      format.html { render }
    end
  end
  
  # GET /routes.json
  # GET /routes
  #
  def routes
    @routes = Route.find(:all, :order => "area_id, service_id, code")
    respond_to do |format|
      format.json { render :json => @routes.to_json }
      format.html { render }
    end
  end
  
  # GET /:area/:service/:route/stops.json 
  #
  def stops
    # TODO 
    #   - This could really be one query.
    #
    area = Area.find_by_code(params[:area])
    service = Service.find_by_area_id_and_code(area.id, params[:service])
    @route = Route.find_by_area_id_and_service_id_and_code(area.id, service.id, params[:route])
    @stops = @route.stops.find(:all, :order => "position")
    
    
    respond_to do |format|
      format.json { render :json => @stops.to_json }
      format.html { render }
    end
  end
  
  # GET /:area/:service/:route/map 
  #
  def maps
    # TODO 
    #   - This could really be one query.
    #
    area = Area.find_by_code(params[:area])
    service = Service.find_by_area_id_and_code(area.id, params[:service])
    @route = Route.find_by_area_id_and_service_id_and_code(area.id, service.id, params[:route])
    @stops = @route.stops.find(:all, :order => "position")
    
    timetable_path = File.join(RAILS_ROOT, 'public', 'timetables', @route.full_code_hyptenated, '.json')
    @timetable = JSON.parse(File.read(timetable_path))

    respond_to do |format|
      format.html { render }
    end
  end
  
  # GET /:area/:service/:route/timetables.json 
  #
  def timetables
    # TODO import timetables from old repo
  end
  
end