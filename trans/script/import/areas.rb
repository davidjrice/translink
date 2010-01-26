load File.join(File.dirname(__FILE__), '..', '..', 'config', 'environment.rb')

path = File.join(File.dirname(__FILE__), '..', '..', 'data', 'areas.json')

areas = JSON.parse File.read(path)

areas.each do |a|
  Area.create(:name => a['name'], :code => a['code'])
end

