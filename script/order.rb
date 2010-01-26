load File.join(File.dirname(__FILE__), '..', 'config', 'environment.rb')

def find_next_nearest(from, stops)
  from_coord    = Geodesic::Position.new(from.lat.to_f, from.lon.to_f)
  stops.each do |to|
    to_coord = Geodesic::Position.new(to.lat.to_f, to.lon.to_f)
    to.distance = Geodesic::dist_haversine(from_coord.lat, from_coord.lon, to_coord.lat, to_coord.lon)
  end
  stops.sort { |a,b| a.distance <=> b.distance }
end

areas = Area.find(:all)
areas.each do |area|
  area.services.each do |serv|
    serv.routes.each do |route|
      
      ## NEAREST NEIGHBOUR
      nodes = route.stops.clone
      $CBD = Stop.new(:lat => "54.596571", :lon => "-5.930235")

      ordered = []
      node = find_next_nearest($CBD, nodes).first
      ordered << node
      nodes.delete(node)
      
      while( !nodes.empty? ) do
        node = find_next_nearest(node, nodes).first
        ordered << node
        nodes.delete(node)
      end
      #
      # TODO
      #   - extract a full_code method for reuse
      #
      # puts "#{area.code}#{serv.code}#{route.code}"
      ordered.each_with_index do |node, i|
        #
        # TODO 
        #   - investigate issue with several Routes
        #
        # 2GO, 2GI, 2GX, 2HO, 2HI, 2HX
        #
        unless node.nil?
          RouteStop.find_by_stop_id_and_route_id(node.id, route.id).update_attribute(:order,i)
        end
      end
    
    end
  end
end