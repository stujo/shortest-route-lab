# atlas contains an array of cities with a linked list of other cities with weighted edges (distance)

class Neighbour
  attr_reader :next_neighbor, :city, :distance

  def initialize(city, distance, next_neighbor = nil)
    @next_neighbor = next_neighbor
    @city = city
    @distance = distance
  end

  def self.includes? next_neighbor, city
    if next_neighbor && city
      if next_neighbor.city.id == city.id
        next_neighbor
      else
        self.includes? next_neighbor.next_neighbor, city
      end
    else
      nil
    end
  end

end

class City
  attr_reader :name, :id, :neighbor_linked_list, :data

  def initialize(id, name)
    @id = id
    @name = name
    @neighbor_linked_list = nil
    @data = nil
  end

  def add_neighbor(city, distance)
    @neighbor_linked_list = Neighbour.new(city, distance, @neighbor_linked_list)
  end

  def find_neighbor city
    Neighbour.includes? @neighbor_linked_list, city
  end

  def neighbor_distance_to city
    neighbor = find_neighbor city
    neighbor.distance unless neighbor.nil?
  end

end

class Atlas
  def initialize
    @cities = []
    @index = {}
  end

  def add_new_city(name)
    city = City.new(@cities.length, name)
    @cities << city
    @index[name] = city
    city
  end

  def find_city_by_name(name)
    @index[name]
  end

  def find_city_by_id(city_id)
    @cities[city_id]
  end

  def add_neighbors(citya, cityb, distance)
    citya.add_neighbor(cityb, distance)
    cityb.add_neighbor(citya, distance)
  end



end
