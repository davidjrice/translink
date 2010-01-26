class RouteStop < ActiveRecord::Base
  
  belongs_to :stop
  belongs_to :route
  
end