require 'rubygems'
require 'json'
require 'pp'

services_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'services.json')
areas_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'areas.json')

output_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'services-new.json')
misc_output_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'misc-services.json')


areas = JSON.parse File.read(areas_path)
puts "AREAS: #{areas.size}"
puts pp areas.inspect
areas.reverse!

puts pp areas.inspect


services = JSON.parse File.read(services_path)
puts "SERVICES: #{services.size}"

area_codes = areas.map { |a| a['code'].to_i }

used_services = []

output = {}
# Iterate each area
areas.each do |area|
  serviced = services.select { |s| s['code'] =~ /^(#{area['code']}){1}[a-zA-Z]{1}$/ }
  #serviced = serviced.delete_if { |s| !s['code'].to_i == area['code'].to_i }
  
  area_services = {}
  seen_codes = []
  ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"].each do |letter|
    grouped_services = serviced.select { |s| s['code'] =~ /^#{area['code']}{1}#{letter}{1}$/ }
    
    if grouped_services.size > 0
      # Inbound first
      inbound = grouped_services.select{|s| s['url'] =~ /I.asp$/ }.first
    
      # Outbound second
      outbound = grouped_services.select{|s| s['url'] =~ /O.asp$/ }.first
    
      code = inbound['code'].gsub(area['code'],'')
    
      area_services[code] = {}
      if outbound
        area_services[code]["O"] = outbound['name']
      end
      if inbound
        area_services[code]["I"] = inbound['name']
      end
    end
  end
  used_services << serviced
  
  #codes = serviced.map { |s| s['code'].gsub(area['code'],'') }
  output[area['code']] = area_services
end

File.open output_path, "w+" do |file|
  file.flush
  file << JSON.pretty_generate(output)
end

unused = services - used_services 
File.open misc_output_path, "w+" do |file|
  file.flush
  file << JSON.pretty_generate(unused)
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