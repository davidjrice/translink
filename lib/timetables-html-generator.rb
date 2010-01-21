Dir.entries('public/data/timetables').each do |dir|
  puts "<li><a href='/data/timetables/#{dir}'>#{dir}</a></li>"
end