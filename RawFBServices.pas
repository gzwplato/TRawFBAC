// TRawFBServices - Clase para acceder a servicios de Firebird en pelo
// 2016 Luciano Olocco
// lolocco@gmail.com

unit RawFBServices;

interface

uses RawFBUtils, RawFB,
     System.SysUtils, System.Classes, Winapi.Windows;

type
  TRawFBServices = class
  private
    { Private declarations }
    fInternalRawFB: TRawFB;

    fStatusVector: ISC_STATUS_VECTOR;
    fDBHandle: THandle;

    fFBLibrary: string;
    fUser: String;
    fPassword: String;
    fHost: String;
    fPort: Integer;
    fServiceHandle: isc_svc_handle;
    fSPB: array [0..128] of AnsiChar;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    property FBLibrary: String read fFBLibrary write fFBLibrary;
    property User: String read fUser write fUser;
    property Password: String read fPassword write fPassword;
    property Host: String read fHost write fHost;
    property Port: Integer read fPort write fPort;
    function Attach: Boolean;
    function Detach: Boolean;
    procedure StartBackup( FDBFile, FBKFile: String );
    procedure StartRestore( FBKFile, FDBFile: String );
    function GetNextLine(out ALine: String): Boolean;
  end;

implementation


{ TRawFBServices }

function TRawFBServices.Attach: Boolean;
var ServiceName: AnsiString;
    I, Count: Integer;
begin
  Result:= False;
  if Not(Assigned( fInternalRawFB )) then begin
    fInternalRawFB:= TRawFB.Create;
    fInternalRawFB.FBLibrary:= fFBLibrary;
    fInternalRawFB.LoadFunctions;
  end;
  fSPB[0]:= AnsiChar(isc_spb_version);
  fSPB[1]:= AnsiChar(isc_spb_current_version);
  fSPB[2]:= AnsiChar(isc_dpb_user_name);
  fSPB[3]:= AnsiChar(fUser.Length);
  for I:= 1 to fUser.Length do begin
    fSPB[I + 3]:= AnsiChar(fUser[ I ]);
  end;
  Count:= I + 3;
  fSPB[Count]:= AnsiChar(isc_dpb_password);
  fSPB[Count + 1]:= AnsiChar(fPassword.Length);
  for I:= 1 to fPassword.Length do begin
    fSPB[Count + I + 1]:= AnsiChar(fPassword[ I ]);
  end;
  Count:= Count + I + 1;

  ServiceName:= AnsiString(fHost) + ':service_mgr';
  if isc_service_attach(@fStatusVector, Length(ServiceName), PAnsiChar(ServiceName), @fServiceHandle, Count, fSPB) <> 0 then begin
    CheckAPICall(@fStatusVector);
  end
  else begin
    Result:= True;
  end;
end;

constructor TRawFBServices.Create;
begin
  Inherited;
  fFBLibrary := '';
  fUser := 'SYSDBA';
  fPassword := 'masterkey';
  fHost := 'localhost';
end;

destructor TRawFBServices.Destroy;
begin
  if Assigned( fInternalRawFB ) then begin
    fInternalRawFB.Free;
  end;

  inherited;
end;

function TRawFBServices.Detach: Boolean;
begin
  Result:= False;
  if isc_service_detach(@fStatusVector, @fServiceHandle) <> 0 then begin
    CheckAPICall(@fStatusVector);
  end
  else begin
    Result:= True;
  end;
end;

function TRawFBServices.GetNextLine(out ALine: String): Boolean;
var SendSpb, RequestSpb, Buffer: RawByteString;
    Len: Integer;
begin
  SendSpb:= '';
  RequestSpb:= isc_info_svc_line;
  Buffer:= '';

  Result:= False;
  try
    SetLength(Buffer, 1024);
    if isc_service_query(@fStatusVector, @fServiceHandle, nil, Length(SendSpb), PAnsiChar(SendSpb), Length(RequestSpb), PAnsiChar(RequestSpb), Length(Buffer), PAnsiChar(Buffer)) <> 0 then begin
      CheckAPICall(@fStatusVector);
    end
    else begin
      Result:= True;

      if (Buffer[1] = isc_info_svc_line) then begin
        Len := PWord(@Buffer[2])^;
        if len > 0 then begin
          ALine:= (Copy(Buffer, 4, Len));
        end
        else begin
          Result:= False;
        end;
      end;
    end;
  except
    Result:= False;
  end;
end;

procedure TRawFBServices.StartBackup(FDBFile, FBKFile: String);
var Thd: RawByteString;
begin
  Thd:= isc_action_svc_backup;

  Thd:= Thd + isc_spb_dbname;
  Thd:= Thd + Char(Length(FDBFile));
  Thd:= Thd + Char(Length(FDBFile) shr 8);
  Thd:= Thd + FDBFile;

  Thd:= Thd + isc_spb_bkp_file;
  Thd:= Thd + Char(Length(FBKFile));
  Thd:= Thd + Char(Length(FBKFile)shr 8);
  Thd:= Thd + FBKFile;

  Thd:= Thd + isc_spb_verbose;
  if isc_service_start(@fStatusVector, @fServiceHandle, nil, Length(Thd), PAnsiChar(Thd)) <> 0 then begin
    CheckAPICall(@fStatusVector);
  end;
end;

procedure TRawFBServices.StartRestore(FBKFile, FDBFile: String);
var Thd: RawByteString;
begin
  Thd:= isc_action_svc_restore;

  Thd:= Thd + isc_spb_dbname;
  Thd:= Thd + Char(Length(FDBFile));
  Thd:= Thd + Char(Length(FDBFile) shr 8);
  Thd:= Thd + FDBFile;

  Thd:= Thd + isc_spb_bkp_file;
  Thd:= Thd + Char(Length(FBKFile));
  Thd:= Thd + Char(Length(FBKFile)shr 8);
  Thd:= Thd + FBKFile;

  Thd:= Thd + isc_spb_verbose;
  if isc_service_start(@fStatusVector, @fServiceHandle, nil, Length(Thd), PAnsiChar(Thd)) <> 0 then begin
    CheckAPICall(@fStatusVector);
  end;
end;

end.
