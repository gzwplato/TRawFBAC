// TRawFB - Clase para acceder a Firebird en pelo
// 2016 Luciano Olocco
// lolocco@gmail.com

unit RawFB;

// Para Firebird 3 usar SuperServer

interface

uses RawFBUtils,
  System.Classes, System.SysUtils, Winapi.Windows, Vcl.Forms;
// Borrar
// Vcl.Dialogs;

const
  FieldSep = #0;

type
  TDatabaseShared = record
    DBName: String;
    Count: Integer;
    DBHandle: THandle;
  end;

  TDatabaseSharedArray = array of TDatabaseShared;

type
  TParamType = (ptUnknown, ptBlob, ptDBKEY);

type
  TRawFBParams = class
  private
    { Private declarations }
    fNamesArray: array of String;
    fParamTypeArray: array of TParamType;
    fStreamsArray: array of TStream;
    fISCQuadArray: array of TISCQuad;
    function GetIndexByName(Name: String): Integer;
    function GetName(Idx: Integer): String;
    procedure SetName(Idx: Integer; const Value: String);
    function GetCount: Integer;
    procedure SetLengthOfArrays(NewLength: Integer);
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    property Name[Idx: Integer]: String read GetName write SetName;
    function GetStreamByName(Name: String): TStream;
    procedure SetStreamByName(Name: String; const Value: TStream);
    function GetISCQuadByName(Name: String): TISCQuad;
    procedure SetISCQuadByName(Name: String; const Value: TISCQuad);
    function GetParamTypeByName(Name: String): TParamType;
    property Count: Integer read GetCount;
  end;

type
  TRawFB = class
  private
    { Private declarations }
    fFBLibrary: String;
    fDLLHandle: THandle;
    fDBHandle: THandle;
    fTransHandle: THandle;
    fStmtHandle: THandle;

    fUser: String;
    fPassword: String;
    fHost: String;
    fDatabase: String;
    fPort: Integer;
    fDialect: Word;
    fCharacterSet: TCharacterSet;
    fSQL: TStringList;
    fFields: Integer;
    fStoreRecordSet: Boolean;
    fStatusVector: ISC_STATUS_VECTOR;
    fFieldNames: TArray<String>;
    fFieldNamesInDB: TArray<String>;
    fInternalRecordSet: TArray<String>;
    fInternalCurrentRecord: TArray<String>;
    fRecordSetIndex: Integer;
    fRecordsFetched: Integer;
    fInternalEOF: Boolean;
    fSharedDBIndex: Integer;
    fParams: TRawFBParams;
    fSegmentSize: Word;
    fCanUseEmbedded: Boolean;
    fFreeRecordSetOnCommitOrRollBack: Boolean;
    fLastExecutedSQLType: TGenericStatementType;
    // Log
    fLogStatementsStartsWith: String;
    fLogStatements2File: String;
    fPlan: String;
    fInsertsAffected: Integer;
    fUpdatesAffected: Integer;
    fDeletesAffected: Integer;

    Out_DA: PXSQLDA;
    fDataBuffer: Pointer;
    fDataBufferLen: Integer;

    procedure ProcessParams;

    function XSQLDA_LENGTH(N: Integer): Integer;
    procedure DecodeStringW(const Code: Smallint; Index: Word; out Str: String);
    function MBUDecode(const Str: RawByteString; cp: Word): String;
    procedure AllocateDataBuffer(SQLDA: PXSQLDA);

    function GetConnected: Boolean;
    procedure SetConnected(const Value: Boolean);
    procedure SetRecordSetIndex(const Value: Integer);
    function GetField(FieldName: String): String;
    function InternalGetField(Index: Integer): String;
    procedure PutCurrentRecord;
    function GetFieldCount: Integer;
    function GetFieldNameByNumber(Idx: Integer): String;
    function GetFieldNumberByName(FieldName: String): Integer;
    function GetEOF: Boolean;
    function BlobGetSegment(var BlobHandle: TISC_BLOB_HANDLE; out length: Word; BufferLength: Cardinal;
      Buffer: Pointer): Boolean;
    procedure BlobWriteSegment(var BlobHandle: TISC_BLOB_HANDLE; BufferLength: Cardinal; Buffer: Pointer);
    procedure BlobSaveToStream(var BlobHandle: TISC_BLOB_HANDLE; Stream: TStream);
    procedure BlobWriteStream(var BlobHandle: TISC_BLOB_HANDLE; Stream: TStream);
    procedure FreeOut_DA;
    function GetRawField(FieldName: String): String;
    procedure Log(ASQL: String);
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    { Para usar desde RawFBEvents }
    property DBHandle: THandle read fDBHandle;

    property FBLibrary: String read fFBLibrary write fFBLibrary;
    property User: String read fUser write fUser;
    property Password: String read fPassword write fPassword;
    property Host: String read fHost write fHost;
    property Port: Integer read fPort write fPort;
    property Dialect: Word read fDialect write fDialect;
    property Database: String read fDatabase write fDatabase;
    property Connected: Boolean read GetConnected write SetConnected;
    property SQL: TStringList read fSQL write fSQL;
    property StoreRecordSet: Boolean read fStoreRecordSet write fStoreRecordSet;
    property CanUseEmbedded: Boolean read fCanUseEmbedded write fCanUseEmbedded;
    procedure CreateDatabase;
    procedure StartTransaction;
    procedure CommitTransaction;
    procedure RollBackTransaction;
    procedure Connect;
    function InTransaction: Boolean;
    procedure Fetch;
    procedure SQLExecute;
    procedure ExecuteImmediate(ASQL: String);
    procedure SQLsExecute( SQLs: TStringList; SQLSeparator: Char );
    property EOF: Boolean read GetEOF;
    procedure FirstRecord;
    procedure PriorRecord;
    procedure NextRecord;
    procedure LastRecord;
    property LastExecutedSQLType: TGenericStatementType read fLastExecutedSQLType;
    property RecordSetIndex: Integer read fRecordSetIndex write SetRecordSetIndex;
    property RecordSetCount: Integer read fRecordsFetched;
    property Field[FieldName: String]: String read GetField; default;
    property RawField[FieldName: String]: String read GetRawField;
    property FieldCount: Integer read GetFieldCount;
    property FieldNameByNumber[Index: Integer]: String read GetFieldNameByNumber;
    property FieldNumberByName[FieldName: String]: Integer read GetFieldNumberByName;
    procedure FieldType(AFieldName: String; out AFieldType: TGenericFieldType; out AFieldLen: Integer); overload;
    procedure FieldType(AFieldIdx: Integer; out AFieldType: TGenericFieldType; out AFieldLen: Integer); overload;
    function FieldNameInDB(FieldName: String): String;
    procedure BlobField(FieldName: String; AStream: TStream);
    procedure DBKEYField(FieldName: String; out AISCQuad: TISCQuad);
    function FormatDBKey4View( FieldName: String ): String;
    property Params: TRawFBParams read fParams write fParams;
    property FreeRecordSetOnCommitOrRollBack: Boolean read fFreeRecordSetOnCommitOrRollBack write fFreeRecordSetOnCommitOrRollBack;
    procedure FreeRecordSetDogFace;
    procedure FreeStatement;

    procedure LoadFunctions;
    property LogStatementsStartsWith: String read fLogStatementsStartsWith write fLogStatementsStartsWith;
    property LogStatements2File: String read fLogStatements2File write fLogStatements2File;
    property Plan: String read fPlan;
    property InsertsAffected: Integer read fInsertsAffected;
    property UpdatesAffected: Integer read fUpdatesAffected;
    property DeletesAffected: Integer read fDeletesAffected;
  end;

implementation

var
  DataBaseShared: TDatabaseSharedArray;

{ TRawFirebird }

function TRawFB.XSQLDA_LENGTH(N: Integer): Integer;
begin
  Result := SizeOf(TXSQLDA) + ((N - 1) * SizeOf(TXSQLVAR));
  if Result < 0 then begin
    Result := SizeOf(TXSQLDA);
  end;
end;

procedure TRawFB.DBKEYField(FieldName: String; out AISCQuad: TISCQuad);
var
  FieldValue: String;
begin
  FieldValue := RawField[FieldName];
  if Copy(FieldValue, 1, 7) = 'DB_KEY<' then begin
    // Es un DB_KEY
    FieldValue := Copy(FieldValue, 8, length(FieldValue) - 8);
    AISCQuad.gds_quad_high := StrToInt(Copy(FieldValue, 1, Pos(':', FieldValue) - 1));
    AISCQuad.gds_quad_low := StrToInt(Copy(FieldValue, Pos(':', FieldValue) + 1, 255));
  end
  else begin
    AISCQuad.gds_quad_high := 0;
    AISCQuad.gds_quad_low := 0;
  end;
end;

procedure TRawFB.DecodeStringW(const Code: Smallint; Index: Word; out Str: String);
begin
  with Out_DA.sqlvar[Index] do
    case Code of
      SQL_TEXT: begin
          Str := MBUDecode(Copy(sqlData, 0, SqlLen), CharacterSetCP[fCharacterSet]);

          if SqlSubType > 0 then
            SetLength(Str, SqlLen div BytesPerCharacter[fCharacterSet]);
        end;
      SQL_VARYING:
        Str := MBUDecode(Copy(PAnsiChar(@PVary(sqlData).vary_string), 0, PVary(sqlData).vary_length),
          CharacterSetCP[fCharacterSet]);
    end;
end;

function TRawFB.MBUDecode(const Str: RawByteString; cp: Word): String;
begin
  if cp > 0 then begin
    SetLength(Result, MultiByteToWideChar(cp, 0, PAnsiChar(Str), length(Str), nil, 0));
    MultiByteToWideChar(cp, 0, PAnsiChar(Str), length(Str), PWideChar(Result), length(Result));
  end
  else begin
    Result := UnicodeString(Str);
  end;
end;

procedure DecodeTimeStamp(v: PISCTimeStamp; out DateTime: Double); overload;
begin
  DateTime := v.timestamp_date - DateOffset + (v.timestamp_time / TimeCoeff);
end;

procedure DecodeTimeStamp(v: PISCTimeStamp; out TimeStamp: TTimeStamp); overload;
begin
  TimeStamp.Date := v.timestamp_date - DateOffset + 693594;
  TimeStamp.Time := v.timestamp_time div 10;
end;

function DecodeTimeStamp(v: PISCTimeStamp): Double; overload;
begin
  DecodeTimeStamp(v, Result);
end;

function TRawFB.GetConnected: Boolean;
begin
  Result := (Pointer(fDBHandle) <> nil);
end;

function TRawFB.GetEOF: Boolean;
begin
  if (fStoreRecordSet) then begin
    if ((fRecordSetIndex + 1) >= fRecordsFetched) and (Not(fInternalEOF)) then begin
      Result := False;
    end
    else begin
      if (fRecordSetIndex + 1 >= fRecordsFetched) then begin
        Result := True;
      end
      else begin
        Result := False;
      end;
    end;
  end
  else begin
    Result:= fInternalEOF;
  end;

//  if ((fRecordSetIndex + 1) >= fRecordsFetched) and (Not(fInternalEOF)) then begin
//    Result := False;
//  end
//  else begin
//    if (fRecordSetIndex + 1 >= fRecordsFetched) then begin
//      Result := True;
//    end
//    else begin
//      Result := False;
//    end;
//  end;
end;

function TRawFB.GetField(FieldName: String): String;
begin
  Result := GetRawField(FieldName);
  if FieldNameInDB(FieldName) = 'DB_KEY' then begin
    Result:= FormatDBKey4View( FieldName );
  end;
end;

function TRawFB.GetFieldCount: Integer;
begin
  // Result := Out_DA.sqld;
  Result := Length(fFieldNames);
end;

function TRawFB.GetFieldNameByNumber(Idx: Integer): String;
begin
  if CheckIndex(fFieldNames, Idx) then begin
    Result := fFieldNames[Idx];
  end
  else begin
    Result := '';
  end;
end;

function TRawFB.GetFieldNumberByName(FieldName: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  FieldName := UpperCase(FieldName);
  for I := Low(fFieldNames) to High(fFieldNames) do begin
    if FieldName = UpperCase(fFieldNames[I]) then begin
      Result := I;
      Break;
    end;
  end;
end;

function TRawFB.GetRawField(FieldName: String): String;
var Idx: Integer;
begin
  Idx := GetFieldNumberByName(FieldName);

  if Idx <> -1 then begin
    if CheckIndex(fInternalCurrentRecord, Idx) then begin
      Result := fInternalCurrentRecord[Idx];
    end
    else begin
      Result := '';
    end;
  end
  else begin
    Result := '';
  end;
end;

function TRawFB.InternalGetField(Index: Integer): String;
var
  ASQLCode: Integer;
begin
  // CheckRange(Index);
  Result := '';
  with Out_DA.sqlvar[Index] do begin
    if (sqlind <> nil) and (sqlind^ = -1) then
      Exit;
    ASQLCode := (sqltype and not(1));
    // Is Numeric ?
    if (sqlscale < 0) then begin
      case ASQLCode of
        SQL_SHORT:
          Result := FormatFloat(ScaleFormat[sqlscale], PSmallInt(sqlData)^ / ScaleDivisor[sqlscale]);
        SQL_LONG:
          Result := FormatFloat(ScaleFormat[sqlscale], PInteger(sqlData)^ / ScaleDivisor[sqlscale]);
        SQL_INT64, SQL_QUAD:
          Result := FormatFloat(ScaleFormat[sqlscale], PInt64(sqlData)^ / ScaleDivisor[sqlscale]);
        SQL_D_FLOAT, SQL_DOUBLE:
          Result := FormatFloat(ScaleFormat[sqlscale], PDouble(sqlData)^);
      end;
    end
    else begin
      if ((ASQLCode = SQL_TEXT) and (UpperCase(GetFieldNameByNumber(Index)) = 'DB_KEY')) then begin
        Result := Format('DB_KEY<%d:%d>', [PISCQuad(sqlData).gds_quad_high, PISCQuad(sqlData).gds_quad_low]);
      end
      else begin
        case ASQLCode of
          SQL_TEXT:
            DecodeStringW(SQL_TEXT, Index, Result);
          SQL_VARYING:
            DecodeStringW(SQL_VARYING, Index, Result);
          SQL_TIMESTAMP:
            Result := FormatDateTime( 'dd-mm-yyyy, HH:mm:ss.zzz', DecodeTimeStamp(PISCTimeStamp(sqlData)));
            //DateTimeToStr(DecodeTimeStamp(PISCTimeStamp(sqlData)));
          SQL_TYPE_DATE:
            Result := DateToStr(PInteger(sqlData)^ - DateOffset);
          SQL_TYPE_TIME:
            Result := TimeToStr(PCardinal(sqlData)^ / TimeCoeff);
          SQL_D_FLOAT, SQL_DOUBLE:
            Result := FloatToStr(PDouble(sqlData)^);
          SQL_LONG:
            Result := IntToStr(PInteger(sqlData)^);
          SQL_FLOAT:
            Result := FloatToStr(PSingle(sqlData)^);
          SQL_SHORT:
            Result := IntToStr(PSmallInt(sqlData)^);
          SQL_INT64:
            Result := IntToStr(PInt64(sqlData)^);
          SQL_BLOB:
            Result := Format('Blob<%d:%d>', [PISCQuad(sqlData).gds_quad_high, PISCQuad(sqlData).gds_quad_low]);
          SQL_NULL:
            ;
        end;
      end;
    end;
  end;
end;

function TRawFB.InTransaction: Boolean;
begin
  Result := (Pointer(fTransHandle) <> nil);
end;

procedure TRawFB.LastRecord;
begin
  if fStoreRecordSet then begin
    while not(EOF) do begin
      Fetch;
    end;
    PutCurrentRecord;
  end;
end;

procedure TRawFB.LoadFunctions;
var Msg: String;
begin
  if (fDLLHandle = 0) then begin
    if fFBLibrary = '' then begin
      fFBLibrary := GetClientLibrary;
    end;

    fDLLHandle := LoadLibraryEx(PChar(fFBLibrary), 0, 0);
    //fDLLHandle := LoadLibrary(PChar(fFBLibrary));
    if fDLLHandle <> 0 then begin
      isc_interprete := GetProcAddress(fDLLHandle, 'isc_interprete');
      isc_attach_database := GetProcAddress(fDLLHandle, 'isc_attach_database');
      isc_detach_database := GetProcAddress(fDLLHandle, 'isc_detach_database');

      isc_start_multiple := GetProcAddress(fDLLHandle, 'isc_start_multiple');

      isc_dsql_prepare := GetProcAddress(fDLLHandle, 'isc_dsql_prepare');
      isc_dsql_allocate_statement := GetProcAddress(fDLLHandle, 'isc_dsql_allocate_statement');
      isc_dsql_alloc_statement2 := GetProcAddress(fDLLHandle, 'isc_dsql_alloc_statement2');

      isc_dsql_describe := GetProcAddress(fDLLHandle, 'isc_dsql_describe');
      isc_dsql_sql_info := GetProcAddress(fDLLHandle, 'isc_dsql_sql_info');

      isc_dsql_execute := GetProcAddress(fDLLHandle, 'isc_dsql_execute');
      isc_dsql_execute2 := GetProcAddress(fDLLHandle, 'isc_dsql_execute2');
      isc_dsql_execute_immediate := GetProcAddress(fDLLHandle, 'isc_dsql_execute_immediate');
      isc_dsql_fetch := GetProcAddress(fDLLHandle, 'isc_dsql_fetch');
      isc_dsql_free_statement := GetProcAddress(fDLLHandle, 'isc_dsql_free_statement');

      isc_commit_transaction := GetProcAddress(fDLLHandle, 'isc_commit_transaction');
      isc_rollback_transaction := GetProcAddress(fDLLHandle, 'isc_rollback_transaction');

      isc_open_blob2 := GetProcAddress(fDLLHandle, 'isc_open_blob2');
      isc_close_blob := GetProcAddress(fDLLHandle, 'isc_close_blob');
      isc_get_segment := GetProcAddress(fDLLHandle, 'isc_get_segment');
      isc_put_segment := GetProcAddress(fDLLHandle, 'isc_put_segment');
      isc_blob_info := GetProcAddress(fDLLHandle, 'isc_blob_info');
      isc_create_blob2 := GetProcAddress(fDLLHandle, 'isc_create_blob2');

      isc_dsql_set_cursor_name := GetProcAddress(fDLLHandle, 'isc_dsql_set_cursor_name');

      isc_event_block := GetProcAddress(fDLLHandle, 'isc_event_block');
      isc_que_events := GetProcAddress(fDLLHandle, 'isc_que_events');
      isc_event_counts := GetProcAddress(fDLLHandle, 'isc_event_counts');

      isc_free := GetProcAddress(fDLLHandle, 'isc_free');

      isc_service_attach := GetProcAddress(fDLLHandle, 'isc_service_attach');
      isc_service_detach := GetProcAddress(fDLLHandle, 'isc_service_detach');
      isc_service_query := GetProcAddress(fDLLHandle, 'isc_service_query');
      isc_service_start := GetProcAddress(fDLLHandle, 'isc_service_start');
    end
    else begin
      Msg:= 'No se pudo cargar el cliente de Firebird.' + #13#10#13#10 + 'Código de error: ' + IntToStr(GetLastError) + #13#10#13#10 +
             'Archivo cliente:' + #13#10 + fFBLibrary;
      Application.MessageBox( PChar( Msg ), PChar( Application.Title ), MB_OK + MB_ICONERROR );
    end;
  end;
end;

procedure TRawFB.Log(ASQL: String);
var AnArray: TArray<String>;
    I: Integer;
    Log2File: Boolean;
begin
  Log2File:= False;
  if (LogStatements2File <> '') and (LogStatementsStartsWith <> '') then begin
    AnArray:= RawGenericSplit( LogStatementsStartsWith, ',');
    for I:= Low(AnArray) to High(AnArray) do begin
      if AnArray[I].StartsWith('!') then begin
        AnArray[I]:= Copy( AnArray[I], 2, Length(AnArray[I]));
        if Pos( LowerCase(AnArray[I]), LowerCase(ASQL) ) > 0 then begin
          Log2File:= False;
        end;
      end
      else begin
        if (AnArray[ I ] <> '') and (ASQL.StartsWith( AnArray[I], True )) then begin
          Log2File:= True;
        end;
      end;
    end;
    if Log2File then begin
      FileAppend( LogStatements2File, FormatDateTime( 'dd-mm-yyyy HH:mm:ss', Now ) + ': ' + ASQL );
    end;
  end;
end;

procedure TRawFB.NextRecord;
begin
  if fStoreRecordSet then begin
    if ((fRecordSetIndex + 1) >= fRecordsFetched) and (Not(fInternalEOF)) then begin
      Fetch;
    end
    else begin
      if (fRecordSetIndex + 1 < fRecordsFetched) then begin
        Inc(fRecordSetIndex);
        PutCurrentRecord;
      end;
    end;
  end
  else begin
    if (Not(fInternalEOF)) then begin
      Fetch;
    end
  end;

//  if ((fRecordSetIndex + 1) >= fRecordsFetched) and (Not(fInternalEOF)) then begin
//    Fetch;
//  end
//  else begin
//    if (fRecordSetIndex + 1 < fRecordsFetched) then begin
//      Inc(fRecordSetIndex);
//      PutCurrentRecord;
//    end;
//  end;
end;

procedure TRawFB.PriorRecord;
begin
  if (fStoreRecordSet) and (fRecordSetIndex > 0) then begin
    Dec(fRecordSetIndex);
    PutCurrentRecord;
  end;
end;

procedure TRawFB.ProcessParams;
var
  ASQL, Str2Replace: String;
  AName: AnsiString;
  I, J, Idx, DosPuntosPos, ParamCount: Integer;
  ISCQuadArray: TArray<TISCQuad>;
  NamesArray: TArray<String>;
  DummyISCQuad: TISCQuad;
  BPB: AnsiString;
  BlobHandle: TISC_BLOB_HANDLE;
  p: PXSQLVAR;
  ActualParamType: TParamType;
const
  Seps: array [0 .. 3] of string = (' ', ',', ')', ';');
begin
  ParamCount := 0;
  for I := 0 to SQL.Count - 1 do begin
    ASQL := SQL[I];
    DosPuntosPos := Pos(':', ASQL);
    if DosPuntosPos > 0 then begin
      Inc(ParamCount);
      Str2Replace := '';
      J := 0;
      while ((Not(CharInSet(ASQL[DosPuntosPos + J], [' ', ',', ')', ';'])) and (length(ASQL) >= DosPuntosPos + J))) do begin
        Str2Replace := Str2Replace + ASQL[DosPuntosPos + J];
        Inc(J);
      end;

      if fParams.GetIndexByName(Copy(Str2Replace, 2, Str2Replace.length)) <> -1 then begin
        SQL[I] := StringReplace(SQL[I], Str2Replace, '?', []);
        Str2Replace := Copy(Str2Replace, 2, length(Str2Replace));
        Idx := fParams.GetIndexByName(Str2Replace);
        if fParams.GetParamTypeByName(Str2Replace) = ptBlob then begin
          SetLength(ISCQuadArray, ParamCount);
          SetLength(NamesArray, ParamCount);

          // Crear el Blob y asignarle el archivo
          BPB := '';
          BlobHandle := 0;

          if isc_create_blob2(@fStatusVector, @fDBHandle, @fTransHandle, @BlobHandle, @DummyISCQuad, length(BPB),
            PAnsiChar(BPB)) <> 0 then begin
            CheckAPICall(@fStatusVector);
          end;
          BlobWriteStream(BlobHandle, fParams.GetStreamByName(Str2Replace));
          NamesArray[ParamCount - 1] := Str2Replace;
          fParams.SetISCQuadByName(Str2Replace, DummyISCQuad);

          if isc_close_blob(@fStatusVector, @BlobHandle) <> 0 then begin
            CheckAPICall(@fStatusVector);
          end;
        end;
      end
      else begin
        Dec(ParamCount);
      end;
    end;
  end;

  // Alojamos info de los parámetros
  GetMem(Out_DA, XSQLDA_LENGTH(ParamCount));
  Out_DA.sqln := ParamCount;
  Out_DA.sqld := ParamCount;
  Out_DA.version := 1;
  for I := 0 to fParams.Count - 1 do begin
    ActualParamType := fParams.GetParamTypeByName(fParams.Name[I]);
    DummyISCQuad := fParams.GetISCQuadByName(fParams.Name[I]);

    if ActualParamType = ptBlob then
      Out_DA.sqlvar[I].sqltype := SQL_BLOB + 1
    else if ActualParamType = ptDBKEY then
      Out_DA.sqlvar[I].sqltype := SQL_TEXT + 1;

    Out_DA.sqlvar[I].SqlLen := SizeOf(TISCQuad);
    Out_DA.sqlvar[I].ParamNameLength := length(fParams.Name[I]);
    p := @Out_DA.sqlvar[I];
    if p^.ParamNameLength > 0 then
      Move(PAnsiChar(AnsiString(fParams.Name[I]))^, p^.ParamName[0], p^.ParamNameLength);

    Out_DA.sqlvar[I].ID := I + 1;
    with Out_DA.sqlvar[I] do begin
      GetMem(sqlData, SqlLen);
      PISCQuad(sqlData)^ := DummyISCQuad;
      GetMem(p^.sqlind, 2);
      p^.sqlind^ := -1; // nil;

      if (sqlind <> nil) then
        if CompareMem(@DummyISCQuad, @QuadNull, SizeOf(TISCQuad)) then
          sqlind^ := -1
        else
          sqlind^ := 0;

    end;
  end;
  if ParamCount = 0 then begin
    FreeMem(Out_DA);
  end;
end;

procedure TRawFB.PutCurrentRecord;
var
  Idx: Integer;
begin
  if fStoreRecordSet then
    Idx := fRecordSetIndex
  else
    Idx := 0;

  if Idx <= (length(fInternalRecordSet)) then begin
    if CheckIndex(fInternalRecordSet, Idx) then begin
      fInternalCurrentRecord := RawGenericSplit(fInternalRecordSet[Idx], FieldSep);
    end
    else begin
      fInternalCurrentRecord := RawGenericSplit('', FieldSep);
    end;
  end;
end;

procedure TRawFB.RollBackTransaction;
begin
  if InTransaction then begin
    FreeStatement;
    if isc_rollback_transaction(@fStatusVector, @fTransHandle) <> 0 then begin
      CheckAPICall(@fStatusVector);
    end
    else begin
      FreeOut_DA;
    end;
  end;
end;

procedure TRawFB.AllocateDataBuffer(SQLDA: PXSQLDA);
var
  I, J, LastLen: Smallint;
  BlobCount: Word;

  ArrayIndex: Integer;
  ArrayItemLen: Integer;
  ArrayItemCount: Integer;
  PDesc: PArrayInfo;
  PBound: PISCArrayBound;
  FDataBufferLength: PtrInt;
begin
  FDataBufferLength := 0;
  LastLen := 0;
  BlobCount := 0;
  ArrayIndex := 0;
  // SetLength(FBlobsIndex, BlobCount);
  // calculate offsets and store them instead of pointers ;)
  for I := 0 to SQLDA.sqln - 1 do begin
    Inc(FDataBufferLength, LastLen);
    SQLDA.sqlvar[I].sqlData := Pointer(FDataBufferLength);
    case SQLDA.sqlvar[I].sqltype and not 1 of
      SQL_VARYING:
        LastLen := SQLDA.sqlvar[I].SqlLen + 2;
      SQL_BLOB: begin
          LastLen := SQLDA.sqlvar[I].SqlLen + SizeOf(TBlobData); // quad + datainfo
          Inc(BlobCount);
          // SetLength(FBlobsIndex, BlobCount);
          // FBlobsIndex[BlobCount-1] := i;
        end;
      SQL_ARRAY: begin
          // PDesc := @FArrayInfos[ArrayIndex];
          // if (PDesc.info.array_desc_dtype in [blr_varying, blr_varying2]) then
          // ArrayItemLen := PDesc.info.array_desc_length + 2 else
          // ArrayItemLen := PDesc.info.array_desc_length;
          // ArrayItemCount := 0;
          // for j := 0 to PDesc.info.array_desc_dimensions - 1 do
          // begin
          // PBound := @PDesc.info.array_desc_bounds[j];
          // inc(ArrayItemCount, PBound.array_bound_upper - PBound.array_bound_lower + 1);
          // end;
          // PDesc.size := ArrayItemCount * ArrayItemLen;
          // LastLen :=  SQLDA.sqlvar[i].sqllen + PDesc.size; // quad + data
          // inc(ArrayIndex);
        end;
    else
      LastLen := SQLDA.sqlvar[I].SqlLen;
    end;

    if ((SQLDA.sqlvar[I].sqltype and 1) = 1) then begin
      Inc(FDataBufferLength, LastLen);
      SQLDA.sqlvar[I].sqlind := Pointer(FDataBufferLength);
      LastLen := SizeOf(Smallint);
    end
    else
      SQLDA.sqlvar[I].sqlind := nil;
  end;
  Inc(FDataBufferLength, LastLen);

  // Now we have the total length needed
  fDataBufferLen := FDataBufferLength;
  if (fDataBuffer = nil) then
    GetMem(fDataBuffer, FDataBufferLength)
  else
    ReallocMem(fDataBuffer, FDataBufferLength);
  FillChar(fDataBuffer^, FDataBufferLength, #0);

  // increment Offsets with the buffer
  for I := 0 to SQLDA.sqln - 1 do begin
    // I don't use cardinal for FPC compatibility
    Inc(PtrInt(SQLDA.sqlvar[I].sqlData), PtrInt(fDataBuffer));
    if (SQLDA.sqlvar[I].sqlind <> nil) then
      Inc(PtrInt(SQLDA.sqlvar[I].sqlind), PtrInt(fDataBuffer));
  end;
end;

procedure TRawFB.CommitTransaction;
var
  I: Integer;
begin
  if InTransaction then begin
    FreeStatement;
    if isc_commit_transaction(@fStatusVector, @fTransHandle) <> 0 then begin
      CheckAPICall(@fStatusVector);
    end
    else begin
      FreeOut_DA;
    end;
  end;
end;

procedure TRawFB.Connect;
begin
  Connected := True;
end;

constructor TRawFB.Create;
begin
  Inherited;
  // fFBLibrary:= GetClientLibrary;
  fFBLibrary := '';
  fUser := 'SYSDBA';
  fPassword := 'masterkey';
  fHost := 'localhost';
  fDialect := 3;
  fSQL := TStringList.Create;
  fStoreRecordSet := True;

  fParams := TRawFBParams.Create;
  fSegmentSize := 16 * 1024;
  fCanUseEmbedded := False;
  fFreeRecordSetOnCommitOrRollBack := False;
  fLogStatementsStartsWith:= '';
  fLogStatements2File:= '';
end;

procedure TRawFB.CreateDatabase;
begin
  ExecuteImmediate(Format('create database "%s" user "%s" password "%s"', [fDatabase, fUser, fPassword]));
end;

destructor TRawFB.Destroy;
begin
  if InTransaction then
    CommitTransaction;

  SetConnected(False);

  SetLength(fFieldNames, 0);
  SetLength(fFieldNamesInDB, 0);
  Finalize(fFieldNames);
  Finalize(fFieldNamesInDB);
  fFieldNames := nil;
  fFieldNamesInDB := nil;

  SetLength(fInternalCurrentRecord, 0);
  Finalize(fInternalCurrentRecord);
  fInternalCurrentRecord := nil;

  SetLength(fInternalRecordSet, 0);
  Finalize(fInternalRecordSet);
  fInternalRecordSet := nil;

  FreeAndNil(fSQL);
  FreeAndNil(fParams);

  inherited;
end;

procedure TRawFB.ExecuteImmediate(ASQL: String);
var
  AStr: AnsiString;
begin
  fLastExecutedSQLType:= stNone;
  AStr := ASQL;
  if isc_dsql_execute_immediate(@fStatusVector, @fDBHandle, @fTransHandle, length(AStr), PAnsiChar(AStr), fDialect, Out_DA) <> 0 then begin
    CheckAPICall(@fStatusVector);
  end;
  Log( ASQL );
end;

procedure TRawFB.Fetch;
var
  FetchStatus: Integer;
  CompleteRecord: String;
  I: Integer;
begin
  FetchStatus := isc_dsql_fetch(@fStatusVector, @fStmtHandle, 1, Out_DA);
  case FetchStatus of
    0: // Todo OK
      begin
        CompleteRecord := '';
        for I := 0 to Out_DA.sqld - 1 do begin
          CompleteRecord := CompleteRecord + InternalGetField(I) + FieldSep;
        end;
        if fStoreRecordSet then begin
          SetLength(fInternalRecordSet, length(fInternalRecordSet) + 1);
          fRecordSetIndex := High(fInternalRecordSet);
        end
        else begin
          if length(fInternalRecordSet) <> 1 then begin
            SetLength(fInternalRecordSet, 1);
          end;
          fRecordSetIndex := 0;
        end;

        // ***************************************************************
        // if fRecordSetIndex = 1000 then begin
        // fRecordSetIndex:= fRecordSetIndex;
        // end;
        // ***************************************************************

        fInternalRecordSet[fRecordSetIndex] := CompleteRecord;
        Inc(fRecordsFetched);
        PutCurrentRecord;
      end;
    100: // EOF
      begin
        fInternalEOF := True;
        // fEOF:= True;
      end;
  else begin
      CheckAPICall(@fStatusVector);
    end;
  end;
end;

procedure TRawFB.FieldType(AFieldName: String; out AFieldType: TGenericFieldType; out AFieldLen: Integer);
var
  I, Idx: Integer;
begin
  AFieldType := ftUnknown;
  AFieldLen := 0;
  Idx := -1;
  AFieldName := UpperCase(AFieldName);
  for I := Low(fFieldNames) to High(fFieldNames) do begin
    if fFieldNames[I] = AFieldName then begin
      Idx := I;
      Break;
    end;
  end;
  if Idx <> -1 then begin
    FieldType(Idx, AFieldType, AFieldLen);
  end;
end;

function TRawFB.FieldNameInDB(FieldName: String): String;
var
  Idx: Integer;
begin
  Idx := GetFieldNumberByName(FieldName);
  if Idx > -1 then begin
    Result := fFieldNamesInDB[Idx];
  end
  else begin
    Result := '';
  end;
end;

procedure TRawFB.FieldType(AFieldIdx: Integer; out AFieldType: TGenericFieldType; out AFieldLen: Integer);
var
  I: Integer;
  ASQLCode: Smallint;
begin
  AFieldType := ftUnknown;
  AFieldLen := 0;
  if AFieldIdx <> -1 then begin
    with Out_DA.sqlvar[AFieldIdx] do begin
      // if (sqlind <> nil) and (sqlind^ = -1) then
      // Exit;
      ASQLCode := (sqltype and not(1));
      // Is Numeric ?
      if (sqlscale < 0) then begin
        case ASQLCode of
          SQL_SHORT:
            AFieldType := ftShortint;
          SQL_LONG, SQL_INT64, SQL_QUAD:
            AFieldType := ftInteger;
          SQL_D_FLOAT, SQL_DOUBLE:
            AFieldType := ftFloat;
        end;
      end
      else begin
        case ASQLCode of
          SQL_TEXT, SQL_VARYING:
            AFieldType := ftString;
          SQL_TIMESTAMP:
            AFieldType := ftTimeStamp;
          SQL_TYPE_DATE:
            AFieldType := ftDate;
          SQL_TYPE_TIME:
            AFieldType := ftTime;
          SQL_D_FLOAT, SQL_FLOAT, SQL_DOUBLE:
            AFieldType := ftFloat;
          SQL_LONG, SQL_INT64:
            AFieldType := ftInteger;
          SQL_SHORT:
            AFieldType := ftShortint;
          SQL_NULL:
            AFieldType := ftUnknown;
        else
          AFieldType := ftUnknown;
        end;
        AFieldLen := SqlLen;
      end;
    end;
  end;
end;

procedure TRawFB.FirstRecord;
begin
  if fStoreRecordSet then begin
    fRecordSetIndex := 0;
    PutCurrentRecord;
    // fEOF:= False;
  end;
end;

function TRawFB.FormatDBKey4View(FieldName: String): String;
var AISCQuad: GDS_QUAD;
begin
  DBKEYField( FieldName, AISCQuad );
  Result:= IntToHex( AISCQuad.gds_quad_high, 8 ) + ':' + IntToHex( AISCQuad.gds_quad_low, 8 );
end;

procedure TRawFB.FreeOut_DA;
var
  I: Integer;
begin
  if fParams.Count > 0 then begin
    for I := Low(Out_DA.sqlvar) to High(Out_DA.sqlvar) do begin
      if ((Out_DA.sqlvar[I].sqltype and 1) = 1) then begin
        FreeMem(Out_DA.sqlvar[I].sqlind);
        FreeMem(Out_DA.sqlvar[I].sqlData);
      end;
    end;
    fParams.Clear;
  end;

  FreeMem(fDataBuffer);
  fDataBuffer := nil;
  fDataBufferLen := 0;

  FreeMem(Out_DA);
  Out_DA := nil;
  if fFreeRecordSetOnCommitOrRollBack then begin
    FreeRecordSetDogFace;
  end;
end;

procedure TRawFB.FreeRecordSetDogFace;
begin
  if InTransaction then begin
    RollBackTransaction;
  end;
  SetLength(fInternalRecordSet, 0);
  SetLength(fInternalCurrentRecord, 0);
  SetLength(fFieldNames, 0);
  SetLength(fFieldNamesInDB, 0);
end;

procedure TRawFB.FreeStatement;
begin
  if fStmtHandle > 0 then begin
    try
      if (fLastExecutedSQLType = stSelect) or (fLastExecutedSQLType = stSelectForUpdate) then begin
        if isc_dsql_free_statement(@fStatusVector, @fStmtHandle, DSQL_close) <> 0 then begin
          CheckAPICall(@fStatusVector);
        end;
      end;
      if isc_dsql_free_statement(@fStatusVector, @fStmtHandle, DSQL_drop) <> 0 then begin
        CheckAPICall(@fStatusVector);
      end;
    finally
      fStmtHandle := 0;
    end;
  end;
end;

procedure TRawFB.SetConnected(const Value: Boolean);
var
  ParamsStr: AnsiString;
  Params: array [0..255] of AnsiChar;
  I: Integer;
  DBName: AnsiString;
begin
  if Value then begin
    LoadFunctions;
    if ((LowerCase(Host) = 'localhost') or (Host = '127.0.0.1')) and (fCanUseEmbedded) then begin
      DBName := Database;
    end
    else begin
      DBName := Host + ':' + Database;
    end;

    fSharedDBIndex := -1;
    for I := Low(DataBaseShared) to High(DataBaseShared) do begin
      if (LowerCase(DataBaseShared[I].DBName) = LowerCase(DBName)) or (DataBaseShared[I].DBName = '') then begin
        fSharedDBIndex := I;
        fDBHandle := DataBaseShared[I].DBHandle;
        DataBaseShared[I].DBName := DBName;
        Inc(DataBaseShared[fSharedDBIndex].Count);
        Break;
      end;
    end;
    if fSharedDBIndex = -1 then begin
      SetLength(DataBaseShared, length(DataBaseShared) + 1);
      fSharedDBIndex := High(DataBaseShared);

      DataBaseShared[fSharedDBIndex].DBName := DBName;
    end;
    if DataBaseShared[fSharedDBIndex].DBHandle = 0 then begin
      ParamsStr := #1#28 + AnsiChar(length(User)) + AnsiString(User) + #29 + AnsiChar(length(Password)) +
        AnsiString(Password);
      for I := 1 to length(ParamsStr) do begin
        Params[I - 1] := ParamsStr[I];
      end;
      if isc_attach_database(@fStatusVector, length(DBName), PAnsiChar(DBName), @fDBHandle, length(ParamsStr), Params) <> 0
      then begin
        CheckAPICall(@fStatusVector);
      end;

      DataBaseShared[fSharedDBIndex].Count := 1;
      DataBaseShared[fSharedDBIndex].DBHandle := fDBHandle;
    end;
  end
  else begin
    if Connected then begin
      if (fSharedDBIndex <= High(DataBaseShared)) and (fSharedDBIndex >= Low(DataBaseShared)) then begin
        if InTransaction then begin
          CommitTransaction;
        end;
        Dec(DataBaseShared[fSharedDBIndex].Count);
        if DataBaseShared[fSharedDBIndex].Count = 0 then begin
          DataBaseShared[fSharedDBIndex].DBName := '';
          DataBaseShared[fSharedDBIndex].DBHandle := 0;
          if isc_detach_database(@fStatusVector, @fDBHandle) <> 0 then begin
            CheckAPICall(@fStatusVector);
          end;
          FreeLibrary(fDLLHandle);
          fDLLHandle := 0;
        end;
      end;
    end;
  end;
end;

procedure TRawFB.SetRecordSetIndex(const Value: Integer);
begin
  while (Value > fRecordsFetched) and (not(EOF)) do begin
    Fetch;
  end;
  fRecordSetIndex := Value;
  PutCurrentRecord;
end;

procedure TRawFB.SQLExecute;
var
  I: Integer;
  InternalSQL: AnsiString;
  Buffer: array[0..16384] of Byte;

  STInfo: packed record
    InfoCode: Byte;
    InfoLen: Word;
    InfoType: TGenericStatementType;
    Filler: Byte;
  end;

  InfoData: packed record
    InfoCode: byte;
    InfoLen: Word;
    Infos: packed array[0..3] of record
      InfoCode: byte;
      InfoLen: Word;
      Rows: Cardinal;
    end;
    Filler: Word;
  end;

  InfoIn: Byte;
  In_DA: PXSQLDA;
begin
  fLastExecutedSQLType:= stNone;
  // FreeMem(fDataBuffer, fDataBufferLen);
  if fDataBuffer <> nil then begin
    FreeMem(fDataBuffer, fDataBufferLen);
    fDataBuffer := nil;
  end;

  SetLength(fInternalRecordSet, 0);
  Finalize(fInternalRecordSet);
  fInternalRecordSet := nil;

  fRecordsFetched := 0;
  fRecordSetIndex := -1;
  fInternalEOF := False;

  FreeStatement;

  if Not(InTransaction) then begin
    StartTransaction;
  end;

  ProcessParams;
  if Params.Count > 0 then begin
    ExecuteImmediate(SQL.Text);
  end
  else begin
    if isc_dsql_alloc_statement2(@fStatusVector, @fDBHandle, @fStmtHandle) <> 0 then
      CheckAPICall(@fStatusVector);

    //if isc_dsql_allocate_statement(@fStatusVector, @fDBHandle, @fStmtHandle) <> 0 then
    //  CheckAPICall(@fStatusVector);

    fFields := 1;
    GetMem(Out_DA, XSQLDA_LENGTH(fFields));
    Out_DA.sqln := fFields;
    Out_DA.sqld := fFields;
    Out_DA.version := 1;

    InternalSQL := SQL.Text;
    if isc_dsql_prepare(@fStatusVector, @fTransHandle, @fStmtHandle, length(InternalSQL), PAnsiChar(InternalSQL), 3,
      Out_DA) <> 0 then
      CheckAPICall(@fStatusVector);

    // Plan
    fPlan:= '';
    InfoIn:= isc_info_sql_get_plan;
    if isc_dsql_sql_info(@fStatusVector, @fStmtHandle, 1, @InfoIn, SizeOf(Buffer), @Buffer) <> 0 then
      CheckAPICall(@fStatusVector);

    fPlan:= Trim(String(PAnsiChar(@Buffer[3])));

    InfoIn := isc_info_sql_stmt_type;

    isc_dsql_sql_info(@fStatusVector, @fStmtHandle, 1, @InfoIn, SizeOf(STInfo), @STInfo);
    Dec(STInfo.InfoType);
    fLastExecutedSQLType:= STInfo.InfoType;

    fFields := Out_DA.sqld;
    ReallocMem(Out_DA, XSQLDA_LENGTH(fFields));
    Out_DA.sqln := fFields;
    Out_DA.sqld := fFields;
    Out_DA.version := 1;

    if isc_dsql_describe(@fStatusVector, @fStmtHandle, 1, Out_DA) <> 0 then
      CheckAPICall(@fStatusVector);

    AllocateDataBuffer(Out_DA);

    if STInfo.InfoType = stExecProcedure then begin
      GetMem(In_DA, XSQLDA_LENGTH(fFields));
      In_DA := Out_DA;

      if isc_dsql_execute2(@fStatusVector, @fTransHandle, @fStmtHandle, 3, In_DA, Out_DA) <> 0 then begin
        CheckAPICall(@fStatusVector);
      end;
    end
    else begin
      if isc_dsql_execute(@fStatusVector, @fTransHandle, @fStmtHandle, 3, nil) <> 0 then begin
        CheckAPICall(@fStatusVector);
      end;
    end;
    if {(fLastExecutedSQLType = stSelect) or }(fLastExecutedSQLType = stSelectForUpdate) then begin
      if isc_dsql_set_cursor_name( @fStatusVector, @fStmtHandle, PAnsiChar( 'T' + IntToStr( fTransHandle ) ), 0 ) <> 0 then begin
        CheckAPICall(@fStatusVector);
      end;
    end;

    // Rows affected
    fInsertsAffected:= 0;
    fUpdatesAffected:= 0;
    fDeletesAffected:= 0;

    InfoIn:= isc_info_sql_records;
    if isc_dsql_sql_info(@fStatusVector, @fStmtHandle, 1, @InfoIn, SizeOf(InfoData), @InfoData) <> 0 then
      CheckAPICall(@fStatusVector);

    for InfoIn := 0 to 3 do
      with InfoData.Infos[InfoIn] do
      case InfoCode of
        isc_info_req_insert_count: fInsertsAffected:= Rows;
        isc_info_req_update_count: fUpdatesAffected:= Rows;
        isc_info_req_delete_count: fDeletesAffected:= Rows;
      end;

    // Log
    Log( InternalSQL );

    if fFields > 0 then begin
      SetLength(fFieldNames, fFields);
      SetLength(fFieldNamesInDB, fFields);
      for I := Low(fFieldNames) to High(fFieldNames) do begin
        // fFieldNames[ I ]:= Copy(Out_DA.sqlvar[ I ].SqlName, 1, Out_DA.sqlvar[ I ].SqlNameLength );
        fFieldNames[I] := Copy(Out_DA.sqlvar[I].AliasName, 1, Out_DA.sqlvar[I].AliasNameLength);
        fFieldNamesInDB[I] := Copy(Out_DA.sqlvar[I].SqlName, 1, Out_DA.sqlvar[I].SqlNameLength);
      end;

      if STInfo.InfoType = stExecProcedure then begin
        if length(fInternalRecordSet) < 1 then begin
          SetLength(fInternalRecordSet, 1);
        end;
        fInternalRecordSet[0] := '';
        for I := 0 to Out_DA.sqld - 1 do begin
          fInternalRecordSet[0] := fInternalRecordSet[0] + InternalGetField(I) + FieldSep;
        end;
        fRecordSetIndex:= 0;
        PutCurrentRecord;
      end
      else begin
        Fetch;
      end;
    end;
  end;
end;

procedure TRawFB.SQLsExecute(SQLs: TStringList; SQLSeparator: Char);
var SQLList: TArray<String>;
    I: Integer;
begin
  SQLList:= RawGenericSplit( SQLs.Text, SQLSeparator );
  if InTransaction then begin
    CommitTransaction;
  end;
  StartTransaction;
  for I := Low(SQLList) to High(SQLList) do begin
    SQL.Text:= SQLList[ I ];
    SQLExecute;
  end;
  if InTransaction then begin
    CommitTransaction;
  end;
end;

procedure TRawFB.StartTransaction;
var
  Vector: TISC_TEB;
begin
  Vector.Handle := @fDBHandle;
  Vector.Len := 0;
  Vector.Address := nil;

  if isc_start_multiple(@fStatusVector, @fTransHandle, 1, @Vector) <> 0 then begin
    CheckAPICall(@fStatusVector);
  end;
end;

procedure TRawFB.BlobField(FieldName: String; AStream: TStream);
var
  Values: String;
  AISCQuad: TISCQuad;
  BlobHandle: TISC_BLOB_HANDLE;

  BlobInfos: array [0 .. 2] of TBlobInfo;
begin
  Values := Field[FieldName];
  if (Copy(Values, 1, 5) = 'Blob<') and (Copy(Values, Values.length, 1) = '>') and (Pos(':', Values) > 0) then begin
    Values := Copy(Values, 6, Values.length - 6);
    AISCQuad.gds_quad_high := StrToInt(Copy(Values, 1, Pos(':', Values) - 1));
    AISCQuad.gds_quad_low := StrToInt(Copy(Values, Pos(':', Values) + 1, 255));
    BlobHandle := 0;
    if (isc_open_blob2(@fStatusVector, @fDBHandle, @fTransHandle, @BlobHandle, @AISCQuad, 0, nil)) <> 0 then begin
      CheckAPICall(@fStatusVector);
    end
    else begin
      if isc_blob_info(@fStatusVector, @BlobHandle, 2, isc_info_blob_max_segment + isc_info_blob_total_length,
        SizeOf(BlobInfos), @BlobInfos) <> 0 then begin
        CheckAPICall(@fStatusVector);
      end;

      BlobSaveToStream(BlobHandle, AStream);
    end;
  end;
end;

function TRawFB.BlobGetSegment(var BlobHandle: TISC_BLOB_HANDLE; out length: Word; BufferLength: Cardinal;
  Buffer: Pointer): Boolean;
var
  AStatus: ISC_STATUS;
begin
  if BufferLength > High(Word) then
    BufferLength := High(Word);
  AStatus := isc_get_segment(@fStatusVector, @BlobHandle, @length, Word(BufferLength), Buffer);
  Result := (AStatus = 0) or (fStatusVector[1] = isc_segment);
  if not Result then
    if (fStatusVector[1] <> isc_segstr_eof) then begin
      CheckAPICall(@AStatus);
    end;
end;

procedure TRawFB.BlobSaveToStream(var BlobHandle: TISC_BLOB_HANDLE; Stream: TStream);
var
  BlobInfos: array [0 .. 2] of TBlobInfo;
  Buffer: Pointer;
  CurrentLength: Word;
begin
  if (isc_blob_info(@fStatusVector, @BlobHandle, 2, isc_info_blob_max_segment + isc_info_blob_total_length,
    SizeOf(BlobInfos), @BlobInfos)) <> 0 then begin
    CheckAPICall(@fStatusVector);
  end;

  Stream.Seek(0, soFromBeginning);
  GetMem(Buffer, BlobInfos[0].CardType);
  try
    while BlobGetSegment(BlobHandle, CurrentLength, BlobInfos[0].CardType, Buffer) do
      Stream.Write(Buffer^, CurrentLength);
  finally
    FreeMem(Buffer);
  end;
  Stream.Seek(0, soFromBeginning);
end;

procedure TRawFB.BlobWriteSegment(var BlobHandle: TISC_BLOB_HANDLE; BufferLength: Cardinal; Buffer: Pointer);
var
  Size: Word;
begin
  while BufferLength > 0 do begin
    if BufferLength > fSegmentSize then
      Size := fSegmentSize
    else
      Size := Word(BufferLength);

    if isc_put_segment(@fStatusVector, @BlobHandle, Size, Buffer) <> 0 then begin
      CheckAPICall(@fStatusVector);
    end;
    Dec(BufferLength, Size);
    Inc(PByte(Buffer), Size);
  end;
end;

procedure TRawFB.BlobWriteStream(var BlobHandle: TISC_BLOB_HANDLE; Stream: TStream);
var
  Buffer: Pointer;
begin
  Stream.Seek(0, soFromBeginning);
  if Stream is TCustomMemoryStream then
    BlobWriteSegment(BlobHandle, Cardinal(TCustomMemoryStream(Stream).Size), TCustomMemoryStream(Stream).Memory)
  else

  begin
    GetMem(Buffer, Cardinal(Stream.Size));
    try
      Stream.Read(Buffer^, Cardinal(Stream.Size));
      BlobWriteSegment(BlobHandle, Cardinal(Stream.Size), Buffer);
      Stream.Seek(0, soFromBeginning);
    finally
      FreeMem(Buffer);
    end;
  end;
end;

{ TRawFBParams }

procedure TRawFBParams.Clear;
begin
  SetLength(fNamesArray, 0);
  SetLength(fStreamsArray, 0);
end;

constructor TRawFBParams.Create;
begin
  inherited;

  Clear;
end;

destructor TRawFBParams.Destroy;
begin
  Clear;

  inherited;
end;

function TRawFBParams.GetCount: Integer;
begin
  Result := length(fNamesArray);
end;

function TRawFBParams.GetIndexByName(Name: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  Name := UpperCase(Name);
  for I := Low(fNamesArray) to High(fNamesArray) do begin
    if UpperCase(fNamesArray[I]) = Name then begin
      Result := I;
      Break;
    end;
  end;
end;

function TRawFBParams.GetISCQuadByName(Name: String): TISCQuad;
var
  Idx: Integer;
begin
  Idx := GetIndexByName(Name);
  if Idx <> -1 then begin
    Result := fISCQuadArray[Idx];
  end
  else begin
    Result.gds_quad_high := 0;
    Result.gds_quad_low := 0;
  end;
end;

function TRawFBParams.GetName(Idx: Integer): String;
begin
  Result := fNamesArray[Idx];
end;

function TRawFBParams.GetParamTypeByName(Name: String): TParamType;
var
  Idx: Integer;
begin
  Idx := GetIndexByName(Name);
  if Idx <> -1 then begin
    Result := fParamTypeArray[Idx];
  end
  else begin
    Result := ptUnknown;
  end;
end;

function TRawFBParams.GetStreamByName(Name: String): TStream;
var
  Idx: Integer;
begin
  Idx := GetIndexByName(Name);
  if Idx <> -1 then begin
    Result := fStreamsArray[Idx];
  end
  else begin
    Result := nil;
  end;
end;

procedure TRawFBParams.SetISCQuadByName(Name: String; const Value: TISCQuad);
var
  Idx: Integer;
begin
  Idx := GetIndexByName(Name);
  if Idx = -1 then begin
    SetLengthOfArrays(length(fNamesArray) + 1);
    Idx := High(fNamesArray);
    fNamesArray[Idx] := Name;
  end;
  fISCQuadArray[Idx] := Value;
  if Name = 'DBKEY' then
    fParamTypeArray[Idx] := ptDBKEY
  else
    fParamTypeArray[Idx] := ptBlob;
end;

procedure TRawFBParams.SetLengthOfArrays(NewLength: Integer);
begin
  SetLength(fStreamsArray, NewLength);
  SetLength(fNamesArray, NewLength);
  SetLength(fParamTypeArray, NewLength);
  SetLength(fISCQuadArray, NewLength);
end;

procedure TRawFBParams.SetName(Idx: Integer; const Value: String);
begin
  fNamesArray[Idx] := Value;
end;

procedure TRawFBParams.SetStreamByName(Name: String; const Value: TStream);
var
  Idx: Integer;
begin
  Idx := GetIndexByName(Name);
  if Idx = -1 then begin
    SetLengthOfArrays(length(fNamesArray) + 1);
    Idx := High(fNamesArray);
    fNamesArray[Idx] := Name;
    fParamTypeArray[Idx] := ptBlob;
  end;
  fStreamsArray[Idx] := Value;
end;

end.