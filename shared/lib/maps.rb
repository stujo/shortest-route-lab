require_relative 'atlas'

module California
  @@california = Atlas.new
  @@sf = @@california.add_new_city "San Francisco"
  @@bakersfield = @@california.add_new_city "Bakersfield"
  @@la = @@california.add_new_city "Los Angeles"
  @@sandiego = @@california.add_new_city "San Diego"
  @@california.add_neighbors(@@sf, @@la, 380.9)
  @@california.add_neighbors(@@sandiego, @@la, 121.2)
  @@california.add_neighbors(@@bakersfield,@@la,111.7)
  @@california.add_neighbors(@@bakersfield,@@sf,282.8)
  @@california.add_neighbors(@@bakersfield,@@sandiego,232.5)
end