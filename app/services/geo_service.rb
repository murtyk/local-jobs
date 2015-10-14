class GeoService
  class << self
    def coordinates(place)
      latlng = read_cache(place)
      return latlng if latlng

      location = Location.find_by(name: place)
      write_cache(place, location.latlng) if location
      return location.latlng if location

      geocode(place)
    end

    def geocode(place)
      results = Geocoder.search place
      if results.blank?
        sleep 0.1
        results = Geocoder.search place
      end

      return cache_geocoder_result(place, results.first) if results.any?
      [0, 0]
    end

    def cache_geocoder_result(place, result)
      latitude = result.latitude.round(2)
      longitude = result.longitude.round(2)
      Location.create(name: place, lat: latitude, lng: longitude)
      write_cache(place, [latitude, longitude])
      [latitude, longitude]
    end

    def read_cache(loc)
      Rails.cache.read loc
    end

    def write_cache(loc, latlng)
      Rails.cache.write(loc, latlng)
    end
  end
end
