FUNCTION SampleDatabase::Init, _EXTRA=ex
  database_dir=database_dir 
  COMPILE_OPT IDL2

  ; Call our superclass Initialization method.

  
  void = self->IDL_Object::Init()
  IF (ISA(ex)) THEN self->SetProperty, _EXTRA=ex


  
  RETURN, 1

END



PRO SampleDatabase::Cleanup

  COMPILE_OPT IDL2

  ; Call our superclass Cleanup method
  Ptr_Free, self.database_obj
  Ptr_Free, self.recordset_obj
  
  self->IDL_Object::Cleanup

END

pro SampleDatabase::testc
  COMPILE_OPT IDL2
  self.ObjPhotoes::GetProperty,filed_num=filed_num
  help,filed_num
end


pro SampleDatabase::ExportTXT, $
  export_txt=export_txt
  
  COMPILE_OPT IDL2
  
  objrs = obj_new('idldbrecordset',*self.database_obj,table='photo')
  objrs ->IDLdbRecordset::GetProperty,field_info = field_info
  
  status = objrs.movecursor(/FIRST)
  IF N_Elements(objrs) NE 0 THEN self.recordset_obj = Ptr_New(objrs)
  
  
  OPENW,LUN,export_txt,/GET_LUN,WIDTH=500
  PRINTF, LUN, field_info.field_name, $
    FORMAT = '(A8,3X,A15,A15,A15,A10,A15,A15,A15,A15,A15,A-15,A0)'
  REPEAT BEGIN
    record = objrs->GetRecord()

    PRINTF, LUN, STRTRIM(record.ID,1), $
      STRTRIM(record.USERNAME,1), $
      STRTRIM(record.LON_D,1), $
      STRTRIM(record.LAT_D,1), $
      STRTRIM(record.ALT,1), $
      STRTRIM(record.DAZIMUTH,1), $
      STRTRIM(record.PDIRECTION,1), $
      STRTRIM(record.UTC_DATE,1), $
      STRTRIM(record.UTC_TIME,1), $
      STRTRIM(record.CLASS_CODE,1), $
      STRTRIM(record.CLASS_NAME,1), $
      STRTRIM(record.PHOTONAME,1), $
      FORMAT = '(A8,3X,A15,A15,A15,A10,A15,A15,A15,A15,A15,A-15,A0)'
    status = objrs->MoveCursor(/next)

  ENDREP UNTIL (status EQ 0)

  FREE_LUN,LUN
  
end

pro SampleDatabase::InsertInfoToDatabase, $
  id=id, $
  exif_stru=exif_stru, $
  job_name=job_name, $
  direction=direction, $
  name=name, $
  field_type=field_type, $
  field_code=field_code, $
  azimuth=azimuth

  compile_opt idl2
  IF (self.database_dir NE '') THEN BEGIN

    ;self.ObjPhotoes::FormatEXIF
    
    strSQL = "INSERT INTO photo VALUES"+ $
      " ("  +STRTRIM(id,1)+ $
      ",'"  +job_name+ $
      "',"  +STRTRIM(exif_stru.lon,1)+ $
      ","   +STRTRIM(exif_stru.lat,1)+ $
      ","   +STRTRIM(exif_stru.alt,1)+ $
      ","   +STRTRIM(azimuth,1)+ $
      ",'"  +direction+ $
      "','" +exif_stru.gps_date+ $
      "','" +exif_stru.gps_time+ $
      "','" +field_code+ $
      "','" +field_type+ $
      "','" +name+ $
      "')"
    oDateBase = *self.database_obj
    oDateBase.ExecuteSQL,strSQL
    PRINT,'Insert Info Successfully'
  ENDIF ELSE BEGIN
    PRINT,'Insert Info Failed'
  ENDELSE


end


pro SampleDatabase::CreatDatabase, $
  database_obj=database_obj

  COMPILE_OPT IDL2, static
  
  if file_test('C:\Users\Administrator\2018.mdb') then file_delete,'C:\Users\Administrator\2018.mdb', /ALLOW_NONEXISTENT

  IF (self.database_dir NE '') THEN BEGIN
    FILE_COPY,ObjPhotoes.root_dir+PATH_SEP()+'Database1.mdb',self.database_dir
    oDateBase = obj_new('idldbdatabase')
    oDateBase.connect,datasource='MS Access Database;dbq='+self.database_dir
    ;objrs = obj_new('idldbrecordset',oDateBase,table='photo')
    IF N_Elements(oDateBase) NE 0 THEN self.database_obj = Ptr_New(oDateBase)
    PRINT,'Create Database Successfully'
  ENDIF ELSE BEGIN
    PRINT,'Create Database Failed'
  ENDELSE

END

FUNCTION SampleDatabase::GetSampleDatabase

  ; Static method.

  ; Note: Cannot use "self" within a static method

  COMPILE_OPT IDL2, static

  obj = OBJ_VALID(COUNT=c)

  RETURN, obj[WHERE(OBJ_ISA(obj, 'SampleDatabase'), /NULL)]

END



PRO SampleDatabase::GetProperty, $
  filed_num=filed_num, $
  record_num=record_num, $
  database_dir=database_dir
  COMPILE_OPT IDL2, static

    IF (ARG_PRESENT(filed_num)) THEN filed_num = self.filed_num
    IF (ARG_PRESENT(record_num)) THEN record_num = self.record_num
    IF (ARG_PRESENT(database_dir)) THEN database_dir = self.database_dir


END



PRO SampleDatabase::SetProperty, $
  filed_num=filed_num, $
  record_num=record_num, $
  database_dir=database_dir


  COMPILE_OPT IDL2

  ; If user passed in a property, then set it.

  IF (ISA(filed_num)) THEN self.filed_num = filed_num
  IF (ISA(record_num)) THEN self.record_num = record_num
  IF (ISA(database_dir)) THEN self.database_dir = database_dir

END



PRO SampleDatabase__define

  COMPILE_OPT IDL2

  void = {SampleDatabase, $
    
    inherits IDL_Object, $ ; superclass
    ;inherits ObjPhotoes, $
    filed_num: 0, $ ; two-element array
    record_num: 0, $
    database_dir: '', $
    database_obj: Ptr_New(), $
    recordset_obj: Ptr_New()} ; scalar value

END