ActionController::Routing::Routes.draw do |map|
  
  map.with_options :controller => 'translink' do |translink|
    translink.areas '/areas.:format', :action => 'areas'
    translink.services '/services.:format', :action => 'services'
    translink.routes '/routes.:format', :action => 'routes'
    translink.stops '/:area/:service/:route/stops.:format', :action => 'stops'
    translink.maps '/:area/:service/:route/maps', :action => 'maps'
    translink.timetables '/:area/:service/:route/timetables.:format', :action => 'timetables'
  end
  
  map.root :controller => 'translink'
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end