unit RawFBUtils;

interface

uses System.SysUtils, WinAPI.Windows, System.Win.Registry;

type
{$Z4}
  TGenericStatementType = (stSelect, // select                 SELECT
    stInsert, // insert                 INSERT INTO
    stUpdate, // update                 UPDATE
    stDelete, // delete                 DELETE FROM
    stDDL, //
    stGetSegment, // blob                   READ BLOB
    stPutSegment, // blob                   INSERT BLOB
    stExecProcedure, // invoke_procedure       EXECUTE PROCEDURE
    stStartTrans, // declare                DECLARE
    stCommit, // commit                 COMMIT
    stRollback, // rollback               ROLLBACK [WORK]
    stSelectForUpdate, // SELECT ... FOR UPDATE
    stSetGenerator, stSavePoint,
    stNone // user_savepoint | undo_savepoint       SAVEPOINT | ROLLBACK [WORK] T
    );

type
  TGenericFieldType = (ftUnknown, ftString, ftSmallint, ftInteger, ftWord, // 0..4
    ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime, // 5..11
    ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo, // 12..18
    ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar, ftWideString, // 19..24
    ftLargeint, ftADT, ftArray, ftReference, ftDataSet, ftOraBlob, ftOraClob, // 25..31
    ftVariant, ftInterface, ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd, // 32..37
    ftFixedWideChar, ftWideMemo, ftOraTimeStamp, ftOraInterval, // 38..41
    ftLongWord, ftShortint, ftByte, ftExtended, ftConnection, ftParams, ftStream, // 42..48
    ftTimeStampOffset, ftObject, ftSingle); // 49..51

type
  TCharacterSet = (csNONE, csASCII, csBIG_5, csCYRL, csDOS437, csDOS850,
  csDOS852, csDOS857, csDOS860, csDOS861, csDOS863, csDOS865, csEUCJ_0208,
  csGB_2312, csISO8859_1, csISO8859_2, csKSC_5601, csNEXT, csOCTETS, csSJIS_0208,
  csUNICODE_FSS, csUTF8, csWIN1250, csWIN1251, csWIN1252, csWIN1253, csWIN1254
  ,csDOS737, csDOS775, csDOS858, csDOS862, csDOS864, csDOS866, csDOS869, csWIN1255,
  csWIN1256, csWIN1257, csISO8859_3, csISO8859_4, csISO8859_5, csISO8859_6, csISO8859_7,
  csISO8859_8, csISO8859_9, csISO8859_13, csKOI8R, csKOI8U, csWIN1258, csTIS620, csGBK, csCP943C
  );

const
  DateOffset = 15018;
  TimeCoeff = 864000000;

  ScaleDivisor: array[-15..-1] of Int64 = (1000000000000000,100000000000000,
    10000000000000,1000000000000,100000000000,10000000000,1000000000,100000000,
    10000000,1000000,100000,10000,1000,100,10);

  ScaleFormat: array[-15..-1] of string = (
    '0.0##############', '0.0#############', '0.0############', '0.0###########',
    '0.0##########', '0.0#########', '0.0########', '0.0#######', '0.0######',
    '0.0#####', '0.0####', '0.0###', '0.0##', '0.0#', '0.0');

  CurrencyDivisor: array[-15..-1] of int64 = (100000000000,10000000000,
    1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,10,100,
    1000);

  isc_dpb_version1 = 1;
  isc_dpb_user_name = 28;
  isc_dpb_password = 29;
  isc_info_sql_stmt_type = 21;

  MaxParamLength = 125;

  SQL_TEXT = 452; // Array of char
  SQL_VARYING = 448;
  SQL_SHORT = 500;
  SQL_LONG = 496;
  SQL_FLOAT = 482;
  SQL_DOUBLE = 480;
  SQL_D_FLOAT = 530;
  SQL_TIMESTAMP = 510;
  SQL_BLOB = 520;
  SQL_ARRAY = 540;
  SQL_QUAD = 550;
  SQL_TYPE_TIME = 560;
  SQL_TYPE_DATE = 570;
  SQL_INT64 = 580;
  SQL_BOOLEAN = 32764;
  SQL_NULL = 32766;
  SQL_DATE = SQL_TIMESTAMP;

  METADATALENGTH = 32;

  isc_info_blob_num_segments = #4;
  isc_info_blob_max_segment = #5;
  isc_info_blob_total_length = #6;
  isc_info_blob_type = #7;
  isc_segment = 335544366;
  isc_segstr_eof = 335544367;

  DSQL_close = 1;
  DSQL_drop = 2;
  DSQL_cancel = 4;

  isc_spb_version1                                = 1;
  isc_spb_current_version                         = 2;
  isc_spb_version		                              = isc_spb_current_version;
  isc_spb_user_name_mapped_to_server              = isc_dpb_user_name;
  isc_spb_password_mapped_to_server               = isc_dpb_password;
  isc_spb_command_line_mapped_to_server           = 105;
  isc_spb_dbname_mapped_to_server                 = 106;
  isc_spb_verbose_mapped_to_server                = 107;
  isc_spb_options_mapped_to_server                = 108;
  isc_spb_user_dbname_mapped_tp_server            = 109;

  isc_info_svc_line = #62;

  isc_action_svc_backup = #1;
  isc_action_svc_restore = #2;

  isc_spb_bkp_file = #5;
  isc_spb_bkp_factor = #6;
  isc_spb_bkp_length = #7;

  isc_spb_dbname = AnsiChar(#106);
  isc_spb_verbose = AnsiChar(#107);


  //flags para backup
  isc_spb_bkp_ignore_checksums = $01;
  isc_spb_bkp_ignore_limbo = $02;
  isc_spb_bkp_metadata_only = $04;
  isc_spb_bkp_no_garbage_collect = $08;
  isc_spb_bkp_old_descriptions = $10;
  isc_spb_bkp_non_transportable = $20;
  isc_spb_bkp_convert = $40;
  isc_spb_bkp_expand = $80;
  isc_spb_bkp_no_triggers = $8000;

type
  EFBError = class(Exception);

const
  CharacterSetCP: array[TCharacterSet] of Word =
  (
  0, //csNONE,
  20127, //csASCII,
  950, //csBIG_5,
  1251, // csCYRL,
  437, // csDOS437, IBM437	OEM United States
  850, // csDOS850, ibm850	OEM Multilingual Latin 1; Western European (DOS)
  852, // csDOS852,
  857, // csDOS857,
  860, // csDOS860,
  861, // csDOS861,
  863, // csDOS863,
  865, // csDOS865,
  20932, // csEUCJ_0208, EUC-JP Japanese (JIS 0208-1990 and 0121-1990)
  936, //csGB_2312 gb2312	ANSI/OEM Simplified Chinese (PRC, Singapore); Chinese Simplified (GB2312)
  28591, //csISO8859_1, iso-8859-1	ISO 8859-1 Latin 1; Western European (ISO)
  28592, // csISO8859_2, iso-8859-2	ISO 8859-2 Central European; Central European (ISO)
  949, // csKSC_5601 ks_c_5601-1987	ANSI/OEM Korean (Unified Hangul Code)
  0, //csNEXT,
  0, //csOCTETS,
  932, //csSJIS_0208, shift_jis	ANSI/OEM Japanese; Japanese (Shift-JIS)
  65001, //csUNICODE_FSS utf-8	Unicode (UTF-8)
  65001, // csUTF8 utf-8	Unicode (UTF-8)
  1250, //csWIN1250, windows-1250	ANSI Central European; Central European (Windows)
  1251, //csWIN1251,windows-1251	ANSI Cyrillic; Cyrillic (Windows)
  1252, //csWIN1252, windows-1252	ANSI Latin 1; Western European (Windows)
  1253, //csWIN1253, windows-1253	ANSI Greek; Greek (Windows)
  1254, // csWIN1254 windows-1254	ANSI Turkish; Turkish (Windows)
  737, //csDOS737, ibm737	OEM Greek (formerly 437G); Greek (DOS)
  775, // csDOS775, ibm775	OEM Baltic; Baltic (DOS)
  858, //csDOS858, IBM00858	OEM Multilingual Latin 1 + Euro symbol
  862, // csDOS862, DOS-862	OEM Hebrew; Hebrew (DOS)
  864, //csDOS864, IBM864	OEM Arabic; Arabic (864)
  866, // csDOS866, cp866	OEM Russian; Cyrillic (DOS)
  869, //csDOS869, 	ibm869	OEM Modern Greek; Greek, Modern (DOS)
  1255, //csWIN1255, 	windows-1255	ANSI Hebrew; Hebrew (Windows)
  1256, //csWIN1256, 	windows-1256	ANSI Arabic; Arabic (Windows)
  1257, // csWIN1257, windows-1257	ANSI Baltic; Baltic (Windows)
  28593, //csISO8859_3, iso-8859-3	ISO 8859-3 Latin 3
  28594, //csISO8859_4, iso-8859-4	ISO 8859-4 Baltic
  28595, //csISO8859_5, 	iso-8859-5	ISO 8859-5 Cyrillic
  28596, //csISO8859_6, iso-8859-6	ISO 8859-6 Arabic
  28597, //csISO8859_7, 	iso-8859-7	ISO 8859-7 Greek
  28598, //csISO8859_8, 	iso-8859-8	ISO 8859-8 Hebrew; Hebrew (ISO-Visual)
  28599, //csISO8859_9, 	iso-8859-9	ISO 8859-9 Turkish
  28603, //csISO8859_13 iso-8859-13	ISO 8859-13 Estonian
  20866, // csKOI8R koi8-r	Russian (KOI8-R); Cyrillic (KOI8-R)
  21866, //csKOI8U koi8-u	Ukrainian (KOI8-U); Cyrillic (KOI8-U)
  1258, //csWIN1258 ANSI/OEM Vietnamese; Vietnamese (Windows)
  874, //csTIS620 windows-874	ANSI/OEM Thai (same as 28605, ISO 8859-15); Thai (Windows)
  936, //gb2312	ANSI/OEM Simplified Chinese (PRC, Singapore); Chinese Simplified (GB2312)
  932 //csCP943C Shift_JIS
  );

  BytesPerCharacter: array[TCharacterSet] of Byte =
  (
    1, // NONE
    1, // ASCII
    2, // BIG_5
    1, // CYRL
    1, // DOS437
    1, // DOS850
    1, // DOS852
    1, // DOS857
    1, // DOS860
    1, // DOS861
    1, // DOS863
    1, // DOS865
    2, // EUCJ_0208
    2, // GB_2312
    1, // ISO8859_1
    1, // ISO8859_2
    2, // KSC_5601
    1, // NEXT
    1, // OCTETS
    2, // SJIS_0208
    3, // UNICODE_FSS
    4,  // UTF8
    1, // WIN1250
    1, // WIN1251
    1, // WIN1252
    1, // WIN1253
    1,  // WIN1254
    1,  // DOS737'
    1,  // DOS775
    1,  // DOS858
    1,  // DOS862
    1,  // DOS864
    1,  // DOS866
    1,  // DOS869
    1,  // WIN1255
    1,  // WIN1256
    1,  // WIN1257
    1,  // ISO8859_3
    1,  // ISO8859_4
    1,  // ISO8859_5
    1,  // ISO8859_6
    1,  // ISO8859_7
    1,  // ISO8859_8
    1,  // ISO8859_9
    1,  // ISO8859_13
    1,  // KOI8R
    1,  // KOI8U
    1,  // WIN1258
    1,  // TIS620
    2,  // GBK
    2   // CP943C
  );

type


  PVary = ^TVary;
  vary = record
    vary_length: USHORT;
    vary_string: array [0..0] of AnsiChar;
  end;
  TVary = vary;

  PGDSQuad = ^TGDSQuad;
  GDS_QUAD = record
    gds_quad_high: Integer;
    gds_quad_low: ULONG;
  end;
  TGDSQuad = GDS_QUAD;

  PtrInt = LongInt;
  Short = SmallInt; // 16 bit signed
  PShort = ^Short;
  PVoid = ^Pointer;
  ISC_LONG = Longint;
  ISC_STATUS = ISC_LONG;
  PISC_STATUS = ^ISC_STATUS;
  PPISC_STATUS = ^PISC_STATUS;
  TISC_DB_HANDLE = PVoid;
  PISC_DB_HANDLE = ^TISC_DB_HANDLE;
  ISC_STATUS_VECTOR = array [0 .. 19] of ISC_STATUS;
  TISC_TR_HANDLE = PVoid;
  PISC_TR_HANDLE = ^TISC_TR_HANDLE;
  TISC_SVC_HANDLE = IntPtr;
  PISC_SVC_HANDLE = IntPtr;

  ISCLong = ISC_LONG;
  PISCLong = ^ISCLong;

  ISC_USHORT =  Word;
  ISCUShort = ISC_USHORT;
  PISCUShort = ^ISCUShort;

  isc_blob_handle = PPointer;
  TISC_BLOB_HANDLE = isc_blob_handle;
  PISC_BLOB_HANDLE = ^TISC_BLOB_HANDLE;

  isc_svc_handle = PPointer;
  IscSvcHandle = isc_svc_handle;
  PIscSvcHandle = ^IscSvcHandle;

  isc_resv_handle = ISC_LONG;
  IscResvHandle = isc_resv_handle;
  PIscResvHandle = ^IscResvHandle;

  ISC_QUAD = GDS_QUAD;
  TISCQuad = ISC_QUAD;
  PISCQuad = ^TISCQuad;

//  TISC_QUAD            = Int64;
//  PISC_QUAD            = IntPtr;

  PISC_BLOB_DESC       = IntPtr;
  PISC_BLOB_DESC_V2    = IntPtr;

  PISCArrayBound = ^TISCArrayBound;
  ISC_ARRAY_BOUND = record
    array_bound_lower: Smallint;
    array_bound_upper: Smallint;
  end;
  TISCArrayBound = ISC_ARRAY_BOUND;

  PISCArrayDesc = ^TISCArrayDesc;
  ISC_ARRAY_DESC = record
    array_desc_dtype: byte;
    array_desc_scale: byte;
    array_desc_length: Word;
    array_desc_field_name: array [0..METADATALENGTH - 1] of AnsiChar;
    array_desc_relation_name: array [0..METADATALENGTH - 1] of AnsiChar;
    array_desc_dimensions: Smallint;
    array_desc_flags: Smallint;
    array_desc_bounds: array [0..15] of TISCArrayBound;
  end;
  TISCArrayDesc = type ISC_ARRAY_DESC;

  PISCBlobDesc = ^TISCBlobDesc;
  ISC_BLOB_DESC = record
    blob_desc_subtype: Smallint;
    blob_desc_charset: Smallint;
    blob_desc_segment_size: Smallint;
    blob_desc_field_name: array [0..METADATALENGTH - 1] of AnsiChar;
    blob_desc_relation_name: array [0..METADATALENGTH - 1] of AnsiChar;
  end;
  TISCBlobDesc = ISC_BLOB_DESC;

  PBlobData = ^TBlobData;
  TBlobData = packed record
    Size: Integer;
    Buffer: Pointer;
  end;

  PArrayDesc = ^TArrayDesc;
  TArrayDesc = TISCArrayDesc;
  TBlobDesc = TISCBlobDesc;

  PArrayInfo = ^TArrayInfo;
  TArrayInfo = record
    index: Integer;
    size: integer;
    info: TArrayDesc;
  end;

  TISC_TEB = record
    Handle: PISC_DB_HANDLE;
    Len: Longint;
    Address: PAnsiChar;
  end;

  PISC_TEB = ^TISC_TEB;

  TISC_STMT_HANDLE = PVoid;
  PISC_STMT_HANDLE = ^TISC_STMT_HANDLE;

  (* ****************************** *)
  (* * Declare the extended SQLDA * *)
  (* ****************************** *)
  TFBParamsFlag = (pfNotInitialized, pfNotNullable);
  TFBParamsFlags = set of TFBParamsFlag;

  TXSQLVAR = record // size must be 152
    SqlType      : Smallint;
    SqlScale     : Smallint;
    SqlSubType   : Smallint;
    SqlLen       : Smallint;
    SqlData      : PAnsiChar;
    SqlInd       : PSmallint;
    case byte of
    // TSQLResult
    0 : ( SqlNameLength   : Smallint;
          SqlName         : array[0..METADATALENGTH-1] of AnsiChar;
          RelNameLength   : Smallint;
          RelName         : array[0..METADATALENGTH-1] of AnsiChar;
          OwnNameLength   : Smallint;
          OwnName         : array[0..METADATALENGTH-1] of AnsiChar;
          AliasNameLength : Smallint;
          AliasName       : array[0..METADATALENGTH-1] of AnsiChar;
          );
    // TSQLParam
    1 : ( Flags           : TFBParamsFlags;
          ID              : Word;
          MaxSqlLen       : Smallint;
          ParamNameLength : Smallint;
          ParamName       : array[0..MaxParamLength-1] of AnsiChar;
          );
  end;
  PXSQLVAR = ^TXSQLVAR;

  TXSQLDA = record
    version : Smallint;                // version of this XSQLDA
    sqldaid : array[0..7] of AnsiChar; // XSQLDA name field          ->  RESERVED
    sqldabc : LongInt;                 // length in bytes of SQLDA   ->  RESERVED
    sqln    : Smallint;                // number of fields allocated
    sqld    : Smallint;                // actual number of fields
    sqlvar: array[0..0] of TXSQLVar;         // first field address
  end; // TXSQLDA

  PXSQLDA = ^TXSQLDA;

  ISC_DATE = type Longint;
  ISCDate = ISC_DATE;
  PISCDate = ^ISCDate;

  ISC_TIME = type Cardinal;
  ISCTime = ISC_TIME;
  PISCTime = ^ISCTime;

  PISCTimeStamp = ^TISCTimeStamp;
  ISC_TIMESTAMP = record
    timestamp_date: ISC_DATE;
    timestamp_time: ISC_TIME;
  end;
  TISCTimeStamp = ISC_TIMESTAMP;

  TISC_CALLBACK = procedure;
type
  TBlobInfo = packed record
    Info: AnsiChar;
    Length: Word;
    case byte of
      0: (CardType: Integer);
      1: (ByteType: Byte);
  end;

  ISC_EVENT_CALLBACK = procedure(user_data: Pointer; length: ISC_USHORT; const updated: PAnsiChar); stdcall;

  Tisc_attach_database = function(status_vector: PISC_STATUS; db_name_length: Short; db_name: PAnsiChar;
    db_handle: PISC_DB_HANDLE; parm_buffer_length: Short; parm_buffer: PAnsiChar): ISC_STATUS; stdcall;

  Tisc_detach_database = function(status_vector: PISC_STATUS; db_handle: PISC_DB_HANDLE): ISC_STATUS; stdcall;

  Tisc_interprete = function(buffer: PAnsiChar; status_vector: PPISC_STATUS): ISC_STATUS; stdcall;

  Tisc_start_multiple = function(status_vector: PISC_STATUS; tran_handle: PISC_TR_HANDLE; db_handle_count: Short;
    teb_vector_address: PISC_TEB): ISC_STATUS; stdcall;

  Tisc_commit_retaining = function(status_vector: PISC_STATUS; tran_handle: PISC_TR_HANDLE): ISC_STATUS; stdcall;

  Tisc_commit_transaction = function(status_vector: PISC_STATUS; tran_handle: PISC_TR_HANDLE): ISC_STATUS; stdcall;

  Tisc_rollback_transaction = function(status_vector: PISC_STATUS; tran_handle: PISC_TR_HANDLE): ISC_STATUS; stdcall;

  Tisc_dsql_allocate_statement = function(status_vector: PISC_STATUS; db_handle: PISC_DB_HANDLE;
    stmt_handle: PISC_STMT_HANDLE): ISC_STATUS; stdcall;

  Tisc_dsql_alloc_statement2 = function (status_vector : PISC_STATUS; db_handle : PISC_DB_HANDLE;
    stmt_handle: PISC_STMT_HANDLE): ISC_STATUS; stdcall;

  Tisc_dsql_describe_bind = function(status_vector: PISC_STATUS; stmt_handle: PISC_STMT_HANDLE; dialect: Word;
    xsqlda: PXSQLDA): ISC_STATUS; stdcall;

  Tisc_dsql_prepare = function(status_vector: PISC_STATUS; tran_handle: PISC_TR_HANDLE; stmt_handle: PISC_STMT_HANDLE;
    length: Word; statement: PAnsiChar; dialect: Word; xsqlda: PXSQLDA): ISC_STATUS; stdcall;

  Tisc_dsql_sql_info = function(user_status: PISC_STATUS; stmt_handle: PISC_STMT_HANDLE;
      item_length: Smallint; items: PAnsiChar; buffer_length: Smallint; buffer: PAnsiChar): ISC_STATUS; stdcall;

  Tisc_dsql_execute = function(status_vector: PISC_STATUS; tran_handle: PISC_TR_HANDLE; stmt_handle: PISC_STMT_HANDLE;
    dialect: Word; out_xsqlda: PXSQLDA): ISC_STATUS; stdcall;

  Tisc_dsql_execute2 = function(status_vector: PISC_STATUS; tran_handle: PISC_TR_HANDLE; stmt_handle: PISC_STMT_HANDLE;
    dialect: Word; in_xsqlda, out_xsqlda: PXSQLDA): ISC_STATUS; stdcall;

  Tisc_dsql_execute_immediate = function(status_vector: PISC_STATUS; db_handle: PISC_DB_HANDLE;
      tran_handle: PISC_TR_HANDLE; length: Word; Str: PAnsiChar; dialect: Word; sqlda: PXSQLDA): ISC_STATUS; stdcall;

  Tisc_dsql_describe = function(status_vector: PISC_STATUS; stmt_handle: PISC_STMT_HANDLE;
      dialect: Word; sqlda: PXSQLDA): ISC_STATUS; stdcall;

  Tisc_dsql_fetch = function(status_vector: PISC_STATUS; stmt_handle: PISC_STMT_HANDLE; dialect: Word; sqlda: PXSQLDA): ISC_STATUS; stdcall;

  Tisc_dsql_free_statement = function(status_vector: PISC_STATUS; stmt_handle: PISC_STMT_HANDLE; options: Word): ISC_STATUS; stdcall;

  Tisc_open_blob2 = function (status_vector: PISC_STATUS; db_handle: PISC_DB_HANDLE;
                        tran_handle: PISC_TR_HANDLE; blob_handle: TISC_BLOB_HANDLE;
                        blob_id: PISCQuad; bpb_length: Short; bpb_buffer: TBytes): ISC_STATUS; stdcall;

  Tisc_close_blob = function(status_vector: PISC_STATUS; blob_handle: TISC_BLOB_HANDLE): ISC_STATUS; stdcall;

  Tisc_get_segment = function(status_vector : PISC_STATUS; blob_handle : PISC_BLOB_HANDLE; length: PWord;
      buffer_length: Word; buffer: PAnsiChar): ISC_STATUS; stdcall;

  Tisc_put_segment = function(status_vector : PISC_STATUS; blob_handle : PISC_BLOB_HANDLE; buffer_length: Word; buffer: PAnsiChar): ISC_STATUS; stdcall;

  Tisc_blob_info = function(status_vector: PISC_STATUS; blob_handle: PISC_BLOB_HANDLE;
      item_length: Smallint; items: PAnsiChar; buffer_length: Smallint; buffer: PAnsiChar): ISC_STATUS; stdcall;

  Tisc_create_blob2 = function(status_vector: PISC_STATUS; db_handle: PISC_DB_HANDLE; tran_handle: PISC_TR_HANDLE;
      blob_handle: TISC_BLOB_HANDLE; blob_id: PISCQuad; bpb_length: Smallint; bpb: PAnsiChar): ISC_STATUS; stdcall;

  Tisc_dsql_set_cursor_name = function (status_vector : PISC_STATUS; stmt_handle : PISC_STMT_HANDLE;
                                  cursor_name : PAnsiChar; _type : UShort): ISC_STATUS; stdcall;

  Tisc_que_events = function (status_vector : PISC_STATUS; db_handle : PISC_DB_HANDLE;
				                    event_id : PISCLONG; length : Short; event_buffer : PAnsiChar;
                            event_function : TISC_CALLBACK; event_function_arg: PVoid): ISC_STATUS; stdcall;

  Tisc_event_block = function(event_buffer, result_buffer: PPAnsiChar; count: Word;
      v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15: PAnsiChar): ISC_LONG; stdcall;


  Tisc_free = function (Buffer: IntPtr): ISC_LONG; stdcall;

  Tisc_event_counts = procedure (status_vector : PISC_STATUS; buffer_length: Short;
                                 event_buffer: IntPtr; result_buffer : IntPtr); stdcall;

  Tisc_service_attach = function (status_vector: PISC_STATUS;
                                  service_length: Word;
                                  service_name: PAnsiChar;
                                  handle: PIscSvcHandle;
                                  spb_length: Word;
                                  spb: PAnsiChar): ISC_STATUS; stdcall;

  Tisc_service_detach = function (status_vector: PISC_STATUS;
                                  service_handle: PIscSvcHandle): ISC_STATUS; stdcall;

  Tisc_service_query = function (status_vector: PISC_STATUS;
                                 svc_handle: PIscSvcHandle;
                                 reserved: PIscResvHandle;
                                 send_spb_length: Word;
                                 send_spb: PAnsiChar;
                                 request_spb_length: Word;
                                 request_spb: PAnsiChar;
                                 buffer_length: Word;
                                 buffer: PAnsiChar): ISC_STATUS; stdcall;

  Tisc_service_start = function (status_vector: PISC_STATUS;
                                 svc_handle: PIscSvcHandle;
                                 Reserved: PIscResvHandle;
                                 spb_length: Word;
                                 spb: PAnsiChar): ISC_STATUS; stdcall;

var
  isc_attach_database: Tisc_attach_database;
  isc_detach_database: Tisc_detach_database;
  isc_interprete: Tisc_interprete;
  isc_start_multiple: Tisc_start_multiple;
  isc_commit_retaining: Tisc_commit_retaining;
  isc_commit_transaction: Tisc_commit_transaction;
  isc_rollback_transaction: Tisc_rollback_transaction;
  isc_dsql_allocate_statement: Tisc_dsql_allocate_statement;
  isc_dsql_alloc_statement2: Tisc_dsql_alloc_statement2;
  isc_dsql_describe_bind: Tisc_dsql_describe_bind;
  isc_dsql_prepare: Tisc_dsql_prepare;
  isc_dsql_sql_info: Tisc_dsql_sql_info;
  isc_dsql_execute: Tisc_dsql_execute;
  isc_dsql_execute2: Tisc_dsql_execute2;
  isc_dsql_execute_immediate: Tisc_dsql_execute_immediate;
  isc_dsql_describe: Tisc_dsql_describe;
  isc_dsql_fetch: Tisc_dsql_fetch;
  isc_dsql_free_statement: Tisc_dsql_free_statement;
  isc_dsql_set_cursor_name: Tisc_dsql_set_cursor_name;

  // BLOBs
  isc_open_blob2: Tisc_open_blob2;
  isc_close_blob: Tisc_close_blob;
  isc_get_segment: Tisc_get_segment;
  isc_put_segment: Tisc_put_segment;
  isc_blob_info: Tisc_blob_info;
  isc_create_blob2: Tisc_create_blob2;

  // Eventos
  isc_event_block: Tisc_event_block;
  isc_que_events: Tisc_que_events;
  isc_event_counts: Tisc_event_counts;
  isc_free: Tisc_free;

  // Servicios
  isc_service_attach: Tisc_service_attach;
  isc_service_detach: Tisc_service_detach;
  isc_service_query: Tisc_service_query;
  isc_service_start: Tisc_service_start;

const
  QuadNull: TISCQuad = (gds_quad_high: 0; gds_quad_low: 0);

function CheckIndex( AnArray: TArray<String>; Idx: Integer ): Boolean;
function GetClientLibrary: String;
procedure CheckAPICall(const Status: PISC_STATUS);
function ArrayToString( Vector: TArray<String>; Sep: String; Quoted: Boolean ): String;
function FileAppend(FileName: String; ToWrite: String): Boolean;
function RawGenericSplit( Expresion: String; Delimitador: Char; SplitOnQuotes: Boolean = True): TArray<String>;

implementation

function CheckIndex( AnArray: TArray<String>; Idx: Integer ): Boolean;
begin
  Result:= ((Idx >= Low( AnArray )) and (Idx <= High( AnArray )));
end;

function GetClientLibrary: String;
const FBInstances = 'SOFTWARE\Firebird Project\Firebird Server\Instances';
      FBClientDll = 'fbclient.dll';
var Reg: TRegistry;
    Path: String;
    Found: Boolean;
begin
  Reg:= TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    Found:= False;

    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.KeyExists( FBInstances ) then begin
      if Reg.OpenKeyReadOnly(FBInstances) then begin
        Path:= IncludeTrailingPathDelimiter( Reg.ReadString( 'DefaultInstance' ) );
        if TOSVersion.Architecture = arIntelX64 then begin
          Path:= Path + 'WOW64\';
        end;
        if Not(FileExists( Path + FBClientDll )) then begin
          Path:= Path + 'bin\';
          if (FileExists( Path + FBClientDll )) then begin
            Found:= True;
          end;
        end
        else begin
          Found:= True;
        end;
        if Found then begin
          Result:= Path + FBClientDll;
        end;
      end;
      Reg.CloseKey;
    end;
    Reg.Free;
  except
    Result:= '';
  end;
end;

procedure CheckAPICall(const Status: PISC_STATUS);
var
  msgBuffer: array [0..511] of AnsiChar;
  errMsg: String;
  lastMsg: String;
  errCode: ISC_STATUS;
begin
  errMsg := 'Firebird error:' + #13#10;
  repeat
    errCode := isc_interprete(@msgBuffer, @Status);
    if lastMsg <> StrPas(msgBuffer) then begin
      lastMsg := StrPas(msgBuffer);
      if length(errMsg) <> 0 then
        errMsg := errMsg + #13#10;
      errMsg := errMsg + lastMsg;
    end;
  until errCode = 0;
  raise EFBError.Create(errMsg);
end;

function ArrayToString( Vector: TArray<String>; Sep: String; Quoted: Boolean ): String;
var i: Integer;
begin
  Result:= '';
  for i:= 0 to High( Vector ) do begin
    if Quoted then
      Vector[ i ]:= QuotedStr( Vector[ i ] );
    Result:= Result + Vector[ i ] + Sep;
  end;
  Result:= Copy( Result, 1, Length( Result ) - 1 );
end;

function FileAppend(FileName: String; ToWrite: String): Boolean;
var NArch: TextFile;
begin
  {$IOChecks off}
  AssignFile( NArch, Filename );
  Reset( NArch );
  If FileExists( Filename ) Then
    Append( NArch )
  Else
    ReWrite( NArch );

  WriteLn( NArch, ToWrite );
  CloseFile( NArch );

  Result:= True;
  {$IOChecks on}
end;

function Iif(Expresion: Boolean; ParteVerd: String; ParteFalsa: String): String;
begin
  if Expresion then
    Result:= ParteVerd
  else
    Result:= ParteFalsa;
end;

function CharCount(const S: String; C: Char): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] = C then
      Inc(Result);
end;

function RawGenericSplit( Expresion: String; Delimitador: Char; SplitOnQuotes: Boolean = True): TArray<String>;
var i, k: Integer;
    Comilla: Char;
    Salta: Boolean;
begin
  Comilla:= #0;
  try
    SetLength( Result, 0 );
    if Length( Expresion ) = 0 then
      Exit;
    SetLength( Result, CharCount( Expresion, Delimitador ) + 1);
    k:= 0;
    for i:= 1 to Length( Expresion ) do begin
      if ((Expresion[i] = '''') or (Expresion[i] = '"')) and (Not(SplitOnQuotes)) then begin
        if (CharCount( Copy( Expresion, I, Expresion.Length ), Expresion[i] ) mod 2) = StrToInt( Iif( Comilla = #0, '0', '1' ) ) then begin
          if Comilla = #0 then begin
            Comilla:= Expresion[i];
          end
          else begin
            Comilla:= #0;
          end;
        end;
      end;

      Salta:= False;
      if (Expresion[i] = Delimitador) then begin
        if (Comilla = #0) then begin
          Salta:= True;
        end;
      end;

      if Salta then begin
        Inc(k);
      end
      else begin
        Result[k]:= Result[k] + Expresion[i];
      end;
    end;
    SetLength( Result, K + 1 );
  except
  end;
end;

end.