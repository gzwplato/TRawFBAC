// 2017 Luciano Olocco
// Email: lolocco@gmail.com

unit RawFBACEvents;

interface

uses Lucho, System.Classes, INIFiles, System.SysUtils, Vcl.Forms, IBC, IBCAlerter;

type
   TFirebirdEvent = procedure(Sender: TObject; EventName: string; EventCount: Integer) of object;

type TRawFBACEvents = class(TObject)
  private
    { Private declarations }
    fDBAlerter: TIBCAlerter;
    fFirebirdEvent: TFirebirdEvent;
    fINI: TIniFile;

    fHost: String;
    fDBFilename: String;

    procedure DBAlerterEvent(Sender: TObject; EventName: string; EventCount: Integer);
    function DBFilename: String;
    function DBHost: String;
    function ReadStringAndResolve(const Section, Ident, Default: String): String;
    function GetFirebirdEvent: TFirebirdEvent;
    procedure SetFirebirdEvent(const Value: TFirebirdEvent);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; INIFileName: String; FDBHostAndFile: String = '');
    destructor Destroy;
    procedure AddEvent(EventName: String);
    procedure SendEvent(EventName: String);
    property OnFirebirdEvent: TFirebirdEvent read GetFirebirdEvent write SetFirebirdEvent;
end;

implementation

var fConnection: TIBCConnection;

{ TRawFBACEvents }

constructor TRawFBACEvents.Create(AOwner: TComponent; INIFileName, FDBHostAndFile: String);
begin
  if INIFileName = '' then begin
    INIFileName:= ChangeFileExt( Application.ExeName, '.ini' );
  end;

  if (Pos( ':\', INIFileName ) = 0) and (Pos( '\\', INIFileName ) = 0) and (Not(INIFileName.StartsWith( '/' ))) then begin
    INIFileName:= IncludeTrailingPathDelimiter( ExtractFilePath( Application.ExeName ) ) + INIFileName;
  end;

  if (INIFileName <> '') and (FileExists( INIFileName )) then begin
    fINI:= TINIFile.Create( INIFileName );
  end;

  if (FDBHostAndFile = '') then begin
    FDBHostAndFile:= DBHost + ':' + DBFilename;
  end;
  fHost:= Copy( FDBHostAndFile, 1, Pos( ':', FDBHostAndFile ) - 1 );
  fDBFilename:= Copy( FDBHostAndFile, Pos( ':', FDBHostAndFile ) + 1, 255 );

  try
    if Not(Assigned(fConnection)) then begin
      fConnection:= TIBCConnection.Create( AOwner );
      fConnection.Server:= fHost;
      fConnection.Database:= fDBFilename;

      fConnection.UserName:= 'SYSDBA';
      fConnection.PassWord:= 'masterkey';
      fConnection.Connect;
    end;
  except

  end;

  fDBAlerter:= TIBCAlerter.Create( AOwner );
  fDBAlerter.Connection:= fConnection;
  fDBAlerter.OnEvent:= DBAlerterEvent;
  fDBAlerter.Active:= (fDBAlerter.Events.Count > 0);
end;

destructor TRawFBACEvents.Destroy;
begin
  if Assigned( fINI ) then begin
    fINI.Free;
  end;
  fDBAlerter.Free;
  fConnection.Free;
end;

function TRawFBACEvents.GetFirebirdEvent: TFirebirdEvent;
begin
  Result:= fFirebirdEvent;
end;

procedure TRawFBACEvents.DBAlerterEvent(Sender: TObject; EventName: string; EventCount: Integer);
begin
  if Assigned(fFirebirdEvent) then
    fFirebirdEvent( Self, EventName, EventCount );
end;

function TRawFBACEvents.DBFilename: String;
begin
  Result:= ReadStringAndResolve( 'General', 'Database', '' );
end;

function TRawFBACEvents.DBHost: String;
begin
  Result:= ReadStringAndResolve( 'General', 'Host', 'localhost' );
end;

function TRawFBACEvents.ReadStringAndResolve(const Section, Ident, Default: String): String;
var AData: String;
    AHostData: StringArray;
    AINI: TINIFile;
begin
  AData:= fINI.ReadString( Section, Ident, Default );
  AData:= ResolveString( AData );

  if (StringStartWith( AData, '{' )) and (AData <> '{}') then begin
    AData:= Copy( AData, 2, Length(AData) - 2 );
    AHostData:= Split( AData, ':' );

    AINI:= TIniFile.Create( IncludeTrailingPathDelimiter( ExtractFilePath( fINI.FileName )) + AHostData[ 0 ] );
    Result:= AINI.ReadString( AHostData[ 1 ], AHostData[ 2 ], Default );
    AINI.Free;
  end
  else begin
    if AData = '{}' then begin
      Result:= Default;
    end
    else begin
      Result:= AData;
    end;
  end;
  Result:= ResolveString( Result );
end;

procedure TRawFBACEvents.SendEvent(EventName: String);
begin
  fDBAlerter.SendEvent( EventName );
end;

procedure TRawFBACEvents.SetFirebirdEvent(const Value: TFirebirdEvent);
begin
  fFirebirdEvent:= Value;
end;

procedure TRawFBACEvents.AddEvent(EventName: String);
begin
  if fDBAlerter.Events.IndexOf( EventName ) = -1 then begin
    fDBAlerter.Active:= False;
    fDBAlerter.Events.Add( EventName );
    fDBAlerter.Active:= True;
  end;
end;

end.

