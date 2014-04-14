# GPSGuide: Service to navigate Atlas objects
class GPSGuide
  # A instance of a shortest path search
  # Stores current fringe and visitation data
  class Exploration
    attr_reader :trip

    def initialize(atlas, from_city, to_city)
      @trip = TripInfo.new(atlas.find_city_by_name(from_city),
                           atlas.find_city_by_name(to_city))
    end

    def valid?
      @trip.valid?
    end

    def fringe_candidate(city)
      if !@cache.key? city
        @cache[city] = { visited: false, distance: nil }
        @fringe << city
      elsif @cache[city][:visited] == false
        @fringe << city
      end
    end

    # Find the best closest city in the fringe and
    # pop out for our next iteration
    def pop_closest_from_fringe
      next_city = nil
      @fringe.each do |city|
        if next_city.nil? ||
            @cache[city][:distance] < @cache[next_city][:distance]
          next_city = city
        end
      end
      @fringe.delete(next_city) unless next_city.nil?
      next_city
    end

    def describe_route_to_trip_info
      if @cache[trip.to_city][:visited]
        route = []
        cursor = trip.to_city
        while cursor
          route << cursor.name
          cursor = @cache[cursor][:previous]
        end
        route.reverse!
        @trip.setRoute(@cache[trip.to_city][:distance], route)
      end
    end

    def update_neighbor_distances(current_city)
      # Update the distances on the fringe and pick the closest neighbor
      current_city.each_neighbor do |neighbor|

        # Calc distance from current_city to city
        city_dist = neighbor.distance + @cache[current_city][:distance]

        # if that distance is less than the current best route to this city
        # then replace it
        if @cache[neighbor.city][:distance].nil? ||
            city_dist < @cache[neighbor.city][:distance]
          @cache[neighbor.city][:distance] = city_dist
          @cache[neighbor.city][:previous] = current_city
        end
      end
    end

    def init_plan
      @cache = {}
      @fringe = Set.new
      current_city = @trip.from_city
      @cache[current_city] = { visited: true, previous: nil, distance: 0 }

      # Initialize an empty fringe set
      # Add the neighbors of the starting city to the fringe
      add_neighbors_to_fringe current_city
      current_city
    end

    def add_neighbors_to_fringe(city)
      city.each_neighbor do |neighbor|
        fringe_candidate neighbor.city
      end
    end

    def plan!
      current_city = init_plan

      # While We have things in the fringe keep looking
      until @fringe.empty?

        update_neighbor_distances current_city

        # Find the fringe city with the lowest total distance
        current_city = pop_closest_from_fringe

        unless current_city.nil?
          # Mark as visited
          @cache[current_city][:visited] = true
          # Add neighbors to fringe
          add_neighbors_to_fringe current_city
        end
      end # while have unfinished cities in the fringe

      describe_route_to_trip_info
    end
  end

  # Using the atlas graph, return a TripInfo object
  # with the initialized state
  def self.shortest_distance(atlas, from_city, to_city)
    exploration = Exploration.new atlas, from_city, to_city

    exploration.plan! if exploration.trip.valid?

    exploration.trip
  end
end
