class Route < ActiveRecord::Base
  
  belongs_to :area
  belongs_to :service
  
  has_many :route_stops
  has_many :stops, :through => :route_stops
  
  def direction
    case code
    when "I"
      return "Inbound"
    when "O"
      return "Outbound"
    when "X"
      return "Unknown"
    end
  end
  
  def full_code_hyptenated
    "#{area.code}#{service.code}-#{code}"
  end
  
end