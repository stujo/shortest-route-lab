# Element in a linked list of cities with weighted edges

class Atlas
  def initialize
    @cities = []
  end

  def add_new_city(name)
    city = City.new(@cities.length, name)
    @cities << city
    city
  end

  def find_city_by_id(city_id)
    @cities[city_id]
  end

  class Neighbour
    attr_reader :next_neighbour, :city, :distance
    def initialize(city, distance, next_neighbour = nil)
      @next_neighbour = next_neighbour
      @city = city
      @distance = distance
    end
  end

  class City
    attr_reader :name, :id, :neighbour_linked_list

    def initialize(id, name)
      @id = id
      @name = name
      @neighbour_linked_list = nil
    end

    def add_neighbor(city, distance)
      @neighbour_linked_list = Atlas::Neighbour.new(city, distance, @neighbour_linked_list)
    end
  end

end
