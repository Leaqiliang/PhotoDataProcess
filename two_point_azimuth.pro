function two_point_azimuth,lon=lon,lat=lat,gps_time=gps_time,interval=interval


    second = fix(strmid(gps_time[1],0,2))*3600+fix(strmid(gps_time[1],2,2))*60+fix(strmid(gps_time[1],4,2))
    first  = fix(strmid(gps_time[0],0,2))*3600+fix(strmid(gps_time[0],2,2))*60+fix(strmid(gps_time[0],4,2))
    IF second-first LE interval*60 THEN BEGIN
      lon_diff = double(lon[1])-double(lon[0])
      lat_diff = double(lat[1])-double(lat[0])
      theta = ATAN(lon_diff,lat_diff)
      Dazimuth = strtrim(STRING(theta * 180 / !pi,format='(f8.3)'),1)
    ENDIF ELSE BEGIN
      Dazimuth = 0
    ENDELSE
    
    RETURN,Dazimuth
    
END
