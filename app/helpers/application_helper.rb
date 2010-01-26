# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Define the $GMAPS_API_KEY inside environments/:env.rb
  #
  def google_maps_include
    "<script src='http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=true&amp;key=#{$GMAPS_API_KEY}' type='text/javascript'></script>"
  end
end
