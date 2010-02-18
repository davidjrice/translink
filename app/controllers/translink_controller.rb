class TranslinkController < ApplicationController
  
  # GET /(index.html)
  def index
    respond_to do |format|
      format.html { render }
      format.iphone { render }
    end
  end

  # GET /current_bus_locations/:timestamp.json
  def current_bus_locations
    # get all the routes
    # iterate each service
      # find the journey that exists at that time
      # find the nearest departure / arrival point to the time
        # return the point if it is exactly matching the current time
          # for a given departure / arrival
        # return a midway point of the location between two stops
      # also return the compass direction [OPTIONAL]
    [{:service => '9AI', :lat => 'xxx', :lon => 'xxx'},{...}]
  end
  
  # GET /areas.json
  # GET /areas
  #
  def areas
    @areas = Area.find(:all)
    respond_to do |format|
      format.json { render :json => @areas.to_json }
      format.html { render }
      format.iphone { render }
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
    
    begin
      timetable_path = File.join(RAILS_ROOT, 'public', 'timetables', "#{@route.full_code_hyptenated}.json")
      times = JSON.parse(File.read(timetable_path))
    
      @timetable = {}
      times.each do |frequency, journeys|
        @timetable[frequency] = []
        journeys['journeys'].each do |journey|
          @timetable[frequency] << journey
        end
      end
    rescue
      # do nothing
    end
    
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