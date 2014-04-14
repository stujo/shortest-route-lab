class GPSGuide


  # Check that this city hasn't been visited and if not,
  # set up the data we use and add it to the set
  def self.fringe_candidate city, fringe
    if city.data == nil
      city.data = {visited: false, distance: nil}
      fringe << city
    elsif city.data[:visited] == false
      fringe << city
    end
  end

  # Find the best closest city in the fringe and pop out for our next iteration
  def self.pop_closest_from_fringe fringe
    closestUnvisitedCity = nil
    fringe.each do |city|
      if closestUnvisitedCity.nil? || city.data[:distance] < closestUnvisitedCity.data[:distance]
        closestUnvisitedCity = city
      end
    end
    fringe.delete(closestUnvisitedCity) unless closestUnvisitedCity.nil?
    closestUnvisitedCity
  end

  def self.describe_route_to_trip_info trip
    if trip.to_city.data[:visited]
      route = []
      cursor = trip.to_city
      while cursor
        route << cursor.name
        cursor = cursor.data[:previous]
      end
      route.reverse!
      trip.setRoute(trip.to_city.data[:distance], route)
    end
  end


  # Using the atlas graph, return a TripInfo object
  # with the initialized state
  def self.shortestDistance(atlas, fromCity, toCity)

    trip = TripInfo.new(atlas.find_city_by_name(fromCity), atlas.find_city_by_name(toCity))

    if trip.valid?

      visitCache = {}

      currentCity = trip.from_city
      currentCity.data= {visited: true, previous: nil, distance: 0}

      # Initialize an empty fringe set
      # Add the neighbors of the starting city to the fringe
      fringe = Set.new
      currentCity.each_neighbor do |neighbor|
        fringe_candidate neighbor.city, fringe
      end

      # While We have things in the fringe keep looking
      while !fringe.empty?

        #Update the distances on the fringe and pick the closest neighbor
        currentCity.each_neighbor do |neighbor|

          # Calc distance from currentCity to city
          cityDistance = neighbor.distance + currentCity.data[:distance]

          # if that distance is less than the current best route to this city
          # then replace it
          if (neighbor.city.data[:distance].nil? || cityDistance < neighbor.city.data[:distance])
            neighbor.city.data[:distance] = cityDistance
            neighbor.city.data[:previous] = currentCity
            #puts "Setting best so far for #{neighbor.city.name} to #{neighbor.city.data[:distance]} via #{neighbor.city.data[:previous].name} "
          end
        end

        # Find the fringe city with the lowest total distance
        currentCity = pop_closest_from_fringe fringe

        unless currentCity.nil?
          # Mark as visited
          currentCity.data[:visited] = true
          # Add neighbors to fringe
          currentCity.each_neighbor do |neighbor|
            fringe_candidate neighbor.city, fringe
          end
        end
      end #while have unfinished cities in the fringe

      describe_route_to_trip_info trip

      #clear our data from the atlas
      atlas.reset_data
    end
    trip
  end
end
