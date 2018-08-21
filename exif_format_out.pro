;+
; NAME:
;   exif_format_out
;
; PURPOSE:
;
;   This function create the longitude, latitude, UTC' date, UTC' time
;   and camera information form photo's Exif in a given format.
;
; INPUTS:

;   EXIF:A dictionary named EXIFMetadata.
;
; OUTPUTS:
;   
;   A Structure.
;   
; Copyright (c) 2018.08, by Li Qiliang. All rights reserved.
;

function exif_format_out,EXIF
  
  exif_stru = {lon_ref:'-', $
      lon:0.0D, $
      lat_ref:'-', $
      lat:0.0D, $
      alt:0, $
      gps_date:'-', $
      gps_time:'-', $
      image_model:'-', $
      focallength:'-', $
      iso:'-', $
      exposuretime:'-', $
      pixelx:'-', $
      pixely:'-'}
      
      
    ;产生经度
    if exif.HasKey('Exif_GPSInfo_GPSLongitudeRef') then begin
      exif_stru.lon_ref = EXIF.Exif_GPSInfo_GPSLongitudeRef
    endif
    if exif.HasKey('Exif_GPSInfo_GPSLongitude') then begin
      if stregex(EXIF.Exif_GPSInfo_GPSLongitude[0],'[0-9]',/BOOLEAN) then begin
        exif_stru.lon = strcompress(STRING((DOUBLE(EXIF.Exif_GPSInfo_GPSLongitude[0])+DOUBLE(EXIF.Exif_GPSInfo_GPSLongitude[1])/60+DOUBLE(EXIF.Exif_GPSInfo_GPSLongitude[2])/3600),format='(f0)'),/remove_all)
      endif
    endif


    ;产生纬度
    if exif.HasKey('Exif_GPSInfo_GPSLatitudeRef') then begin
      exif_stru.lat_ref = EXIF.Exif_GPSInfo_GPSLatitudeRef
    endif
    if exif.HasKey('Exif_GPSInfo_GPSLatitude') then begin
      if stregex(EXIF.Exif_GPSInfo_GPSLatitude[0],'[0-9]',/BOOLEAN) then begin
        exif_stru.lat = strcompress(STRING(DOUBLE(EXIF.Exif_GPSInfo_GPSLatitude[0])+DOUBLE(EXIF.Exif_GPSInfo_GPSLatitude[1])/60+ DOUBLE(EXIF.Exif_GPSInfo_GPSLatitude[2])/3600),/remove_all)
      endif
    endif

    ;产生高度
    if exif.HasKey('Exif_GPSInfo_GPSAltitude')  then begin
      exif_stru.alt = strcompress(FIX(EXIF.Exif_GPSInfo_GPSAltitude),/remove_all)
    endif

    ;产生日期时间
    if exif.HasKey('Exif_GPSInfo_GPSDateStamp') && exif.HasKey('Exif_GPSInfo_GPSTimeStamp') && stregex(EXIF.Exif_GPSInfo_GPSDateStamp,'[0-9]',/BOOLEAN) then begin
      year         = STRMID(EXIF.Exif_GPSInfo_GPSDateStamp,0,4)
      month        = STRMID(EXIF.Exif_GPSInfo_GPSDateStamp,5,2)
      day          = STRMID(EXIF.Exif_GPSInfo_GPSDateStamp,8,2)
      hour         = STRING(strcompress(FIX(EXIF.Exif_GPSInfo_GPSTimeStamp[0]),/remove_all),format='(I02)')
      minute       = STRING(strcompress(FIX(EXIF.Exif_GPSInfo_GPSTimeStamp[1]),/remove_all),format='(I02)')
      second       = STRING(strcompress(FIX(EXIF.Exif_GPSInfo_GPSTimeStamp[2]),/remove_all),format='(I02)')
      exif_stru.gps_date = year+month+day
      exif_stru.gps_time = hour+minute+second
    endif

    ;生成camera信息
    if exif.HasKey('Exif_Image_Model')  then begin
      exif_stru.Image_Model = EXIF.Exif_Image_Model
    endif
    if exif.HasKey('Exif_Image_FocalLength')  then begin
      exif_stru.FocalLength = strcompress(FIX(EXIF.Exif_Image_FocalLength),/remove_all)
    endif
    if exif.HasKey('Exif_Image_ISOSpeedRatings')  then begin
      exif_stru.ISO = strcompress(EXIF.Exif_Image_ISOSpeedRatings, /REMOVE_ALL)
    endif

    if exif.HasKey('Exif_Image_ExposureTime')  then begin
      exif_stru.ExposureTime = strcompress(string(EXIF.Exif_Image_ExposureTime*1000,format='(f0.2)'),/remove_all)
    endif
    if exif.HasKey('Exif_Photo_PixelXDimension') && exif.HasKey('Exif_Photo_PixelYDimension') then begin
      exif_stru.PixelX = strcompress(EXIF.Exif_Photo_PixelXDimension, /REMOVE_ALL)
      exif_stru.PixelY = strcompress(EXIF.Exif_Photo_PixelYDimension, /REMOVE_ALL)
    endif
  
  ;help,exif_stru
  return,exif_stru
  
END