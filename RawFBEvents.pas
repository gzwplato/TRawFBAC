// TRawFBEvents - Clase para acceder a eventos de Firebird en pelo
// 2016 Luciano Olocco
// lolocco@gmail.com

unit RawFBEvents;

interface

uses RawFB, RawFBUtils,
     System.SysUtils, System.Classes, Winapi.Windows;

type
  TRawFBEventThreadEvent = Procedure (Sender: TObject; const EventName: AnsiString; Count: Integer) of object;

type
  TRawFBEvents = class  // (TThread)
  private
    { Private declarations }
    fInternalRawFB: TRawFB;

    fStatusVector: ISC_STATUS_VECTOR;
    fDBHandle: THandle;
    
    fFBLibrary: string;
    fUser: String;
    fPassword: String;
    fHost: String;
    fDatabaseFile: String;
    fPort: Integer;

    fEventList: String;

    fOnEvent: TRawFBEventThreadEvent;
    fEventCallBack: ISC_EVENT_CALLBACK;

    procedure RawFBEventCallback(user_data: Pointer; length: ISC_USHORT; const updated: PAnsiChar); stdcall;
    procedure QueryEvents(var ID: Integer; Length: Word; Events: NativeInt; AST: IntPtr; Arg: Pointer);
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    property FBLibrary: String read fFBLibrary write fFBLibrary;
    property User: String read fUser write fUser;
    property Password: String read fPassword write fPassword;
    property Host: String read fHost write fHost;
    property Port: Integer read fPort write fPort;
    property DatabaseFile: String read fDatabaseFile write fDatabaseFile;

    property EventCallBack: ISC_EVENT_CALLBACK read fEventCallBack write fEventCallBack;

    property OnEvent: TRawFBEventThreadEvent read fOnEvent write fOnEvent;

    procedure AddEvent( EventName: String );
    procedure StartListening;
    procedure StopListening;
end;

implementation

{ TRawFBEvents }


procedure TRawFBEvents.AddEvent(EventName: String);
begin
  EventName:= UpperCase( EventName );
  if Pos( ',' + EventName + ',', fEventList ) = 0 then begin
    fEventList:= fEventList + ',' + EventName + ',';
  end;
end;

constructor TRawFBEvents.Create;
begin
  inherited;

  fEventList:= '';
end;

destructor TRawFBEvents.Destroy;
begin
  //

  inherited;
end;

procedure TRawFBEvents.QueryEvents(var ID: Integer; Length: Word; Events: NativeInt; AST: IntPtr; Arg: Pointer);
begin
  //
end;

procedure TRawFBEvents.RawFBEventCallback(user_data: Pointer; length: ISC_USHORT; const updated: PAnsiChar); stdcall;
begin
  if Assigned( fOnEvent ) then begin
    fOnEvent( Self, '', 0 );
  end;
end;

procedure TRawFBEvents.StartListening;
var EventBufferLen: SmallInt;
    EventBuffer: PAnsiChar;
    ResultBuffer: PAnsiChar;
    StrArray, VArray: TArray<String>;
    EventID: Integer;
    I: Integer;
    J: Word;

    Callback: NativeInt;
begin
  if (fDBHandle = 0) then begin
    fInternalRawFB:= TRawFB.Create;

    fInternalRawFB.FBLibrary:= fFBLibrary;
    fInternalRawFB.User:= fUser;
    fInternalRawFB.Password:= fPassword;
    fInternalRawFB.Host:= fHost;
    fInternalRawFB.Port:= fPort;
    fInternalRawFB.DatabaseFile:= fDatabaseFile;
    try
      fInternalRawFB.Connect;
    except
      //
    end;
    fDBHandle:= fInternalRawFB.DBHandle;

    StrArray:= fEventList.Split( [','] );
    SetLength( VArray, 15 );
    J:= 0;
    for I:= Low(StrArray) to High(StrArray) do begin
      if (StrArray[ I ] <> '') and (J <= 14) then begin
        VArray[ J ]:= StrArray[ I ];
        Inc( J );
      end;
    end;

    //fEventCallBack:= Pointer(RawFBEventCallback);
    EventBufferLen:= isc_event_block(@EventBuffer, @ResultBuffer, J, PAnsiChar(VArray[0]), PAnsiChar(VArray[1]),
        PAnsiChar(VArray[2]), PAnsiChar(VArray[3]), PAnsiChar(VArray[4]), PAnsiChar(VArray[5]),
        PAnsiChar(VArray[6]), PAnsiChar(VArray[7]), PAnsiChar(VArray[8]), PAnsiChar(VArray[9]),
        PAnsiChar(VArray[10]), PAnsiChar(VArray[11]), PAnsiChar(VArray[12]), PAnsiChar(VArray[13]), PAnsiChar(VArray[14]));

    //fEventCallBack:= RawFBEventCallback;
    //QueryEvents( EventID, EventBufferLen, EventBuffer, @RawFBEventCallback, Self );
    //QueryEvents( EventID, EventBufferLen, EventBuffer, @fEventCallback, Self );
    if isc_que_events(@fStatusVector, @fDBHandle, @EventId, EventBufferLen, PAnsiChar(EventBuffer), TISC_CALLBACK(@EventCallback), PVoid(Self)) <> 0 then begin
      CheckAPICall( @fStatusVector );
    end;

    //QueryEvents( EventID, EventBufferLen, EventBuffer, @fEventCallback, Self );

  end;


end;

procedure TRawFBEvents.StopListening;
begin
  fInternalRawFB.Connected:= False;
end;

end.
