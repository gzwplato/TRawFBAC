// Clase para guardar configuraciones usando TFirebird
// 2015 Luciano Olocco
// Email: lolocco@gmail.com

unit INIInFDB;

interface

uses ClipBrd,
     Lucho, RawFBAC, CryptHexa,
     MD5, {ULogIn, }IdCoder, IdCoder3to4, IdCoderMIME, IdBaseComponent,
     Winapi.Windows, System.SysUtils, Vcl.Controls, Vcl.Forms, System.Classes;

type TINIInFDB = class(TObject)
  private
    { Private declarations }
    Parent: TComponent;
  public
    { Public declarations }
    fInternalTable: TRawFBAC;
    constructor Create(AOwner: TComponent; INIFileName: String);
    destructor Destroy; override;

    function GetString(APC, AFile, ASection, AIdent: String): String; overload;
    function GetString(AFile, ASection, AIdent: String): String; overload;
    function GetStringCrypt(APC, AFile, ASection, AIdent: String): String; overload;
    function GetStringCrypt(AFile, ASection, AIdent: String): String; overload;
    function GetSectionArray(APC, AFile, ASection: String): StringArray; overload;
    function GetSectionArray(AFile, ASection: String): StringArray; overload;


    procedure SetString(APC, AFile, ASection, AIdent, AValue: String); overload;
    procedure SetString(AFile, ASection, AIdent, AValue: String); overload;
    procedure SetStringCrypt(APC, AFile, ASection, AIdent, AValue: String); overload;
    procedure SetStringCrypt(AFile, ASection, AIdent, AValue: String); overload;
end;

implementation

{ TINIInFDB }

constructor TINIInFDB.Create(AOwner: TComponent; INIFileName: String);
var P: String;
    SL: TStringList;
begin
  Parent:= AOwner;

  SL:= TStringList.Create;
  SL.Clear;
  SL.Add( '[InternalSysCfg]' );
  SL.Add( 'Title=Configuración interna' );
  SL.Add( 'Generator=INTERNALSYSCFG_NUMERO_GEN' );
  SL.Add( 'Indices=NUMERO' );
  SL.Add( 'Default4Browse=FFile' );
  SL.Add( 'Fields4Browser=FPC,FFile,FSection,FIdent' );
  SL.Add( '[InternalSysCfg-F]' );
  SL.Add( 'NUMERO=Número,UK' );
  SL.Add( 'FPC=PC,ST,255' );
  SL.Add( 'FFILE=File,ST,255' );
  SL.Add( 'FSECTION=Section,ST,255' );
  SL.Add( 'FIDENT=Ident,ST,255' );
  SL.Add( 'FVALUE=Value,ST,5000' );

  fInternalTable:= TRawFBAC.Create( Parent, '', INIFileName );
  fInternalTable.AddInfoToINI( SL );
  SL.Free;

  fInternalTable.Table:= 'InternalSysCfg';
end;

destructor TINIInFDB.Destroy;
begin
  fInternalTable.Free;

  inherited;
end;

function TINIInFDB.GetString(APC, AFile, ASection, AIdent: String): String;
var AStr: String;
begin
  AStr:= 'fPC=' + APC + ',fFile=' + AFile + ',fSection=' + ASection + ',fIdent=' + AIdent;
  if fInternalTable.CreateRecordSetAndCount( AStr, '*' ) = 1 then begin
    Result:= fInternalTable.Field[ 'fValue' ];
  end
  else begin
    Result:= '';
  end;
  fInternalTable.CommitTransaction;
end;

function TINIInFDB.GetSectionArray(APC, AFile, ASection: String): StringArray;
var AStr: String;
    I: Integer;
begin
  AStr:= 'fPC=' + APC + ',fFile=' + AFile + ',fSection=' + ASection;
  if fInternalTable.CreateRecordSetAndCount( AStr, '*' ) >= 1 then begin
    SetLength( Result, fInternalTable.RecordCount );
    for I := 0 to fInternalTable.RecordCount - 1 do begin
      Result[ I ]:= fInternalTable.Field[ 'fValue' ];
      fInternalTable.NextRecord;
    end;
  end
  else begin
    SetLength( Result, 0 );
  end;
  fInternalTable.CommitTransaction;
end;

function TINIInFDB.GetSectionArray(AFile, ASection: String): StringArray;
begin
  Result:= GetSectionArray( GetComputerNameStr, AFile, ASection );
end;

function TINIInFDB.GetString(AFile, ASection, AIdent: String): String;
begin
  Result:= GetString( GetComputerNameStr, AFile, ASection, AIdent );
end;

function TINIInFDB.GetStringCrypt(APC, AFile, ASection, AIdent: String): String;
var AStr: String;
begin
  Result:= '';
  AStr:= GetString( APC, AFile, ASection, AIdent );
  if AStr <> '' then begin
    AStr:= DecryptStr( AStr, 6891 );
    if StringStartWith( AStr, AIdent ) then begin
      Result:= Copy( AStr, AIdent.Length + 1, AStr.Length );
    end;
  end;
end;

function TINIInFDB.GetStringCrypt(AFile, ASection, AIdent: String): String;
begin
  Result:= GetStringCrypt( '', AFile, ASection, AIdent );
end;

procedure TINIInFDB.SetString(APC, AFile, ASection, AIdent, AValue: String);
var AStr: String;
begin
  AStr:= 'fPC=' + APC + ',fFile=' + AFile + ',fSection=' + ASection + ',fIdent=' + AIdent;
  fInternalTable.ShowDeleted:= True;
  if fInternalTable.CreateRecordSetAndCount( AStr , '*' ) = 0 then begin
    fInternalTable.InitRecord;
  end;
  fInternalTable.Field[ 'fPC' ]:= APC;
  fInternalTable.Field[ 'fFile' ]:= AFile;
  fInternalTable.Field[ 'fSection' ]:= ASection;
  fInternalTable.Field[ 'fIdent' ]:= AIdent;
  fInternalTable.Field[ 'fValue' ]:= AValue;
  fInternalTable.Field[ 'Deleted_FLD' ]:= '0';

  if fInternalTable.RecordCount = 0 then
    fInternalTable.InsertRecord
  else
    fInternalTable.UpDateRecord;

  fInternalTable.CommitTransaction;
  fInternalTable.ShowDeleted:= False;
end;

procedure TINIInFDB.SetString(AFile, ASection, AIdent, AValue: String);
begin
  SetString(GetComputerNameStr, AFile, ASection, AIdent, AValue);
end;

procedure TINIInFDB.SetStringCrypt(APC, AFile, ASection, AIdent, AValue: String);
var AStr: String;
begin
  SetString( APC, AFile, ASection, AIdent, EncryptStr( AIdent + AValue, 6891 ) );
end;

procedure TINIInFDB.SetStringCrypt(AFile, ASection, AIdent, AValue: String);
begin
  SetStringCrypt( '', AFile, ASection, AIdent, AValue );
end;

end.

