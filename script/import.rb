require File.join(File.dirname(__FILE__), '..', 'config', 'boot.rb')
require 'atco'

# get list of all data files
files = Dir.glob("data/*")
files.delete_if { |f| File.directory?(f) }
files.delete_if { |f| f =~ /.DS_Store/ }
files.delete_if { |f| !(f =~ /.cif$/ )}

puts files.inspect
# puts "No cif files in data/ (see: http://www.opendatani.info)"

files.each do |f|

  path = File.expand_path(f)
  data = File.read(path)
  atco = Atco.parse(data)
  
  # handle atco data and create database objects
  area = Area.find_by_code(atco["journeys"].first.first["route_number"])
  puts area.inspect
  # * area  
  # * service
  # * route
  # * route_stop
  # * stop

end