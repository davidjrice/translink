require 'rubygems'
require 'json'
require 'pp'

services_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'services.json')
areas_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'areas.json')

output_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'services-new.json')


areas = JSON.parse File.read(areas_path)
puts "AREAS: #{areas.size}"
puts pp areas.inspect
areas.reverse!

puts pp areas.inspect


services = JSON.parse File.read(services_path)
puts "SERVICES: #{services.size}"

area_codes = areas.map { |a| a['code'].to_i }


output = {}
# Iterate each area
areas.each do |area|
  serviced = services.select { |s| s['code'] =~ /#{area['code']}\w/ }
  serviced.delete_if { |s| !s['code'].to_i == area['code'].to_i }
  codes = serviced.map { |s| s['code'].gsub(area['code'],'') }
  output[area['code']] = codes
end

File.open output_path, "w+" do |file|
  file.flush
  file << JSON.pretty_generate(output)
end

# extract services for that area
# services.map 

# 
# { "1": ["A", "B", "C" ]  }




# 
# timetables = Dir.entries(timetables_path)
# timetables.delete_if { |t| t == "." || t == ".." }
# puts "JSON FILES: #{timetables.size}"
# 
# failures = 0
# timetables.each do |timetable|
#   begin
#     full_path = File.join(timetables_path, timetable)
#     json = JSON.parse File.read(full_path)
#     if json.size == 0
#       failures += 1
#       puts "FAILURE: #{timetable} : JSON size is 0"
#     end
#   rescue Exception => e
#     failures += 1
#     puts "FAILURE: #{timetable} : #{e.class} : #{e.message}"
#   end
# end