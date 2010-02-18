
# get list of all data files
files = Dir.glob("data/.*")
files.each do |f|
  path = File.expand_path(File.join('data',f))
  data = File.read(path)
  atco = Atco.parse(data)
  
  # handle atco data and create database objects
  
  # * area
  # * service
  # * route
  # * route_stop
  # * stop

end