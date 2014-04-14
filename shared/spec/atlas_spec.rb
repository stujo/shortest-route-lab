require 'rspec'

describe Atlas do
  before :all do
    @california = Maps.california
    @sf = @california.find_city_by_name 'San Francisco'
    @la = @california.find_city_by_name 'Los Angeles'
    @sanDiego = @california.find_city_by_name 'San Diego'
    @bakersfield = @california.find_city_by_name 'Bakersfield'
  end
  describe 'keeps track of cities' do
    it 'like sf' do
      expect(@california.find_city_by_id @sf.id).to be @sf
    end

    it 'like la' do
      expect(@california.find_city_by_id @la.id).to be @la
    end
  end

  describe 'keeps track of neighbors' do
    it 'that la and sandiego are neighbors' do
      expect(@sanDiego.find_neighbor @la).not_to be nil
    end

    it 'that sandiego and la are neighbors' do
      expect(@la.find_neighbor @sanDiego).not_to be nil
    end

    it 'that sf and sandiego are not neighbors' do
      expect(@sanDiego.find_neighbor @sf).to be nil
    end
  end

  describe 'knows the distance' do

    it 'between la and sandiego' do
      expect(@sanDiego.neighbor_distance_to @la).to eq 121.2
    end

    it 'between bakersfield to la' do
      expect(@bakersfield.neighbor_distance_to @la).to eq 111.7
    end

    it 'between la and bakersfield' do
      expect(@la.neighbor_distance_to @bakersfield).to eq 111.7
    end

    it 'between sf and sandiego in undefined' do
      expect(@sf.neighbor_distance_to @sanDiego).to be nil
    end
  end
end
