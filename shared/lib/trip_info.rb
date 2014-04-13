class TripInfo
  attr_reader :from_city, :to_city, :distance, :route
  def initialize(from_city, to_city)
    @from_city = from_city
    @to_city = to_city
  end

  def valid?
    @from_city && @to_city
  end

  def setRoute(distance,  route)
    @distance = distance
    @route = route
  end
end
