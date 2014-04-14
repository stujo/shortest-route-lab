class GPSGuide

  # A instance of a shortest path search
  # Stores current fringe and visitation data
  class Exploration
    attr_reader :trip

    def initialize atlas, fromCity, toCity
      @trip = TripInfo.new(atlas.find_city_by_name(fromCity), atlas.find_city_by_name(toCity))
    end

    def valid?
      @trip.valid?
    end

    def fringe_candidate city
      if !@visitCache.has_key? city
        @visitCache[city] = {visited: false, distance: nil}
        @fringe << city
      elsif @visitCache[city][:visited] == false
        @fringe << city
      end
    end

    # Find the best closest city in the fringe and pop out for our next iteration
    def pop_closest_from_fringe
      closestUnvisitedCity = nil
      @fringe.each do |city|
        if closestUnvisitedCity.nil? || @visitCache[city][:distance] < @visitCache[closestUnvisitedCity][:distance]
          closestUnvisitedCity = city
        end
      end
      @fringe.delete(closestUnvisitedCity) unless closestUnvisitedCity.nil?
      closestUnvisitedCity
    end

    def describe_route_to_trip_info
      if @visitCache[trip.to_city][:visited]
        route = []
        cursor = trip.to_city
        while cursor
          route << cursor.name
          cursor = @visitCache[cursor][:previous]
        end
        route.reverse!
        @trip.setRoute(@visitCache[trip.to_city][:distance], route)
      end
    end

    def plan!
      @visitCache = {}
      currentCity = @trip.from_city
      @fringe = Set.new
      @visitCache[currentCity] = {visited: true, previous: nil, distance: 0}

      # Initialize an empty fringe set
      # Add the neighbors of the starting city to the fringe
      currentCity.each_neighbor do |neighbor|
        fringe_candidate neighbor.city
      end

      # While We have things in the fringe keep looking
      while !@fringe.empty?

        #Update the distances on the fringe and pick the closest neighbor
        currentCity.each_neighbor do |neighbor|

          # Calc distance from currentCity to city
          cityDistance = neighbor.distance + @visitCache[currentCity][:distance]

          # if that distance is less than the current best route to this city
          # then replace it
          if (@visitCache[neighbor.city][:distance].nil? || cityDistance < @visitCache[neighbor.city][:distance])
            @visitCache[neighbor.city][:distance] = cityDistance
            @visitCache[neighbor.city][:previous] = currentCity
          end
        end

        # Find the fringe city with the lowest total distance
        currentCity = pop_closest_from_fringe

        unless currentCity.nil?
          # Mark as visited
          @visitCache[currentCity][:visited] = true
          # Add neighbors to fringe
          currentCity.each_neighbor do |neighbor|
            fringe_candidate neighbor.city
          end
        end
      end #while have unfinished cities in the fringe

      describe_route_to_trip_info
    end

  end


  # Using the atlas graph, return a TripInfo object
  # with the initialized state
  def self.shortest_distance(atlas, fromCity, toCity)

    exploration = Exploration.new atlas, fromCity, toCity

    if exploration.trip.valid?
      exploration.plan!
    end
    exploration.trip
  end
end
