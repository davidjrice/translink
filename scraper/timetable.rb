require 'rubygems'
require 'hpricot'
require 'json'
require 'open-uri'
require 'open3'
require 'timeout'

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
  
  class Timetable
  
    attr_accessor :frequency # M-F, S, Su
    attr_accessor :journeys
    
    def determine_frequency(document)
      if document.to_html =~ /&nbsp;M-F&nbsp/
        self.frequency = 'weekdays'
      elsif document.to_html =~ /&nbsp;S&nbsp/
        self.frequency = 'saturday'
      elsif document.to_html =~ /&nbsp;Su&nbsp/
        self.frequency = 'sunday'
      end
    end
    
    def parse(document)
      puts "parsing..."

      determine_frequency(document)
      
      rows = document.search('tr')
      number_of_columns = rows[5].search('td').size
      number_of_rows = rows.size - 5
      
      rows = rows[5..rows.size]
      times_by_stop = []
      rows.each do |element|
        stop = element.search('th').inner_html
        times = element.search('td').map { |e| e.inner_html.gsub!('&nbsp;','')}
        times_by_stop << {'name' => stop, 'times' => times}
      end 
      
      journeys = Array.new(number_of_columns)
      journeys.each_with_index do |journey,i|
        journeys[i] = []
        times_by_stop.each do |stop|
          journeys[i] << {'stop' => stop['name'], 'time' => stop['times'][i]}
        end
      end
      
      self.journeys = journeys
    end
    
    def initialize(data)
      data.collect{ |datum| parse(datum)}.flatten
    end
    
    def to_json(arg1,arg2)
       {
         'frequency' => self.frequency,
         'journeys' => self.journeys,
       }.to_json
    end
    
  end


  class TimetablePage
    
    def self.retrieve(data)
      doc = open("http://www.translink.co.uk/present/#{data}").read
      name = data.gsub('.asp','').gsub('MET_','').gsub('_','-')
      tidy(doc)
    end
    
    def self.process(data)
      document = Hpricot(data)
      timetables = document.search('table.jpTable')
      frequency_headers = document.search('a[@name]')
      frequency_headers.delete_if { |e| e['name'] == 'top'}

      grouping = {}
      context = nil

      container = document.at('div#content_container')
      siblings = container.children
      siblings.each do |element|
        if frequency_headers.include?(element)
          context = element['name'].downcase
        elsif timetables.include?(element)
          grouping[context] = [] if grouping[context].nil?
          grouping[context] << element
        end
      end
      
      timetables = {}
      ['weekdays', 'saturday', 'sunday'].each do |freq|
        begin
          timetables[freq] = Timetable.new(grouping[freq])
        rescue Exception => e
          puts "==== FAILURE ==== #{e.class} : #{e.message} : #{data}"
          puts e.backtrace
          
        end
      end
      
      {"weekdays" => timetables['weekdays'], 'saturday' => timetables['saturday'], 'sunday' => timetables['sunday']}
    end
    
    def self.parse(data)
      doc = nil
      begin
        Timeout::timeout(20) do
          doc = retrieve(data)
        end
      rescue Exception => e
        puts "==== FAILURE RETRIEVING ==== #{e.class} : #{e.message} : #{data}"
      end
      
      output = nil
      begin
        output = process(doc)
      rescue Exception => e
        puts "==== FAILURE PROCESSING ==== #{e.class} : #{e.message} : #{data}"
        puts e.backtrace
        
      end
      
    end
  
  end

end

#timetables = Parser::TimetablePage.parse('MET_9A_I.asp')
#puts timetables.inspect