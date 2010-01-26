  #convert from degrees to radians
  def gps_distance(lat1, long1, lat2, long2)
    a1 = lat1 * (Math::PI / 180)
    b1 = long1 * (Math::PI / 180)
    a2 = lat2 * (Math::PI / 180)
    b2 = long2 * (Math::PI / 180)

    r_e = 6378.135 #radius of the earth in kilometers (at the equator)
    #note that the earth is not a perfect sphere, r is also as small as
    r_p = 6356.75 #km at the poles

    #find the earth's radius at the average latitude between the two locations
    theta = (lat1 + lat2) / 2

    r = Math.sqrt(((r_e**2 * Math.cos(theta))**2 + (r_p**2 * Math.cos(theta))**2) / ((r_e * Math.cos(theta))**2 + (r_p * Math.cos(theta))**2))

    #do the calculation with radians as units
    d = r * Math.acos(Math.cos(a1)*Math.cos(b1)*Math.cos(a2)*Math.cos(b2) + Math.cos(a1)*Math.sin(b1)*Math.cos(a2)*Math.sin(b2) + Math.sin(a1)*Math.sin(a2));
  end

