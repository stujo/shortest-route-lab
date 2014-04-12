require 'rspec'

describe Atlas do
  before :all do
    @california = Maps.california
    @sf = @california.find_city_by_name "San Francisco"
    @la = @california.find_city_by_name "Los Angeles"
    @sanDiego = @california.find_city_by_name "San Diego"
    @bakersfield = @california.find_city_by_name "Bakersfield"
  end

  it "should keep track of cities like sf" do
    expect(@california.find_city_by_id @sf.id).to be @sf
  end

  it "should keep track of cities like la" do
    expect(@california.find_city_by_id @la.id).to be @la
  end

  it "should know that citya and cityb are neighbors" do
    expect(@sf.find_neighbor @la).not_to be nil
  end

  it "should know that cityb and citya are neighbors" do
    expect(@la.find_neighbor @sf).not_to be nil
  end

  it "should know that la and sandiego are neighbors" do
    expect(@sanDiego.find_neighbor @la).not_to be nil
  end

  it "should know that sf and sandiego are not neighbors" do
    expect(@sanDiego.find_neighbor @sf).to be nil
  end

  it "should know the distance between la and sf" do
    expect(@sf.neighbor_distance_to @la).to eq 380.9
  end

  it "should know the distance between la and sandiego" do
    expect(@sanDiego.neighbor_distance_to @la).to eq 121.2
  end

  it "should know the distance between bakersfield to la" do
    expect(@bakersfield.neighbor_distance_to @la).to eq 111.7
  end

  it "should know the distance between la and bakersfield" do
    expect(@la.neighbor_distance_to @bakersfield).to eq 111.7
  end

  it "should not know the distance between sf and sandiego" do
    expect(@sf.neighbor_distance_to @sanDiego).to be nil
  end
end

