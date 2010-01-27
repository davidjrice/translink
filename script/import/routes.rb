load File.join(File.dirname(__FILE__), '..', '..', 'config', 'environment.rb')

path = File.join(File.dirname(__FILE__), '..', '..', 'data', 'routes.json')
stops_path = File.join(File.dirname(__FILE__), '..', '..', 'data', 'stops.json')

data = JSON.parse File.read(path)
stops = JSON.parse File.read(stops_path)

# Areas
data.each do |key,values|  
  area = Area.find_by_code(key)

  # Services
  values.each do |key,values|
    serv = Service.find_by_area_id_and_code(area.id, key)

    # Routes
    values.each do |key, values|      
      route = Route.find_by_code_and_area_id_and_service_id(key, area.id, serv.id)
      if values.size
        values.each do |stop|
          s = stops[stop]
          new_stop = Stop.find_or_create_by_code(s['lat'].to_s + "," + s['lon'].to_s)
          new_stop.attributes = {
            :name => s['name'],
            :lat => s['lat'].to_s,
            :lon => s['lon'].to_s,
            :street => s['street'],
            :direction => s['direction']
          }
          
          new_stop.save
          # TODO rename to Node
          RouteStop.create :stop_id => new_stop.id, :route_id => route.id
        end
      end
      
    end
    
  end
end



