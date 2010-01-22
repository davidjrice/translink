require 'rubygems'
require 'json'
require 'pp'

@stops = {}
def extract_stops(route)
  
  new_stops = []
  route.each do |i|
    stop_code = "#{i['lat']}:#{i['lon']}"
    
    new_stops << stop_code
    unless @stops[stop_code]
      @stops[stop_code] = {
        "code" => stop_code,
        "direction" => i['direction'],
        "lat" => i['lat'],
        "lon" => i['lon'],
        "name" => i['stopname'],
        "street" => i['street']
      }
    end
  end
  new_stops
end

routes_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'metro.json')

stops_output_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'stops.json')
routes_output_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'routes-new.json')


routes = JSON.parse File.read(routes_path)

new_routes = {}
[1,2,3,4,5,6,7,8,9,10,11,12].each do |area_code|
  new_routes[area_code.to_s] = {}
  ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"].each do |letter|
    
    route = routes.select{ |k,v| k == "#{area_code}#{letter}"}.first
    if route
      unknown = ["Both", "CityCentre", "Other", "Terminal"]
      # grab all the stops
      # extract inbound / outbound
      
      # First element is actually the original key of this hash element
      route.shift
      route.flatten!
      puts route.inspect

      # extra stop info saving to separate file. Use a code to identify (gps lat lon concatenated ?)
      inbound = route.select{|stop| stop['direction'] == "Inward" }
      outbound = route.select{|stop| stop['direction'] == "Outward" }
      unknown = route.select{|stop| unknown.include?(stop['direction']) }
      
      # recombine new route data.
      new_routes[area_code.to_s][letter] = {}
      
      if inbound
        new_inbound = extract_stops(inbound)
        new_routes[area_code.to_s][letter]["I"] = new_inbound
      end
      
      if outbound
        new_outbound = extract_stops(outbound)
        new_routes[area_code.to_s][letter]["O"] = new_outbound
      end
      
      if unknown
        new_unknown = extract_stops(unknown)
        new_routes[area_code.to_s][letter]["X"] = new_unknown
      end
      
    end
  end

end

File.open stops_output_path, "w+" do |file|
  file.flush
  file << JSON.pretty_generate(@stops)
end

File.open routes_output_path, "w+" do |file|
  file.flush
  file << JSON.pretty_generate(new_routes)
end