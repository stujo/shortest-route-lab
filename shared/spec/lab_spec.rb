require 'rspec'

describe GPSGuide do
  let(:mapOfCalifornia) { Maps.california }

  describe "can get from la to sf" do
    let(:la_to_st) { GPSGuide.shortestDistance(mapOfCalifornia, "Los Angeles", "San Francisco") }
    it "with the correct shortest distance" do
      expect(la_to_st.distance).to eq be_within(0.5).of(401.5)
    end
    it "on the shortest route" do
      expect(la_to_st.route).to eq ["Los Angeles", "Bakersfield", "San Jose", "San Francisco"]
    end
  end


  describe "can get from san diego to sf" do
    let(:sa_to_st) { GPSGuide.shortestDistance(mapOfCalifornia, "San Diego", "San Francisco") }
    it "with the correct shortest distance" do
      expect(sa_to_st.distance).to eq be_within(0.5).of(522.3)
    end
    it "on the shortest route" do
      expect(sa_to_st.route).to eq ["San Diego", "Bakersfield", "San Jose", "San Francisco"]
    end
  end

  describe "knows the shortest distance" do
    it "between san jose and sf" do
      expect(GPSGuide.shortestDistance(mapOfCalifornia, "San Jose", "San Francisco").distance).to be_within(0.5).of(47.8)
    end
    it "between bakersfield and sf" do
      expect(GPSGuide.shortestDistance(mapOfCalifornia, "Bakersfield", "San Francisco").distance).to be_within(0.5).of(289.8)
    end
    it "between bakersfield and san diego" do
      expect(GPSGuide.shortestDistance(mapOfCalifornia, "Bakersfield", "San Diego").distance).to be_within(0.5).of(232.5)
    end
    it "between bakersfield and la" do
      expect(GPSGuide.shortestDistance(mapOfCalifornia, "Bakersfield", "Los Angeles").distance).to be_within(0.5).of(111.7)
    end
    it "between fresno and san diego" do
      expect(GPSGuide.shortestDistance(mapOfCalifornia, "Fresno", "San Diego").distance).to be_within(0.5).of(340.2)
    end
  end
end
