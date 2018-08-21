FUNCTION ObjPhotoes::Init,  _EXTRA=ex, $
    name=name, $
    photo_group=photo_group
    
  COMPILE_OPT IDL2
;  
;  catch, errorStatus            ; catch all errors and display an error dialog
;  if (errorStatus ne 0) then begin
;    catch,/cancel
;    print, !error_state.msg
;    return,0
;  endif

  ; Call our superclass Initialization method.
  
  
  void = self->SampleDatabase::Init()
  IF (ISA(ex)) THEN self->SetProperty, _EXTRA=ex

  IF N_Elements(photo_group) NE 0 THEN self.photo_group = Ptr_New(photo_group)

  RETURN, 1

END



PRO ObjPhotoes::Cleanup

  COMPILE_OPT IDL2

  ; Call our superclass Cleanup method

  self->SampleDatabase::Cleanup

END



PRO ObjPhotoes::NextPhoto

  COMPILE_OPT IDL2

  t = self.position
  IF t LT N_ELEMENTS((*self.photo_group))-1 THEN BEGIN
    t ++
    self.position = t
    print,(*self.photo_group)[self.position]
  ENDIF
END
PRO ObjPhotoes::PrePhoto

  COMPILE_OPT IDL2

  t = self.position
  IF t GT 0 THEN BEGIN
    t --
    self.position = t
    print,(*self.photo_group)[self.position]
  ENDIF
END


FUNCTION ObjPhotoes::GetPhotoes

  ; Static method.

  ; Note: Cannot use "self" within a static method

  COMPILE_OPT IDL2, static

  obj = OBJ_VALID(COUNT=c)

  RETURN, obj[WHERE(OBJ_ISA(obj, 'ObjPhotoes'), /NULL)]

END

pro ObjPhotoes::FormatEXIF, $
  name=name

  compile_opt idl2
  
  exif = read_exif(name)
  exif_stru = exif_format_out(exif)
  IF N_Elements(exif_stru) NE 0 THEN self.exif_stru = Ptr_New(exif_stru)
  
  PRINT
  HELP,*self.exif_stru
end

pro ObjPhotoes::Show

  compile_opt idl2
  PRINT,(*self.photo_group)[self.position]
  show_image,(*self.photo_group)[self.position]
  
end

pro ObjPhotoes::Test

  compile_opt idl2
  print
  print
  self->SampleDatabase::GetProperty,filed_num=filed_num
  print,filed_num
end


PRO ObjPhotoes::GetProperty, $
    name=name, $
      position=position, $
      field_type=field_type, $
      field_code=field_code, $
      photo_group=photo_group, $
      output_dir=output_dir, $
      photo_root_dir=photo_root_dir, $
      root_dir=root_dir, $
      exif_stru=exif_stru, $
      job_name=job_name, $
      direction=direction, $
      distance=distance, $
      _REF_EXTRA=extra
      
  ; This method can be called either as a static or instance.

  COMPILE_OPT IDL2, static
  
;  catch, errorStatus            ; catch all errors and display an error dialog
;  if (errorStatus ne 0) then begin
;    catch,/cancel
;    print, !error_state.msg
;    return
;  endif
  
  ; If "self" is defined, then this is an "instance".

  IF (ISA(self)) THEN BEGIN

    ; User asked for an "instance" property.
    IF Arg_Present(photo_group) && Ptr_Valid(self.photo_group) THEN photo_group = *self.photo_group
    
    IF (ARG_PRESENT(job_name)) THEN job_name = self.job_name
    IF (ARG_PRESENT(direction)) THEN direction = self.direction
    IF (ARG_PRESENT(distance)) THEN distance = self.distance
    IF (ARG_PRESENT(name)) THEN name = (*self.photo_group)[self.position]
    IF (ARG_PRESENT(position)) THEN position = self.position
    IF (ARG_PRESENT(field_type)) THEN field_type = self.field_type
    IF (ARG_PRESENT(field_code)) THEN field_code = self.field_code
    IF (ARG_PRESENT(output_dir)) THEN output_dir = self.output_dir
    IF (ARG_PRESENT(photo_root_dir)) && (ARG_PRESENT(photo_group)) && (ARG_PRESENT(position)) THEN $
      photo_root_dir = FILE_DIRNAME((*self.photo_group)[self.position])
    IF (ARG_PRESENT(root_dir)) THEN root_dir = FILE_DIRNAME(ROUTINE_FILEPATH())
    IF (ARG_PRESENT(exif_stru)) THEN exif_stru = *self.exif_stru
  endif else begin
    IF (ARG_PRESENT(root_dir)) THEN root_dir = FILE_DIRNAME(ROUTINE_FILEPATH())
    
    ; Superclass keywords.
    IF N_Elements(extra) NE 0 THEN self -> SampleDatabase::GetProperty, _Strict_Extra=extra


  ENDELSE

END



PRO ObjPhotoes::SetProperty, $
    name=name, $
      position=position, $
      field_type=field_type, $
      field_code=field_code, $
      photo_group=photo_group, $
      output_dir=output_dir, $
      photo_root_dir=photo_root_dir, $
      
      job_name=job_name, $
      direction=direction, $
      distance=distance, $
      _REF_EXTRA=extra

  COMPILE_OPT IDL2

  ; If user passed in a property, then set it.

  IF (ISA(position)) THEN self.position = position
  IF (ISA(field_type)) THEN self.field_type = field_type
  IF (ISA(field_code)) THEN self.field_code = field_code
  IF (ISA(name)) THEN self.name = name
  IF (ISA(output_dir)) THEN self.output_dir = output_dir
  IF (ISA(photo_root_dir)) THEN self.photo_root_dir = photo_root_dir
  IF (ISA(job_name)) THEN self.job_name = job_name
  IF (ISA(direction)) THEN self.direction = direction
  IF (ISA(distance)) THEN self.distance = distance
  
  IF N_Elements(photo_group) NE 0 THEN BEGIN
      IF Ptr_Valid(self.photo_group) THEN *self.photo_group = photo_group $
          ELSE self.photo_group = Ptr_New(photo_group)
  ENDIF
  
  ; Superclass keywords.
  IF N_Elements(extra) NE 0 THEN self -> SampleDatabase::GetProperty, _Strict_Extra=extra
  
  
END



PRO ObjPhotoes__define

  COMPILE_OPT IDL2

  void = {ObjPhotoes, $ ; superclass inherits IDL_Object, 
    ;inherits IDL_Object, $
    inherits SampleDatabase, $
    photo_group: Ptr_New(),$
    position: 0, $ ;
    field_type: '', $
    field_code: '', $
    name: '', $
    output_dir: '', $

    photo_root_dir: '',$ ; scalar value
    
    exif_stru: Ptr_New(), $
    job_name: '', $ ; two-element array
    direction: '', $
    distance: 0} ; scalar value}
END