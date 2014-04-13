class GPSGuide

  def self.shortestDistance(atlas, fromCity, toCity)

    trip = TripInfo.new( atlas.find_city_by_name(fromCity), atlas.find_city_by_name(toCity))

    if trip.valid?
      # Set up the data
      atlas.cities.each do |city|
        city.data = {visited: false, previous: nil, distance: nil}
      end

      currentCity = trip.from_city
      currentCity.data= {visited: true, previous: nil, distance: 0}

      # Initialize an empty fringe set
      # Add the neighbors of the starting city to the fringe
      fringe = Set.new
      currentCity.each_neighbor do |neighbor|
        fringe << neighbor.city
      end

      # While We have things in the fringe keep looking
      while !fringe.empty?

        #Update the distances on the fringe and pick the closest neighbor
        currentCity.each_neighbor do |neighbor|

          # Calc distance from currentCity to city
          cityDistance = neighbor.distance + currentCity.data[:distance]

          if (neighbor.city.data[:distance].nil? || cityDistance < neighbor.city.data[:distance])
            neighbor.city.data[:distance] = cityDistance
            neighbor.city.data[:previous] = currentCity
            #puts "Setting best so far for #{neighbor.city.name} to #{neighbor.city.data[:distance]} via #{neighbor.city.data[:previous].name} "
          end
        end

        # Find the next fringe city with the lowest distance
        closestUnvisitedCity = nil
        fringe.each do |city|
          unless city.data[:visited]
            if closestUnvisitedCity.nil? || city.data[:distance] < closestUnvisitedCity.data[:distance]
              closestUnvisitedCity = city
            end
          end
        end

        #Take Best Neighbor out of the fringe and repeat
        unless closestUnvisitedCity.nil?
          fringe.delete(closestUnvisitedCity)
          closestUnvisitedCity.data[:visited] = true
          closestUnvisitedCity.each_neighbor do |neighbor|
            fringe << neighbor.city unless neighbor.city.data[:visited]
          end
          currentCity = closestUnvisitedCity
        end
      end #while have unfinished cities in the fringe

      if trip.to_city.data[:visited]
        route = []
        cursor = trip.to_city
        while cursor
          route << cursor.name
          cursor = cursor.data[:previous]
        end
        route.reverse!
        trip.setRoute(trip.to_city.data[:distance],  route)
      end

      atlas.reset_data
    end
    trip
  end
end
