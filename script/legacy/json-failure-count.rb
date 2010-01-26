require 'rubygems'
require 'json'

services_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'services.json')
timetables_path = File.join(File.dirname(__FILE__), '..', 'public', 'data', 'timetables')

services = JSON.parse File.read(services_path)
puts "SERVICES: #{services.size}"

timetables = Dir.entries(timetables_path)
timetables.delete_if { |t| t == "." || t == ".." }
puts "JSON FILES: #{timetables.size}"

failures = 0
timetables.each do |timetable|
  begin
    full_path = File.join(timetables_path, timetable)
    json = JSON.parse File.read(full_path)
    if json.size == 0
      failures += 1
      puts "FAILURE: #{timetable} : JSON size is 0"
    end
  rescue Exception => e
    failures += 1
    puts "FAILURE: #{timetable} : #{e.class} : #{e.message}"
  end
end