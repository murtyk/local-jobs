# for caching lat longs
class Location < ActiveRecord::Base
  def latlng
    [lat, lng]
  end
end
