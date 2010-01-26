require 'rubygems'
require 'hpricot'
require 'json'
require 'open-uri'
require 'timetable'
require 'pp'

def tidy(html)
  tidied_html = ""
  Open3.popen3("tidy --force-output true") do |stdin, stdout, stderr|
    stdin.puts(html)
    stdin.close
    tidied_html << stdout.read
  end
  return tidied_html
end

module Parser
  
  class Service
  
    attr_accessor :code, :name, :url
    
    def initialize(elements)
      datum = elements.search('td small')
      self.code = datum.first.inner_html.gsub!('Service ', '').gsub(':','').strip
      link = datum.last.at('a')
      self.name = link.inner_html
      self.url = link['href']
    end
    
    def to_json
      {
        'name' => self.name,
        'code' => self.code,
        'url' => self.url
      }.to_json
    end
    
  end


  class ServicePage
  
    def self.parse
      # http://www.translink.co.uk/present/IndexOpSvc.asp
      data = File.read('../data/services.html')
      document = Hpricot(data)
    
      service_info_tables = document.search('td.bodyText table')
      service_info = service_info_tables.first # metro only
    
      services = service_info.search('//tr')
    
      return services.collect! { |s| Service.new(s) }
    end
  
  end

end


services = Parser::ServicePage.parse
puts services.inspect
File.open '../data/services.json', "w+" do |file|
  file.flush
  file << services.to_json
end

services.each do |s|
  name = s.url.gsub('.asp','').gsub('MET_','').gsub('_','-')
  puts "**** #{name}"
  
  #http://www.translink.co.uk/present/MET_1A_I.asp s['url']   
  timetables = Parser::TimetablePage.parse(s.url)
  
  File.open "../data/timetables/#{name}.json", "w+" do |file|
    file.flush
    file << JSON.pretty_generate(timetables)
  end
  
end
  
  
  
  
  
  