require_relative 'atlas'

module Maps
  @@california = nil
  def self.california
    unless @@california
      @@california = Atlas.new

      sf = @@california.add_new_city 'San Francisco'
      bakersfield = @@california.add_new_city 'Bakersfield'
      la = @@california.add_new_city 'Los Angeles'
      sandiego = @@california.add_new_city 'San Diego'
      fresno = @@california.add_new_city 'Fresno'
      sacramento = @@california.add_new_city 'Sacramento'
      santa_barbara = @@california.add_new_city 'Santa Barbara'
      san_jose = @@california.add_new_city 'San Jose'

      @@california.add_neighbors(fresno, la, 219)
      @@california.add_neighbors(fresno, bakersfield, 109)
      @@california.add_neighbors(fresno, sf, 187)
      @@california.add_neighbors(fresno, sacramento, 171)
      # @@california.add_neighbors(sf, la, 380.9)
      @@california.add_neighbors(sandiego, la, 121.2)
      @@california.add_neighbors(bakersfield, la, 111.7)
      @@california.add_neighbors(bakersfield, san_jose, 242)
      @@california.add_neighbors(bakersfield, sandiego, 232.5)
      @@california.add_neighbors(bakersfield, santa_barbara, 147.7)
      @@california.add_neighbors(san_jose, santa_barbara, 279)
      @@california.add_neighbors(san_jose, sf, 47.8)

    end
    @@california
  end
end
