class Service < ActiveRecord::Base
  has_many :routes
  belongs_to :area
end