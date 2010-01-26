require 'rubygems'
require 'json'
require 'pp'
require 'lib/distance'
routes_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'routes-new.json')
routes_output_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'routes-ordered.json')

data = JSON.parse File.read(routes_path)

output = {}
area = nil
service = nil
route = nil

data.each do |a, services|
  area = a
  output[area] = {}
  services.each do |s, routes|
    service = s
    output[area][service] = {}
    routes.each do |r, stops|
      route = r
      output[area][service][route] = {}
        
        # INBOUND
        # take the closest to the CBD and go outward, reverse at end
        inbound = []
        
        if route == "I"
          stops.each do |from|
            from_lat = stop.split(":")[0].to_f
            from_lon = stop.split(":")[1].to_f

            destinations = stops.map do |to| 
              to_lat = stop.split(":")[0].to_f
              to_lon = stop.split(":")[1].to_f
              
              {:distance => gps_distance(from), :to => to}
            end
            
            ordered = destinations.sort { |a,b| a[:distance] <=> b[:distance] }
            
            if ordered.first[:to] == from
              ordered.shift
            end
            inbound << ordered.first
          end
              
            
            
            puts gps_distance(stop.split(":")[0].to_f, stop.split(":")[1].to_f, "54.6022863584815".to_f, "-5.93252935413977".to_f )
          end
        
        # OUTBOUND
        # take the closest to the CBD and go outward
        else route == "O"
          stops.each do |stop|
            puts gps_distance(stop.split(":")[0].to_f, stop.split(":")[1].to_f, "54.6022863584815".to_f, "-5.93252935413977".to_f )
          end
        end
        
        
      end
    end
  end  
end

  
# puts routes.first.inspect