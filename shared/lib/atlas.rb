# atlas contains an array of cities with a linked list of other cities with weighted edges (distance)

class Neighbour
  attr_reader :next_neighbor, :city, :distance

  def initialize(city, distance, next_neighbor = nil)
    @next_neighbor = next_neighbor
    @city = city
    @distance = distance
  end

  def self.push_all_to_array next_neighbor, container
    if next_neighbor
      container << next_neighbor
      push_all_to_array next_neighbor.next_neighbor, container
    end
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

  def to_s
    "To #{@city.name} #{@distance}"
  end

  def self.each_neighbor next_neighbor, block
    if next_neighbor
      block.call(next_neighbor)
      each_neighbor next_neighbor.next_neighbor, block
    end
  end
end

class City
  attr_reader :name, :id, :neighbor_linked_list
  attr_accessor :data

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

  def push_neighbors_to_array container
    Neighbour.push_all_to_array @neighbor_linked_list, container
  end

  def distanceToNeighbor city
    find_neighbor(city).distance
  end

  def each_neighbor(&block)
    Neighbour.each_neighbor @neighbor_linked_list, block
  end

  def to_s
    "#{name}"
  end

end

class Atlas
  attr_reader :cities

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

  def reset_data
    @cities.each { |city| city.data= nil }
  end

  def dump_data
    @cities.each { |city| puts "#{city.name} : #{city.data.inspect}" }
  end



end
