load File.join(File.dirname(__FILE__), '..', '..', 'config', 'environment.rb')

path = File.join(File.dirname(__FILE__), '..', '..', 'data', 'services.json')
data = JSON.parse File.read(path)

data.each do |key,values|  
  area = Area.find_by_code(key)

  values.each do |key,values|
    service = Service.create(:area_id => area.id, :code => key)
    
    values.each do |key, value|
      Route.create(:area_id => area.id, :service_id => service.id, :code => key, :name => value)
    end
    Route.create(:area_id => area.id, :service_id => service.id, :code => "X", :name => "Unknown")
    
  end
end



