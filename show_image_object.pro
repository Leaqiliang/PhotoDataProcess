;+--------------------------------------------------------------------------
;   This procedure show and congrid the photo in widget_draw.
;---------------------------------------------------------------------------
PRO show_image_object,selectedFile


  ;selectedFile = 'D:\历史数据\wp图片\从 Windows Phone\本机照片\(QQBrowser)2013721_6458_jpeg.jpg'
  exif = read_exif(selectedFile)

  IF QUERY_JPEG(selectedFile) EQ 1 THEN BEGIN

    READ_JPEG,selectedFile,data,true=1,dither=0
    erase,225

    if exif eq !null || ~exif.HasKey('Exif_Image_Orientation') then begin
      image_xsize         = (size(data, /DIMENSIONS))[-2]
      image_ysize         = (size(data, /DIMENSIONS))[-1]
      image_xsize_congrid = image_xsize*472.5/image_ysize
      image_ysize_congrid = image_ysize*630/image_xsize
      if (image_xsize ge image_ysize) then begin
        TV,CONGRID(data,3,630,image_ysize_congrid),0,(472.5-image_ysize_congrid)/2,/true
      endif else begin
        TV,CONGRID(data,3,image_xsize_congrid,472.5),(630-image_xsize_congrid)/2,0,/true
      endelse
    endif else begin
      image_xsize         = exif.Exif_Photo_PixelXDimension
      image_ysize         = exif.Exif_Photo_PixelYDimension
      congridx = image_xsize*472.5/image_ysize
      congridy = 472.5
      if exif.HasKey('Exif_Image_Orientation') then begin
        h = fix(exif.Exif_Image_Orientation)
        ;case (exif.Exif_Image_Orientation) of

        if h eq 1 then data_com = rotate_3d(data=data,direction=0,congridx=congridx,congridy=congridy)
        if h eq 2 then data_com = rotate_3d(data=data,direction=5,congridx=congridx,congridy=congridy)
        if h eq 3 then data_com = rotate_3d(data=data,direction=2,congridx=congridx,congridy=congridy)
        if h eq 4 then data_com = rotate_3d(data=data,direction=7,congridx=congridx,congridy=congridy)
        if h eq 5 then data_com = rotate_3d(data=data,direction=6,congridx=congridx,congridy=congridy)
        if h eq 6 then data_com = rotate_3d(data=data,direction=3,congridx=congridx,congridy=congridy)
        if h eq 7 then data_com = rotate_3d(data=data,direction=4,congridx=congridx,congridy=congridy)
        if h eq 8 then data_com = rotate_3d(data=data,direction=1,congridx=congridx,congridy=congridy)
      endif
      ;print,direction
      congridxn = congridx*472.5/congridy
      ;congridyn = congridy*630.0/congridx
      if size(data,/n_dimension) eq 3 then begin
        if (congridx ge congridy) then begin
          data_com = CONGRID(data_com,3,630.0,congridy)
          TV,data_com,0,(472.5-congridy)/2,/true
        endif else begin
          data_com = CONGRID(data_com,3,congridxn,472.5)
          TV,data_com,(630.0-congridxn)/2,0,/true
        endelse
      endif
      if size(data,/n_dimension) eq 2 then begin
        if (congridx ge congridy) then begin
          data_com = CONGRID(data_com,630.0,congridy)
          TV,data_com,0,(472.5-congridy)/2
        endif else begin
          data_com = CONGRID(data_com,congridxn,472.5)
          TV,data_com,(630.0-congridxn)/2,0
        endelse
      endif
    endelse
  ENDIF

END