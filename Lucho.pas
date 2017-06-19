// 2002-17 - Luciano Olocco
// Email: lolocco@gmail.com
// Archivo de módulos para Delphi

unit Lucho;

interface
uses Types, Forms, SysUtils, INIFiles, ShellAPI, WinAPI.Windows, StrUtils, Registry, ExtCtrls, Graphics,
     Classes, DateUtils, Vcl.Dialogs, Vcl.StdCtrls;

type StringArray = TArray<String>;
type BooleanArray = TBooleanDynArray;
type PHICON = ^HICON;

function FloatToStrExcept(Value: Extended): string;
function StrToFloatExcept(const S: string): Extended;
function CurrencyToStr(C: Real): String;
function StrToCurrency(St: String): Real;
function SacarBlancos(S: String): String;
function CalcularValor(Tex: String): Real;
function TextToReal(Tex:String):Real;
function RealToText(Num: Real): string;
function VolverDir (S: String): String;
function Leer (iniFile :String; iniSection :String; iniEntry :String): String;
procedure Grabar(iniFile :String; iniSection :String; iniEntry :String; iniString :String);
procedure DeleteEntry(iniFile :String; iniSection :String; iniEntry :String);
procedure DeleteSection(iniFile: String; iniSection: String);
function crypt (S: String): string;
function ObtenerPath (S: String): String;
function ObtenerFile (S: String): String;
function Extension (S: String): String;
function GetFilenameWithoutExt(AFilename: String): String;
function LeerCrypt (iniFile :String; iniSection :String; iniEntry :String): String;
Procedure GrabarCrypt(iniFile :String; iniSection :String; iniEntry :String; iniString :String);
function Iif(Expresion: boolean; ParteVerd: String; ParteFalsa: String): String;
function StrToIntCero(St: String): Integer;
function StrToFloatCero(St: String): Extended;
function StrToInt64Cero(St: String): Cardinal;
function CharCount(const S: String; C: Char): Integer;
function Split( Expresion: String; Delimitador: Char; SplitOnQuotes: Boolean = False): StringArray; overload;
function Split( Expresion: String; Delimitador: String; Trim: Boolean = True): StringArray; overload;
function Indice (St: String; const Vector: StringArray): Integer;
function IndiceInt (Int: Integer; const Vector: array of String): String;
function StrToIntExcept(const St: String): Integer;
function MidPath(Path, FullPath: String): String;
procedure CargarIcono(var Imagen: TImage; Tipo: PChar);
function StrToBoolExcept(const S: string): Boolean;
function IniValueCant(iniFile :String; iniSection :String): Integer;
function IniSectionCant(iniFile :String): Integer;
function MezclarBMP(BMP1, BMP2: TImage; Transparencia: Integer): TImage; overload;
function MezclarBMP(BMP1, BMP2: TBitmap; Transparencia: Integer): TBitmap; overload;
function StrIsFloat(St: String): Boolean;
function Space(Cont: Integer; Letra: Char): String;
function Fii(Expresion: String; PartTrue, PartFalse: String; Default: Boolean): Boolean;
function PosAtras( C: Char; S: String): Integer;
function ReplaceString( Text: String; OldC, NewC: Char  ): String;
function QuotedStrCero( St: String ): String;
function ConvertFecha( Fecha: String ): String;
function GetVolumeID(DriveChar: Char): String;
function StrIsInt(St: String): Boolean;
function IsEMail(EMail: string): Boolean;
function EsCUITValido(CUIT: String): Boolean;
function AgregaChar(St: String; Cant: Integer): String;
function AddCharLeft(St: String; Cant: Integer): String;
function StrIsDate(St: String): Boolean;
function StrToDate4TFirebird( St: String ): TDate;
function LstToStr( lst: TStrings; Separator: String ): String;
function IniValues(iniFile :String; iniSection :String): StringArray;
function IniSectionExists(iniFile :String; iniSection :String): Boolean;
function IniSections(INIFile :String): StringArray;
function MatchStrings(Source, Pattern: String): Boolean;
function ArrayToString( Vector: StringArray; Sep: String; Quoted: Boolean ): String;
function StrToBoolCero( St: String ): Boolean;
function StringCase( Selector: string; CaseList: array of string ): Integer;
function Capitalize( St: String ): String;
function FormatStringArray (const Format: string; const Args: StringArray): string;
function MakeComponentName( St: String ): String;
function GetComputerNameStr: String;
function BytesToStr(Bytes: Double): String;
function HexaToBin( Hexadecimal: String ): String;
function BinToHexa( Binario: String ): String;
function ExtractCurrencyValueEx( Value: String ): String;
function ExtractCurrencyValueEx2Ext( Value: String ): Extended;
function IncludeCurrencyValueEx( Value: Extended ): String; overload;
function IncludeCurrencyValueEx( Value: String ): String; overload;
procedure ReplacePartOfString( var St: String; NewSt: String; iFrom, iTo: Integer; FillLeft: Boolean );
procedure ReplacePartOfStringWithTrim( var St: String; NewSt: String; iFrom, iTo: Integer; Trim: Boolean );
function INIEntryExists(iniFile :String; iniSection :String; iniEntry :String): Boolean;
function ReadRegistry( RootKey: Cardinal; Key, Name: String): String;
function FormatDate2SQL( Fecha: String ): String;
function ReadFromConfig( Config, Field: String ): String;
procedure WriteToConfig( Config, Field, Value: String );
function UpperCaseOnlyFirstLetter( St: String ): String;
function GetWindowsDir: String;
function GetSystemDir: String;
function HasParam( Param: String ): Boolean;
function GetParam( Param: String ): String; overload;
function GetParam( Param: String; Separador: String ): String; overload;
function StringLen(Str: String): Integer;
function ListToStr(List: TStringList; Delimeter: String): String;
function FontStyleToStr(FontStyle: TFontStyles): String;
function FontPitchToStr(FontPitch: TFontPitch): String;
function FontToStr(Font: TFont): String;
procedure StrToList(Str: String; Delimeter: Char; out Result: TStrings);
function StrToFontPitch(FontPitch: String): TFontPitch;
function StrToFont(Font: String): TFont;
function DeleteLastString(TheSt, ToDelete: String): String;
function DeleteLastComma( TheSt: String ): String;
function DeleteStringAfterString(TheSt, AfterToDelete: String): String;
function SplitMulti( St: String; Chars: String; out Delim: String ): StringArray;
function IndexPartOf( List: TStringList; Value: String ): Integer;
function StringStartWith(Str, StartWith: String; CaseSensitive: Boolean = False): Boolean;
function StringEndWith(Str, EndWith: String; CaseSensitive: Boolean = False): Boolean;
function Mid(Str: String; StartIdx, EndIdx: Integer ): String;
function ValInt(St: String): Integer; overload;
function ValInt(St: String; out WhereCut: Integer): Integer; overload;
function ProcessEditWithDate(TheStr: String): String;
function OnlyLetters(Str: String; FillWith: Char): String;
function OnlyLettersAndNumbers(Str: String; FillWith: Char): String;
function OnlyNumbers(Str: String): String;
function FileToStr( Filename: String ): String;
procedure StrToFile(const FileName, SourceString: String);
procedure StrToAnsiFile(const FileName, SourceString: String);
function String2File(FileName: String; ToWrite: String): Boolean;
function InsertString( SubStr: String; TheStr: String; Idx: Integer ): String;
function IntBetween( AInt: Integer; First, Secound: Integer ): Boolean;
function YearsOld(ADate, CurrentDate: String): Integer;
function PersonAge(ADate, CurrentDate: String): String;
function GetTempDirectory: String;
function GetSafeFilename(DirName, FileName: String): String;
function FileSize( FileName: String ): Int64;
function PosQuita( SubStr: String; var Str: String ): Boolean;
function INIReadStringAndExpand( FileName, Section, Ident: String ): String;
function StringArrayAssign(Args: array of string): StringArray;
procedure PosInArray(Args: StringArray; TheStr: String; out Idx: Integer);
function DeQuotedStr(const S: String; AQuote: Char): String; overload;
function DeQuotedStr(const S: string): String; overload;
function CopyToStrPos( St, ToStr: String ): String;
function CopyFromStrPos( St, ToStr: String ): String;
function AppPath: String;
function ColorBlend(Color1, Color2: TColor; A: Byte): TColor;
function StrSQLDateToDate(St: String): TDate;
function StrToFloatDec( S: String ): Extended;
function FileAppend(FileName: String; ToWrite: String): Boolean;
function StrToIntSafe( St: String ): Integer;
function CountOccurences( const SubText: String; const Text: String ): Integer;
procedure TrimStringArray(var AArray: StringArray);
procedure DeleteArrayIndex(var AArray: StringArray; AIndex: Integer);
procedure LoadIconInTImage(AFileName: String; var AImage: TImage);
function CUITDigitoVerificador( CUIT: String; out Verificador: String ): String;
function GetCUITFromDNI( DNI: String; HombreMujerSociedad: Char ): String;
procedure TrimArrayAnyChar( var AArray: StringArray );
function StrToDateTimeMillisecond(const S: string): TDateTime;
function FormatCustom(const Format: String; const Args: array of const): String;
function ResolveString( AStr: String ): String;
procedure QuickSort(var AnArray: StringArray; iLo: Integer = -1; iHi: Integer = -1);
function MakeFileName( FilePath, FileName: String ): String;
procedure CombineTwoStringList( List1, List2: TStringList );
procedure CopyMemIniFile( AMemINIFile: TMemIniFile; var Result: TMemIniFile );
function FileSearchPattern( DirName, Pattern: String; Recursive: Boolean = True): String;
function DirSearchPattern( DirName: String; Recursive: Boolean = True): String;
function OpenDlg( Title, Filter, InitialDir: String; var FileNames: StringArray ): Boolean; overload;
function OpenDlg( Title, Filter, InitialDir: String; var FileName: String ): Boolean; overload;
function SaveDlg( Title, Filter, InitialDir, DefaultExt: String; var FileName: String ): Boolean;
function MsgBox(const Text, Caption: String; Flags: Longint): Integer; overload;
function MsbBox(AOwner: TComponent; const Text, Caption: String; ImageType: PChar; Args: array of String): Integer; overload;
function ComponeFileName( OriginalFN, TempFN: String ): String;
procedure DeleteDirRecursively(const DirName: String);
function CopyFileDlg(SourceFile: String; TargetFile: String; Silent: Boolean = True): Boolean;
function StringEqualsTo( Str, Str2: String; IgnoreCase: Boolean = False ): Integer;
function StrIsPartOfIdx( Haystack, Needle: String; Idx: Integer; out Count: Integer; IgnoreCase: Boolean = False ): Boolean;
function StrHasAnyOfArray(AStr: String; out Idx: Integer; Args: array of String): Boolean;
function StrStartWithAnyOfArray(AStr: String; out Idx: Integer; Args: array of String): Boolean;
function AddStrToVector(AStr: String; Args: StringArray): StringArray;
function StringsEqualTo( Str1, Str2: String; IgnoreCase: Boolean = False ): Integer;
function CopyRight(S: String; Count: Integer): String;

implementation

function StrToFloatExcept(const S: string): Extended;
begin
  if Trim(S) = '' then
    Result:= 0
  else
    TextToFloat(PChar(S), Result, fvExtended);
end;

function FloatToStrExcept(Value: Extended): string;
begin
  try
    Result:= FloatToStr(Value);
  except
    Result:= '0';
  end;
end;

function CurrencyToStr(C: Real): String;
// Pasa un Currency (moneda) a String y otras cositas mas!!!
var Entero, Coma: String;
begin
  Entero:= RealToText(Int(C));
  Coma  := RealToText(Frac(C));
  if Length(Entero) < 2 then
    Entero:= '0' + Entero;
  if Length(Coma) < 2 then
    Coma  := '0' + Coma;
  Result:= Entero + Coma;
end;

function StrToCurrency(St: String): Real;
// al reves del de arriba -->^
var Aux: String;
    Aux2: Variant;
begin
  Aux:= Copy ( St , Pos( '$' , St ) + 1 , Length( St ) );
  Aux2:= Aux;
  Result:= Aux2;
end;

function SacarBlancos(S: String): String;
// una especie de Trim$ de BASIC, pero saca
// todos los blancos
var i: Integer;
begin
  Result:= '';
  for I:= 1 to length(S) do
    if S[i] <> ' ' then
      Result:= Result + S[i];
end;

function CalcularValor(Tex: String): Real;
// no tengo idea que hace!!!!
var StFrac, StInt: Integer;
begin
  StFrac:= StrToInt(Copy(Tex, 3, 2 ));
  StInt:= StrToInt(Copy (Tex, 0, 2));
  Result:= StInt + (StFrac / 100);
end;

function TextToReal(Tex:String):Real;
// Pasa una variable String a una Real
// Obsoleta, usar StrToFloat
var Aux: Variant;
begin
  Aux:= Tex;
  TextToReal:= Aux;
end;

function RealToText(Num: Real): string;
// Pasa una variable Real a un string
// Obsoleta, usar FloatToStr
var Aux: Variant;
begin
  Aux:= Num;
  RealToText:= Aux;
end;

Function Leer (IniFile: String; iniSection: String; iniEntry: String): String;
// Lee desde una sección de un INI, pasado por parámetro.
var Seccion: TIniFile;
begin
  Seccion:= TIniFile.Create (IniFile);
  Leer := Seccion.ReadString( iniSection, IniEntry ,'');
  Seccion.Free;
End;

function VolverDir (S: String): String;
// Devuelve el directorio, pasado en S
// p.e.: s='c:\lucho\archivo.txt', devuelve 'c:\lucho'
begin
  Result:= ExtractFilePath( S );
end;

procedure Grabar(iniFile :String; iniSection :String; iniEntry :String; iniString :String);
// Graba una entrada de un INI, pasado por parámetro.
var seccion: TIniFile;
begin
  Seccion:= TIniFile.Create (IniFile);
  Seccion.WriteString (iniSection, IniEntry , iniString);
  Seccion.Free;
End;

procedure DeleteEntry(iniFile :String; iniSection :String; iniEntry :String);
// Borra una entrada de un INI, pasado por parámetro.
var seccion: TIniFile;
begin
  Seccion:= TIniFile.Create (IniFile);
  Seccion.DeleteKey( iniSection, IniEntry );
  Seccion.Free;
end;

procedure DeleteSection(iniFile: String; iniSection: String);
// Borra una sección de un INI, pasado por parámetro.
var INI: TIniFile;
begin
  INI:= TIniFile.Create( IniFile );
  INI.EraseSection( iniSection );
  INI.Free;
end;


function Crypt(S: String): String;
// Encripta/desencripta!!!
var X: Byte;
begin
  RandSeed := Length(S);
  for X := 1 to Length(S) do
    S[X] := Chr(Ord(S[X]) xor (Random(128) or 128));
  Result:= s;
end;

function ObtenerPath(S: String): String;
// Devuelve la ruta del archivo sin el nombre:
// p.e.: S= 'C:\Windows\Notepad.exe', devuelve 'C:\Windows'
var AuxI,i: integer;
    aux: String;
begin
  Auxi:= 0;
  Aux:= S;
  for i:= 1 to Length(Aux) do
    if Aux[i] = '\' then
      AuxI:= i;
  Result:= Copy(Aux,0,AuxI - 1);
end;

function ObtenerFile(S: String): String;
// Devuelve el nombre del archivo sin la ruta:
// p.e.: S= 'C:\Windows\Notepad.exe', devuelve 'Notepad.exe'
var AuxI,i: integer;
    aux: String;
begin
  Auxi:= 0;
  Aux:= S;
  for i:= 1 to length(aux) do
    if aux[i] = '\' then
      AuxI:= i;
  Result:= copy(aux,AuxI + 1 ,length(aux));
end;

function Extension (S: String): String;
// Devuelve la extensión de un archivo, pasado en S
// p.e: S: 'c:\lucho4\archivo.txt'. Devuelve: 'txt'
var AuxI,i: integer;
    aux: String;
begin
  Auxi:= 0;
  Aux:= S;
  for i:= 1 to length(aux) do
    if aux[i] = '.' then
      AuxI:= i;
  if Auxi <> 0 then
    Result:= copy(aux,AuxI + 1 ,length(aux));
end;

function GetFilenameWithoutExt(AFilename: String): String;
// Devuelve el nombre del archivo sin la ruta ni extensión:
// p.e.: S= 'C:\Windows\Notepad.exe', devuelve 'Notepad'
begin
  Result:= ExtractFileName( AFilename );
  Result:= Copy( Result, 1, Result.Length - Length( ExtractFileExt( Result ) ) );
end;

Procedure GrabarCrypt(iniFile :String; iniSection :String; iniEntry :String; iniString :String);
// Graba una entrada encriptada de un INI, pasado por parámetro.
var seccion: TIniFile;
begin
  Seccion:= TIniFile.Create (IniFile);
  Seccion.WriteString (iniSection, IniEntry , Crypt(IniString) );
  Seccion.Free;
End;

Function LeerCrypt (iniFile :String; iniSection :String; iniEntry :String): String;
// Lee una entrada encriptada de un INI, pasado por parámetro.
var seccion: TIniFile;
begin
  Seccion:= tinifile.Create (IniFile);
  LeerCrypt :=Crypt(seccion.ReadString( iniSection, IniEntry ,''));
End;

function Iif(Expresion: Boolean; ParteVerd: String; ParteFalsa: String): String;
// Como la de Visual Basic, si expresion es true, devuelve ParteVerd, sino
// devuelve ParteFalsa...
begin
  if Expresion then
    Result:= ParteVerd
  else
    Result:= ParteFalsa;
end;

function StrToIntCero(St: String): Integer;
// Si St es nula, devuelve 0;
begin
  if Trim(St) = '' then
    St:= '0';
  Result:= StrToInt(St);
end;

function StrToFloatCero(St: String): Extended;
begin
  if Trim(St) = '' then
    St:= '0';
  Result:= StrToFloat(St);
end;

function StrToInt64Cero(St: String): Cardinal;
// Si St es nula, devuelve 0;
begin
  if Trim(St) = '' then
    St:= '0';
  Result:= StrToInt64(St);
end;

function CharCount(const S: String; C: Char): Integer;
// Devuelve la cantidad de caracteres C que se encontro en S
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] = C then
      Inc(Result);
end;

function Split( Expresion: String; Delimitador: Char; SplitOnQuotes: Boolean = False): StringArray;
// Si se pasa Expresion: '1,2,3,4'. Y Delimitador = ','. Devuelve en Vector: [1,2,3,4]
// Es parecida a la de VisualBasic 6
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

function Split( Expresion: String; Delimitador: String; Trim: Boolean = True): StringArray;
var I, K, StartThis: Integer;
    DelLength: Integer;
begin
  try
    SetLength( Result, 0 );
    if Length( Expresion ) = 0 then
      Exit;

    DelLength:= Length(Delimitador);
    //SetLength( Result, ((Length(Expresion) - Length(StringReplace(Expresion, Delimitador, '', [rfReplaceAll]))) div DelLength) + 1 );
    SetLength( Result, 0 );
    K:= 0;
    I:= 1;
    StartThis:= 1;
    while I <= Length(Expresion) + 1 do begin
      if (Copy( Expresion, I, DelLength ) = Delimitador) or (I = Length(Expresion)+1) then begin
        SetLength( Result, Length( Result ) + 1 );
        Result[ K ]:= Mid( Expresion, StartThis, I - (DelLength - 1) );
        I:= I + DelLength;
        if (Result[ K ] <> '') or (not(Trim)) then begin
          Inc( K );
        end;
        StartThis:= I;
      end
      else begin
        Inc( I );
        //SetLength( Result, Length( Result ) + 1 );
      end;
    end;
  except
  end;
end;

function Indice (St: String; const Vector: StringArray): Integer;
// Devuelve en qué lugar esta St dentro de Vector (es case-sensitive)
// p.e.: St: 'j'. Vector: ['z', 'q', 'j', 'A']. Devuelve: 2
var I: Integer;
begin
  Result:= -1;
  for I:= High(Vector) downto Low(Vector) do
    if UpperCase(Trim(Vector[i])) = UpperCase(Trim(St)) then begin
      Result:= I;
      Exit;
    end;
end;

function IndiceInt (Int: Integer; const Vector: array of String): String;
// Devuelve el elemento Int de Vector
// es igual que poner Vector[Int] !!!, salvo que no tira excepción
begin
  if (Int <= High(Vector)) and (Int >= Low(Vector)) then
    Result:= Vector[Int]
  else
    Result:= '';
end;

function StrToIntExcept(const St: String): Integer;
// como StrToInt, pero si le pasamos cualquier verdura, devuelve 0
begin
  try
    Result:= StrToIntCero(St);
  except
    Result:= 0;
  end;
end;

function MidPath(Path, FullPath: String): String;
// Devuelve path relativo
// p.e.: Path: 'c:\lucho4'. FullPath: 'c:\lucho4\delphi\archivo.txt'.
// Devuelve: '\delphi\archivo.txt'
begin
  Result:= AnsiMidStr( FullPath, AnsiPos(Path, FullPath)+Length(Path), Length(FullPath))
end;

procedure CargarIcono(var Imagen: TImage; Tipo: PChar);
// Carga un ícono estándar de Windows en un TImage
// Tipo puede ser:
// IDI_APPLICATION, IDI_HAND, IDI_QUESTION, IDI_EXCLAMATION, IDI_ASTERISK, IDI_WINLOGO
begin
  Imagen.Picture.Icon.Handle:= LoadIcon( 0, Tipo );
end;

function StrToBoolExcept(const S: string): Boolean;
begin
  // Devuelve True solo si S = '-1'...
  Result:= (StrToIntExcept( S ) = -1);
end;

function IniValueCant(iniFile :String; iniSection :String): Integer;
// Devuelve la cantidad de entradas de una sección, pasada por parámetro
var
  KeyList: TStringList;
  Seccion: TIniFile;
begin
  KeyList := TStringList.Create;
  try
    Seccion:= tinifile.Create (IniFile);
    Seccion.ReadSection(iniSection, KeyList);
    Result:= KeyList.Count;
  finally
    KeyList.Free;
    Seccion.Destroy;
  end;
end;

function IniSectionCant(INIFile :String): Integer;
// Devuelve la cantidad de secciones, pasada por parámetro
var
  KeyList: TStringList;
  Seccion: TIniFile;
begin
  KeyList := TStringList.Create;
  try
    Seccion:= TINIFile.Create (IniFile);
    Seccion.ReadSections(KeyList);
    Result:= KeyList.Count;
  finally
    KeyList.Free;
    Seccion.Destroy;
  end;
end;

function MezclarBMP(BMP1, BMP2: TImage; Transparencia: Integer): TImage; overload;
// Pone BMP1 como fondo y agrega BMP2 con una tranparencia, pasada por parámetro (en %)
var ABmp1, ABmp2: TBitmap;
begin
  ABmp1:= BMP1.Picture.Bitmap;
  ABmp2:= BMP2.Picture.Bitmap;
  Result.Picture.Bitmap:= MezclarBMP( ABMP1, ABMP2, Transparencia );
end;
//
function MezclarBMP(BMP1, BMP2: TBitmap; Transparencia: Integer): TBitmap; overload;
// Pone BMP1 como fondo y agrega BMP2 con una tranparencia, pasada por parámetro (en %)
var
  i, j: Integer;
  BackPoint, ForePoint: pByteArray;
begin
  if BMP1.Height <> BMP2.Height then
    if BMP1.Height > BMP2.Height then
      BMP2.Height:= BMP1.Height
    else
      BMP1.Height:= BMP2.Height;

  if BMP1.Width <> BMP2.Width then
    if BMP1.Width > BMP2.Width then
      BMP2.Width:= BMP1.Width
    else
      BMP1.Width:= BMP2.Width;

  for i := 0 to BMP1.Height - 1 do begin
    BackPoint := BMP1.ScanLine[i];
    ForePoint := BMP2.ScanLine[i];
    for j := 0 to (3 * BMP1.Width) - 1 do begin
      ForePoint[j] := ForePoint[j] + Transparencia * (BackPoint[j] - ForePoint[j]) div 100;
    end;
  end;
  if Result = nil then begin
    Result:= TBitmap.Create;
  end;
  BMP2.Canvas.CopyRect( Rect(0,0,BMP2.Height, BMP2.Width ), Result.Canvas, Rect(0,0,BMP2.Height, BMP2.Width ));
end;

function StrIsFloat(St: String): Boolean;
var X: Extended;
begin
  Result:= True;
  try
    X:= StrToFloat( St );
  except
    Result:= False;
  end;
end;

function Space(Cont: Integer; Letra: Char): String;
// Genera un string de longitud Cont con la letra Letra
var i: Integer;
begin
  Result:= '';
  for i:= 0 to Cont do
    Result:= Result + Letra;
end;

function Fii(Expresion: String; PartTrue, PartFalse: String; Default: Boolean): Boolean;
// Si expresión coincide con PartTrue, devuelve True, si coincide con PartFalse, devuelve
// False, si no coincide con ninguno de los dos, devuelve Default
// Es case-insensitive
begin
  Result:= Default;
  if UpperCase(Expresion) = UpperCase(PartTrue) then
    Result:= True;
  if UpperCase(Expresion) = UpperCase(PartFalse) then
    Result:= False;
end;

function PosAtras( C: Char; S: String): Integer;
var i: Integer;
begin
  for i:= Length( S ) downto 1 do
    if S[i] = C then begin
      Result:= i;
      Exit;
    end;
end;

function ReplaceString( Text: String; OldC, NewC: Char  ): String;
var i: Integer;
begin
  if Text = '' then
    Text:= '0';
  for i:= 1 to Length( Text ) do begin
    if Text[ i ] = OldC then
      Text[ i ]:= NewC;
  end;
  Result:= Text;
end;

function QuotedStrCero( St: String ): String;
begin
  if St = '' then St:= '0';
  Result:= QuotedStr( St );
end;

function ConvertFecha( Fecha: String ): String;
var Aux: StringArray;
begin
  // yyyy/mm/dd
  Aux:= Split( Fecha, '/' );
  Result:= Aux[ 2 ] + '/' + Aux[ 1 ] + '/' + Aux[ 0 ];
end;

function GetVolumeID(DriveChar: Char): String;
var
   MaxFileNameLength, VolFlags, SerNum: DWord;
begin
   if GetVolumeInformation(PChar(DriveChar + ':\'), nil, 0,
      @SerNum, MaxFileNameLength, VolFlags, nil, 0)
   then
   begin
     Result := IntToHex(SerNum,8);
   end
   else
       Result := '';
end;

function StrIsInt(St: String): Boolean;
var X: Extended;
begin
  Result:= True;
  try
    X:= StrToInt( St );
  except
    Result:= False;
  end;
end;

function IsEMail(EMail: string): Boolean;
var
  s: string;
  ETpos: Integer;
begin
  if Trim(EMail) = '' then begin
    Result:= True;
    Exit
  end;

  ETpos := pos('@', EMail);
  if ETpos > 1 then
  begin
    s := copy(EMail, ETpos + 1, Length(EMail));
    if (pos('.', s) > 1) and (pos('.', s) < length(s)) then
      Result := true
    else
      Result := false;
  end
  else
    Result := false;
end;

function EsCUITValido(CUIT: String): Boolean;
var Verificador: String;
begin
  Result:= False;
  Verificador:= CUITDigitoVerificador( CUIT, Verificador );
  if CUIT <> '' then begin
    Result:= Verificador = CUIT[ CUIT.Length ];
  end;
end;

function AgregaChar(St: String; Cant: Integer): String;
var i: Integer;
begin
  Result:= Copy( St, 1, Cant );
  for i:= Length( St ) to Cant do begin
    Result:= Result + ' ';
  end;
end;

function AddCharLeft(St: String; Cant: Integer): String;
var i: Integer;
begin
  Result:= Copy( St, 1, Cant );
  for i:= Length( St ) to Cant do begin
    Result:= ' ' + Result;
  end;
end;


function StrIsDate(St: String): Boolean;
var X: Extended;
begin
  Result:= True;
  try
    X:= StrToDate( ProcessEditWithDate( St ) );
  except
    Result:= False;
  end;
end;

function StrToDate4TFirebird( St: String ): TDate;
begin
  Result:= StrToDate( ProcessEditWithDate( St ) );
end;

function LstToStr( lst: TStrings; Separator: String ): String;
var i: Integer;
begin
  Result:= '';
  for i:= 0 to lst.Count-2 do
    Result:= Result + lst.Strings[ i ] + Separator;
  Result:= Result + lst.Strings[ lst.Count-1 ];
end;

function IniValues(iniFile :String; iniSection :String): StringArray;
// Devuelve en un array todos los entradas que se encontraron en una sección
var
  KeyList: TStringList;
  Seccion: TIniFile;
  i: Integer;
begin
  KeyList := TStringList.Create;
  try
    Seccion:= TIniFile.Create (IniFile);
    Seccion.ReadSection(iniSection, KeyList);
    SetLength( Result, KeyList.Count );
    for i:= 0 to KeyList.Count-1 do
      Result[ i ]:= KeyList.Strings[ i ];
  finally
    KeyList.Free;
    Seccion.Free;
  end;
end;

function IniSectionExists(iniFile :String; iniSection :String): Boolean;
// Devuelve True si la función existe en el INI, False si no existe
var
  Seccion: TIniFile;
begin
  Result:= False;
  try
    Seccion:= TIniFile.Create (IniFile);
    Result:= Seccion.SectionExists(iniSection);
  finally
    Seccion.Free;
  end;
end;

function IniSections(INIFile :String): StringArray;
// Devuelve en un array todos los secciones que se encontraron.
var
  KeyList: TStringList;
  Seccion: TIniFile;
  i: Integer;
begin
  KeyList := TStringList.Create;
  try
    Seccion:= TIniFile.Create (IniFile);
    Seccion.ReadSections( KeyList );
    SetLength( Result, KeyList.Count );
    for i:= 0 to KeyList.Count-1 do
      Result[ i ]:= KeyList.Strings[ i ];
  finally
    KeyList.Free;
    Seccion.Free;
  end;
end;

function MatchStrings(Source, Pattern: String): Boolean;
var pSource: array [0..255] of Char;
    pPattern: array [0..255] of Char;

  function MatchPattern(element, pattern: PChar): Boolean;

   function IsPatternWild(pattern: PChar): Boolean;
   begin
     Result := StrScan(pattern,'*') <> nil;
     if not Result then Result := StrScan(pattern,'?') <> nil;
   end;

  begin
    if 0 = StrComp(pattern,'*') then
      Result := True
    else if (element^ = Chr(0)) and (pattern^ <> Chr(0)) then
      Result := False
    else if element^ = Chr(0) then
      Result := True
    else begin
      case pattern^ of
        '*': if MatchPattern(element,@pattern[1]) then
              Result := True
            else
              Result := MatchPattern(@element[1],pattern);
        '?': Result := MatchPattern(@element[1],@pattern[1]);
      else
         if element^ = pattern^ then
           Result := MatchPattern(@element[1],@pattern[1])
         else
           Result := False;
      end;
    end;
  end;
begin
  StrPCopy(pSource,source);
  StrPCopy(pPattern,pattern);
  Result := MatchPattern(pSource,pPattern);
end;

function ArrayToString( Vector: StringArray; Sep: String; Quoted: Boolean ): String;
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

function StrToBoolCero( St: String ): Boolean;
begin
  if Trim(St) = '' then
    St:= '0';
  Result:= StrToBool( St );
end;

function StringCase( Selector: string; CaseList: array of string ): Integer;
var
  cnt: integer;
begin
  Result := -1;
  for cnt := 0 to Length(CaseList) - 1 do
  begin
    if CompareText(Selector, CaseList[cnt]) = 0 then
    begin
      Result := cnt;
      Break;
    end;
  end;
end;

function Capitalize( St: String ): String;
begin
  St:= LowerCase( St );
  St[ 1 ]:= UpCase( St[ 1 ] );
  Result:= St;
end;

function FormatStringArray (const Format: string; const Args: StringArray): string;
var i: Integer;
begin
  i:= 0;
  Result:= Format;
  while Pos( '%s', Result ) > 0 do begin
    Result:= Copy( Result, 1, Pos( '%s', Result ) - 1) + Args[ i ] + Copy( Result, Pos( '%s', Result ) + 2, Length( Result ) );
    Inc( i );
  end;
end;

function MakeComponentName( St: String ): String;
var i: Integer;
begin
  Result:= '';
  St:= LowerCase( St );
  for i := 1 to Length( St ) do
    if St[ i ] in ['á', 'é', 'í', 'ó', 'ú', ' ', 'ñ', '.'] then
      Result:= Result + '_'
    else
      if St[ i ] <> '&' then
        Result:= Result + St[ i ];
end;

function GetComputerNameStr: String;
var Buffer: Array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
    Size: Cardinal;
begin
  Size:= MAX_COMPUTERNAME_LENGTH + 1;
  GetComputerName( @Buffer, Size );
  Result:= StrPas( Buffer );
end;


function BytesToStr(Bytes: Double): String;
const
   Factor = 1024;
   Arr: array [0..4] of String=('Bytes','KB','MB','GB','TB');
var
   i: Integer;
begin
  i := 0;
  while (i < High(Arr)) and (Bytes >= Factor) do
  begin
    Bytes:= Bytes / Factor;
    Inc(i);
  end;
  Result:= FormatFloat( '0.00', Bytes ) + ' ' + Arr[ i ];
end;

function HexaToBin( Hexadecimal: String ): String;
const
     BCD: array [0..15] of string=
       ('0000','0001','0010','0011','0100','0101','0110','0111',
        '1000','1001','1010','1011','1100','1101','1110','1111');
var
   i:integer;
begin
   for i:= Length( Hexadecimal ) downto 1 do
     Result:=BCD[ StrToInt( '$' + Hexadecimal[ i ] ) ] + Result;
end;

function BinToHexa( Binario: String ): String;
const
     BCD: array [0..15] of string=
       ('0000','0001','0010','0011','0100','0101','0110','0111',
        '1000','1001','1010','1011','1100','1101','1110','1111');
     HEX: array [0..15] of char=
       ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var
   i,n: Integer;
   sTemp: String;
   sNibble: String;
begin
   Result:='';
   sTemp:=Binario+Copy('000',1,Length(Binario) mod 4);
   for i:=0 to (Length(Binario) shr 2)-1 do
   begin
    sNibble:=Copy(sTemp,(i shl 2)+1,4);
    n:=8;
    while (sNibble <> BCD[n]) do
      if sNibble < BCD[n] then Dec(n) else Inc(n);
    Result:=Result+HEX[n];
   end;
end;

function ExtractCurrencyValueEx( Value: String ): String;
var i: Integer;
    St: String;
begin
  if Trim( Value ) = '' then
    Value:= '0';
  St:= '';
  for I := 0 to Length( Value ) do begin
    if (Value[ i ] in ['0'..'9','-', FormatSettings.DecimalSeparator]) then begin
      St:= St + Value[ i ];
    end;
  end;
  Result:= St;
end;

function ExtractCurrencyValueEx2Ext( Value: String ): Extended;
begin
  Result:= StrToFloat( ExtractCurrencyValueEx( Value ) );
end;

function IncludeCurrencyValueEx( Value: Extended ): String; overload;
begin
  Result:= IncludeCurrencyValueEx( FloatToStr(Value) );
end;

function IncludeCurrencyValueEx( Value: String ): String; overload;
begin
  if Trim( Value ) = '' then
    Value:= '0';
  Value:= ExtractCurrencyValueEx( Value );
  Result:= Format( '%n', [ StrToFloat( Value ) ] );
end;

procedure ReplacePartOfString( var St: String; NewSt: String; iFrom, iTo: Integer; FillLeft: Boolean );
var i: Integer;
begin
  if Length( NewSt ) > (iTo - iFrom) then
    NewSt:= Copy( NewSt, 1, iTo - iFrom );

  if FillLeft then
    NewSt:= AddCharLeft( NewSt, iTo - iFrom )
  else
    NewSt:= AgregaChar( NewSt, iTo - iFrom );

  for I := iFrom to iTo do
    St[ I ]:= NewSt[ I - iFrom + 1 ];
end;

procedure ReplacePartOfStringWithTrim( var St: String; NewSt: String; iFrom, iTo: Integer; Trim: Boolean );
var DummyStr: String;
begin
  DummyStr:= Copy( St, 1, iFrom );
  if Not(Trim) then begin
    NewSt:= NewSt + Space( (iTo-iFrom)-Length(NewSt), ' ' );
  end;
  St:= DummyStr + NewSt + Copy( St, iTo+1, Length(St) );
end;

function INIEntryExists(iniFile :String; iniSection :String; iniEntry :String): Boolean;
var Seccion: TIniFile;
begin
  Seccion:= TIniFile.Create (IniFile);
  Result:= Seccion.ValueExists( iniSection, iniEntry );
  Seccion.Free;
end;

function ReadRegistry( RootKey: Cardinal; Key, Name: String): String;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.Access := KEY_WOW64_64KEY or KEY_QUERY_VALUE;
    Reg.RootKey := RootKey;
    if Reg.OpenKey( Key, False ) then
    begin
      Result:= Reg.ReadString( Name );
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function FormatDate2SQL( Fecha: String ): String;
var Year, Month, Day: Word;
begin
  DecodeDate( StrToDate( Fecha ), Year, Month, Day );

  Result:= Format( '%.4d/%.2d/%.2d', [ Year, Month, Day ] );
  //Result:= Copy( Fecha, 7, 4 ) + '/' + Copy( Fecha, 4, 2 ) + '/' + Copy( Fecha, 1, 2 );
end;

function ReadFromConfig( Config, Field: String ): String;
var SaveIn: StringArray;
    INIFileName: String;
begin
  INIFilename:= ExtractFilePath( Application.ExeName ) + Config + '.mcf';
  SaveIn:= Split( Leer( INIFilename, Field, 'Store' ), '|' );
  if INIEntryExists( ExtractFilePath( Application.ExeName ) + SaveIn[ 0 ], SaveIn[ 1 ], SaveIn[ 2 ] ) then
    Result:= Leer( ExtractFilePath( Application.ExeName ) + SaveIn[ 0 ], SaveIn[ 1 ], SaveIn[ 2 ] )
  else
    Result:= Leer( INIFilename, Field, 'Default' );

  if UpperCase(Leer( INIFilename, Field, 'Type' )) = 'PASSWORD' then
    Result:= Crypt( Result );
end;

procedure WriteToConfig( Config, Field, Value: String );
var SaveIn: StringArray;
    INIFileName: String;
begin
  INIFilename:= ExtractFilePath( Application.ExeName ) + Config + '.mcf';
  SaveIn:= Split( Leer( INIFilename, Field, 'Store' ), '|' );
  {if INIEntryExists( ExtractFilePath( Application.ExeName ) + SaveIn[ 0 ], SaveIn[ 1 ], SaveIn[ 2 ] ) then
    Result:= Leer( ExtractFilePath( Application.ExeName ) + SaveIn[ 0 ], SaveIn[ 1 ], SaveIn[ 2 ] )
  else
    Result:= Leer( INIFilename, Field, 'Default' );

  if UpperCase(Leer( INIFilename, Field, 'Type' )) = 'PASSWORD' then
    Result:= Crypt( Result );
  }
  Grabar( ExtractFilePath( Application.ExeName ) + SaveIn[ 0 ], SaveIn[ 1 ], SaveIn[ 2 ], Value );
end;

function UpperCaseOnlyFirstLetter( St: String ): String;
var i: Integer;
begin
  Result:= '';
  for I:= 1 to Length( St ) do begin
    if (I = 1) or ((I > 1) and (St[ i-1 ] in [' '])) then
      Result:= Result + UpperCase(St[ i ])
    else
      Result:= Result + LowerCase(St[ i ])
  end;
end;

function GetWindowsDir: String;
var
  WinDir: array [0..MAX_PATH-1] of char;
begin
  SetString(Result, WinDir, GetWindowsDirectory(WinDir, MAX_PATH));
  if Result = '' then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;

function GetSystemDir: String;
var
  SysDir: array [0..MAX_PATH-1] of char;
begin
  SetString(Result, SysDir, GetSystemDirectory(SysDir, MAX_PATH));
  if Result = '' then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;

function HasParam( Param: String ): Boolean;
var i: Integer;
begin
  Param:= LowerCase( Param );
  Result:= False;
  for I := 1 to ParamCount do begin
    if LowerCase( ParamStr( i ) ) = Param then begin
      Result:= True;
      Break;
    end;
  end;
end;

function GetParam( Param: String ): String;
//var i: Integer;
begin
//  Param:= LowerCase( Param ) + '=';
//  Result:= '';
//  for I := 1 to ParamCount do begin
//    if StringStartWith( LowerCase(ParamStr( I )), Param) then begin
//      Result:= Copy( ParamStr( I ), Param.Length + 1, ParamStr( I ).Length );
//      Break;
//    end;
//  end;
  Result:= GetParam( Param, '=' );
end;

function GetParam( Param: String; Separador: String ): String;
var i: Integer;
begin
  Param:= LowerCase( Param ) + Separador;
  Result:= '';
  for I := 1 to ParamCount do begin
    if StringStartWith( LowerCase(ParamStr( I )), Param) then begin
      Result:= Copy( ParamStr( I ), Param.Length + 1, ParamStr( I ).Length );
      Break;
    end;
  end;
end;

function StringLen(Str: String): Integer;
begin
  result:= StrLen(PChar(Str));
end;

function ListToStr(List: TStringList; Delimeter: String): String;
var
   I: Integer;
   TempStr: String;
begin
  for I:= 0 to List.Count - 1 do begin
    TempStr:= TempStr + List[I] + Delimeter;
  end;
  Delete(TempStr, (StringLen(TempStr)-StringLen(Delimeter)+1), StringLen(Delimeter));
  result:= TempStr;
end;

function FontStyleToStr(FontStyle: TFontStyles): String;
var
   TempList: TStringList;
begin
  TempList:= TStringList.Create;
  if fsBold      in FontStyle then TempList.Add('fsBold');
  if fsItalic    in FontStyle then TempList.Add('fsItalic');
  if fsUnderline in FontStyle then TempList.Add('fsUnderline');
  if fsStrikeOut in FontStyle then TempList.Add('fsStrikeOut');
  if TempList.Count = 0 then TempList.Add('fsNone');
  result:= ListToStr(TempList, '~');
  TempList.Free;
end;

function FontPitchToStr(FontPitch: TFontPitch): String;
begin
  result:= 'fpDefault';
  case FontPitch of
    fpDefault:     result:= 'fpDefault';
    fpFixed:       result:= 'fpFixed';
    fpVariable:    result:= 'fpVariable';
  end;
end;

function FontToStr(Font: TFont): String;
var
   TempList: TStringList;
begin
  TempList:= TStringList.Create;
  TempList.Add(IntToStr(Int64(Font.Charset)));
  TempList.Add(ColorToString(Font.Color));
  TempList.Add(IntToStr(Font.Height));
  TempList.Add(Font.Name);
  TempList.Add(FontPitchToStr(Font.Pitch));
  TempList.Add(IntToStr(Font.Size));
  TempList.Add(FontStyleToStr(Font.Style));
  result:= ListToStr(TempList, '|');
  TempList.Free;
end;

procedure StrToList(Str: String; Delimeter: Char; out Result: TStrings);
var Vector: StringArray;
    I: Integer;
begin
  Result.Clear;
  Vector:= Split( Str, Delimeter );
  for I:= Low(Vector) to High(Vector) do begin
    Result.Add( Vector[ i ] );
  end;
end;

function StrToFontPitch(FontPitch: String): TFontPitch;
begin
  result:= fpDefault;
  if FontPitch = 'fpDefault'  then result:= fpDefault else
  if FontPitch = 'fpFixed'    then result:= fpFixed else
  if FontPitch = 'fpVariable' then result:= fpVariable;
end;

function StrToFontStyle(FontStyle: String): TFontStyles;
var
   TempList: TStrings;
   I: Integer;
begin
  TempList:= TStringList.Create;
  StrToList(FontStyle, '~', TempList);
  Result:= [];
  for I:= 0 to TempList.Count - 1 do begin
    if TempList[I] = 'fsBold'      then Include(result, fsBold) else
    if TempList[I] = 'fsItalic'    then Include(result, fsItalic) else
    if TempList[I] = 'fsUnderline' then Include(result, fsUnderline) else
    if TempList[I] = 'fsStrikeOut' then Include(result, fsStrikeOut);
  end;
  TempList.Free;
end;

function StrToFont(Font: String): TFont;
var
   TempList: TStrings;
   bFont: TFont;
begin
  TempList:= TStringList.Create;
  if Font = '' then
    Font:= '0|clBlack|-13|Arial|fpDefault|10|fsNone';

  StrToList(Font, '|', TempList);
  bFont:= TFont.Create;
  bFont.Charset:= StrToIntDef(TempList[0], 1);
  bFont.Color:= StringToColor(TempList[1]);
  bFont.Height:= StrToIntDef(TempList[2], -11);
  bFont.Name:= TempList[3];
  bFont.Pitch:= StrToFontPitch(TempList[4]);
  bFont.Size:= StrToIntDef(TempList[5], 8);
  bFont.Style:= StrToFontStyle(TempList[6]);
  TempList.Free;
  Result:= bFont;
end;

function DeleteLastString(TheSt, ToDelete: String): String;
begin
  TheSt:= Trim( TheSt );
  ToDelete:= Trim(ToDelete);
  if Copy( TheSt, Length( TheSt ) - Length( ToDelete ) + 1, Length( ToDelete ) ) = ToDelete then
    Result:= Copy( TheSt, 1, Length( TheSt ) - Length( ToDelete ) )
  else
    Result:= TheSt

end;

function DeleteLastComma(TheSt: String): String;
begin
  Result:= DeleteLastString(TheSt, ',' );
end;

function DeleteStringAfterString(TheSt, AfterToDelete: String): String;
var PosSt: Integer;
begin
  PosSt:= Pos( AfterToDelete, TheSt );
  if PosSt > 0 then begin
    Result:= Copy( TheSt, 1, PosSt-1 );
  end
  else begin
    Result:= TheSt;
  end;
end;

function SplitMulti( St: String; Chars: String; out Delim: String ): StringArray;
var i, Count: Integer;
begin
  Count:= 0;
  Delim:= '';
  for I:= 1 to St.Length do begin
    if Pos( St[ i ], Chars ) > 0 then begin
      Inc( Count );
      Delim:= Delim + St[ i ];
    end;
  end;

  SetLength( Result, Count + 1 );
  Count:= 1;
  for I:= Low( Result ) to High( Result ) do begin
    if I = High( Result ) then begin
      Result[ I ]:= St;
    end
    else begin
      Result[ I ]:= Copy( St, Count, Pos( Delim[ I + 1 ], St ) - 1 );
      St:= Copy( St, Pos( Delim[ I + 1 ], St ) + 1, St.Length );
    end;
  end;
end;

function IndexPartOf( List: TStringList; Value: String ): Integer;
var I: Integer;
begin
  Result:= -1;
  for I:= 0 to List.Count - 1 do begin
    if UpperCase(Copy(List.Strings[ i ], 1, Length(Value))) = UpperCase( Value ) then begin
      Result:= I;
      Break;
    end;
  end;
end;

function StringStartWith(Str, StartWith: String; CaseSensitive: Boolean = False): Boolean;
begin
  if Not(CaseSensitive) then begin
    Str:= UpperCase( Str );
    StartWith:= UpperCase( StartWith );
  end;

  Result:= Copy( Str, 1, Length(StartWith)) = StartWith;
end;

function StringEndWith(Str, EndWith: String; CaseSensitive: Boolean = False): Boolean;
begin
  if Not(CaseSensitive) then begin
    Str:= UpperCase( Str );
    EndWith:= UpperCase( EndWith );
  end;

  Result:= Copy( Str, Length(Str) - Length(EndWith) + 1, Length(EndWith)) = EndWith;
end;

function Mid(Str: String; StartIdx, EndIdx: Integer ): String;
var ToChar: Integer;
begin
  ToChar:= EndIdx - StartIdx;
  if ToChar > Str.Length then begin
    ToChar:= Str.Length - StartIdx;
  end;
  Result:= Copy( Str, StartIdx, ToChar + 1 );
end;

function ValInt(St: String): Integer;
var Where: Integer;
begin
  Result:= ValInt( St, Where );
end;

function ValInt(St: String; out WhereCut: Integer): Integer;
var I: Integer;
    Dummy: String;
begin
  St:= Trim(St);
  Dummy:= '';
  for I:= 1 to Length(St) do begin
    if CharInSet( St[ i ], ['0'..'9']) then begin
      Dummy:= Dummy + St[ i ];
    end
    else begin
      Break;
    end;
  end;
  Result:= StrToIntCero(Dummy);
  WhereCut:= I;
end;

function ProcessEditWithDate(TheStr: String): String;
var SystemTime: TSystemTime;
    TheDate: TDateTime;
    D, M, Y: Integer;
    Where: Integer;
begin
  D:= 0;
  M:= 0;
  Y:= 0;
  GetLocalTime(SystemTime);
  TheStr:= Trim(TheStr);
  TheDate:= -1;

  if TheStr = '' then begin
    Result:= '';
  end
  else begin
    if TheStr = '+' then begin
      TheDate:= Date;
    end
    else begin
      // Puede haber 1, 2 o 3 partes
      D:= ValInt( TheStr, Where );
      if (D > 0) and (IntToStr(D) = TheStr) then begin
        if (D > 31) then
          D:= 31;

      end
      else begin
        TheStr:= Copy( TheStr, Where + 1, Length(TheStr) );
        //TheStr:= Copy( TheStr, Length(Format('%.2d', [D])) + 2, Length(TheStr) );
        M:= ValInt( TheStr, Where );
        if (M > 0) and (IntToStr(M) = TheStr) then begin
          TheDate:= EncodeDate( SystemTime.wYear, M, D );
        end
        else begin
          TheStr:= Copy( TheStr, Where + 1, Length(TheStr) );
          Y:= ValInt( TheStr );
          if (Length(IntToStr(Y)) < 4) and (Y <> 0) then begin
            if Y <= StrToInt(FormatDateTime( 'YY', Date ))+5 then
              Y:= 2000 + Y
            else
              Y:= 1900 + Y;
          end;
        end;
      end;
    end;
  end;
  if D > 0 then begin
    if M = 0 then
      M:= SystemTime.wMonth;

    if Y = 0 then
      Y:= SystemTime.wYear;

    TheDate:= EncodeDate( Y, M, D );
  end;
  if Int(TheDate) = -1 then
    Result:= ''
  else
    Result:= FormatDateTime( 'dd/mm/yyyy', TheDate );
end;

function OnlyLetters(Str: String; FillWith: Char): String;
var I: Integer;
begin
  Result:= Str;
  for I:= 1 to Length(Str) do begin
    if Not(CharInSet( Result[ i ], [ 'A'..'Z', 'a'..'z','|' ] )) then begin
      Result[ i ]:= FillWith;
    end;
  end;
end;

function OnlyLettersAndNumbers(Str: String; FillWith: Char): String;
var I: Integer;
begin
  Result:= Str;
  for I:= 1 to Length(Str) do begin
    if Not(CharInSet( Result[ i ], [ '0'..'9', 'A'..'Z', 'a'..'z','|' ] )) then begin
      Result[ i ]:= FillWith;
    end;
  end;
end;

function OnlyNumbers(Str: String): String;
var I: Integer;
begin
  Result:= Str;
  for I:= 1 to Length(Str) do begin
    if Not(CharInSet( Result[ i ], [ '0'..'9','-' ] )) then begin
      Result[ i ]:= 'A';
    end;
  end;
  Result:= StringReplace( Result, 'A', '', [rfReplaceAll] );
end;

{function FileToStr( Filename: String ): String;
var
  Stream : TFileStream;
begin
  Stream:= TFileStream.Create(FileName, fmOpenRead);
  try
    SetLength(Result, Stream.Size);
    Stream.Position:=0;
    Stream.ReadBuffer(Pointer(Result)^, Stream.Size);
  finally
    Stream.Free;
  end;
end;
}

function FileToStr( Filename: String ): String;
var FileStream : TFileStream;
    Bytes: TBytes;
begin
  Result:= '';
  if FileExists( FileName ) then begin
    FileStream:= TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      if FileStream.Size > 0 then begin
        SetLength(Bytes, FileStream.Size);
        FileStream.Read(Bytes[0], FileStream.Size);
      end;
      //Result:= TEncoding.ASCII.GetString(Bytes);
      Result:= TEncoding.ANSI.GetString(Bytes);
    finally
      FileStream.Free;
    end;
  end;
end;

procedure StrToFile(const FileName, SourceString: String);
var
  Stream : TFileStream;
begin
  Stream:= TFileStream.Create(FileName, fmCreate);
  try
    Stream.WriteBuffer(Pointer(SourceString)^, Length(SourceString));
  finally
    Stream.Free;
  end;
end;

procedure StrToAnsiFile(const FileName, SourceString: String);
var
  Stream : TFileStream;
  AStr: AnsiString;
begin
  Stream:= TFileStream.Create(FileName, fmCreate);
  try
    AStr:= AnsiString( SourceString );
    Stream.WriteBuffer(Pointer(AStr)^, Length(AStr));
  finally
    Stream.Free;
  end;
end;

function String2File(FileName: String; ToWrite: String): Boolean;
var NArch: TextFile;
Begin
  DeleteFile(PChar(Filename));
  Result:= True;
  {$IOCHECKS off}
  if ToWrite <> '' then begin
    AssignFile(NArch, Filename);
    Reset(NArch);
    if UpperCase(ToWrite) <> 'NULL' then begin
      ReWrite(NArch);
      Write(NArch, ToWrite);
    end;
    CloseFile(NArch);
    Result:= FileExists(Filename);
  end;
  {$IOCHECKS on}
end;

function InsertString(SubStr: String; TheStr: String; Idx: Integer ): String;
begin
  Result:= TheStr.Insert( Idx, SubStr );
end;

function IntBetween( AInt: Integer; First, Secound: Integer ): Boolean;
begin
  Result:= (AInt >= First) and (AInt <= Secound);
end;

function YearsOld(ADate, CurrentDate: String): Integer;
var AYear,AMonth,ADay: Word;
    TempDate: TDateTime;
    {ADateDT, }CurrDT: TDateTime;
    ADateArray, CurrDateArray: StringArray;
begin
  if (ADate <> '') and (CurrentDate <> '') then begin
    //ADateDT:= StrToDate( ADate );
    CurrDT:= StrToDate( CurrentDate );

    ADateArray:= Split( ADate, '/' );
    CurrDateArray:= Split( CurrentDate, '/' );

    AYear:= StrToInt(CurrDateArray[ 2 ]);
    AMonth:= StrToInt(ADateArray[ 1 ]);
    ADay:= StrToInt(ADateArray[ 0 ]);

    if TryEncodeDate(AYear, AMonth, ADay, TempDate) then begin
      Result:= StrToInt(CurrDateArray[ 2 ]) - StrToInt(ADateArray[ 2 ]);
      if CurrDT <= TempDate then begin
        Result:= StrToInt(CurrDateArray[ 2 ]) - StrToInt(ADateArray[ 2 ]) - 1;
      end;
    end
    else begin
      Result:= 0;
    end;
  end
  else begin
    Result:= 0;
  end;
end;

function PersonAge(ADate, CurrentDate: String): String;
var AYear,AMonth,ADay: Word;
    TempDate: TDateTime;
    ADateDT, CurrDT: TDateTime;
    ADateArray, CurrDateArray: StringArray;
begin
  Result:= '';
  if (ADate <> '') and (CurrentDate <> '') then begin
    ADateDT:= StrToDate( ADate );
    CurrDT:= StrToDate( CurrentDate );

    AYear:= DateUtils.YearsBetween(CurrDT, ADateDT);
    AMonth:= DateUtils.MonthsBetween(CurrDT, ADateDT);

    if AYear <= 1 then begin
      if AYear = 1 then begin
        Result:= '1 año ';
      end;
      AMonth:= AMonth - (AYear * 12);
      if AMonth <> 0 then begin
        Result:= Result + IntToStr(AMonth) + ' meses';
      end;
    end
    else begin
      Result:= IntToStr(AYear) + ' años';
    end;
  end
  else begin
    Result:= 'n/d';
  end;
end;

function GetTempDirectory: String;
var
  tempFolder: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

function GetSafeFilename(DirName, FileName: String): String;
var ANumber: Integer;
    FileExt: String;
begin
  FileExt:= ExtractFileExt( Filename );
  Filename:= Copy( Filename, 1, Length(Filename) - Length(FileExt));
  Result:= IncludeTrailingPathDelimiter( DirName ) + Filename;

  ANumber:= 1;
  while FileExists( Result + FileExt ) do begin
    Result:= IncludeTrailingPathDelimiter( DirName ) + Filename + '_' + IntToStr( ANumber );
    Inc( ANumber );
  end;
  Result:= Result + FileExt;
end;

function FileSize( FileName: String ): Int64;
var SR: TSearchRec;
begin
  if FindFirst(FileName, faAnyFile, SR ) = 0 then
    Result:= Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
  else
    Result:= 0;

  SysUtils.FindClose(SR) ;
end;

function PosQuita( SubStr: String; var Str: String ): Boolean;
begin
  if Pos( SubStr, Str ) > 0 then begin
    Result:= True;
    Str:= Copy( Str, Pos( SubStr, Str ) + Length( SubStr ), 1024);
  end
  else begin
    Result:= False;
  end;
end;

function INIReadStringAndExpand( FileName, Section, Ident: String ): String;
var ADummyData: StringArray;
    fINI, AINI: TINIFile;
begin
  fINI:= TINIFile.Create( Filename );
  Result:= fINI.ReadString( Section, Ident, '' );
  if (Result <> '') and (Result[ 1 ] = '{') then begin
    Result:= Copy( Result, 2, Length(Result) - 2 );
    ADummyData:= Split( Result, ':' );

    AINI:= TIniFile.Create( IncludeTrailingPathDelimiter( ExtractFilePath( Application.ExeName)) + ADummyData[ 0 ] );
    Result:= AINI.ReadString( ADummyData[ 1 ], ADummyData[ 2 ], '' );
    AINI.Free;
  end
  else begin
    Result:= fINI.ReadString( Section, Ident, '' );
  end;
  fINI.Free;
end;

function StringArrayAssign(Args: array of string): StringArray;
var I: Integer;
begin
  SetLength( Result, Length(Args) );
  for I:= Low(Args) to High(Args) do begin
    Result[i]:= Args[i];
  end;
end;

procedure PosInArray(Args: StringArray; TheStr: String; out Idx: Integer);
var I: Integer;
begin
  Idx:= -1;
  for I:= Low(Args) to High(Args) do begin
    if Pos( Args[I], TheStr ) > 0 then begin
      Idx:= I;
      Break;
    end;
  end;
end;

function DeQuotedStr(const S: String): String;
begin
  Result:= DeQuotedStr( Trim(S), '''' );
end;

function DeQuotedStr(const S: String; AQuote: Char): String;
begin
  Result:= AnsiDequotedStr( Trim(S), AQuote );
end;

function CopyToStrPos( St, ToStr: String ): String;
var ToPos: Integer;
begin
  ToPos:= Pos( UpperCase(ToStr), UpperCase(St) ) - 1;
  if ToPos = -1 then begin
    ToPos:= Length(St);
  end;
  Result:= Copy( St, 1, ToPos );
end;

function CopyFromStrPos( St, ToStr: String ): String;
var FromPos: Integer;
begin
  FromPos:= Pos( UpperCase(ToStr), UpperCase(St) ) + 1;
  if FromPos = -1 then begin
    FromPos:= 1;
  end;
  Result:= Copy( St, FromPos, St.Length );
end;

function AppPath: String;
begin
  Result:= IncludeTrailingPathDelimiter( ExtractFilePath( Application.ExeName ) );
end;

function ColorBlend(Color1, Color2: TColor; A: Byte): TColor;
var
  c1, c2: LongInt;
  r, g, b, v1, v2: byte;
begin
  A:= Round(2.55 * A);
  c1 := ColorToRGB(Color1);
  c2 := ColorToRGB(Color2);
  v1:= Byte(c1);
  v2:= Byte(c2);
  r:= A * (v1 - v2) shr 8 + v2;
  v1:= Byte(c1 shr 8);
  v2:= Byte(c2 shr 8);
  g:= A * (v1 - v2) shr 8 + v2;
  v1:= Byte(c1 shr 16);
  v2:= Byte(c2 shr 16);
  b:= A * (v1 - v2) shr 8 + v2;
  Result := (b shl 16) + (g shl 8) + r;
end;

function StrSQLDateToDate(St: String): TDate;
var ADay, AMonth, AYear: Word;
    AArray: StringArray;
begin
  AArray:= Split( DeQuotedStr( St ), '.' );
  ADay:= StrToIntCero(AArray[ 0 ]);
  AMonth:= StrToIntCero(AArray[ 1 ]);
  AYear:= StrToIntCero(AArray[ 2 ]);
  Result:= EncodeDate( AYear, AMonth, ADay );
end;

function StrToFloatDec( S: String ): Extended;
begin
  S:= StringReplace( S, FormatSettings.ThousandSeparator, FormatSettings.DecimalSeparator, [rfReplaceAll] );
  Result:= System.SysUtils.StrToFloat( S );
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

function StrToIntSafe( St: String ): Integer;
begin
  if StrIsInt( St ) then
    Result:= StrToInt( St )
  else
    Result:= 0;

end;

function CountOccurences( const SubText: String; const Text: String ): Integer;
begin
  if (SubText = '') or (Text = '') or (Pos(SubText, Text) = 0) then begin
    Result:= 0;
  end
  else begin
    Result:= (Length(Text) - Length(StringReplace(Text, SubText, '', [rfReplaceAll]))) div  Length(SubText);
  end;
end;

procedure TrimStringArray(var AArray: StringArray);
var Dummy: StringArray;
    I: Integer;
begin
  SetLength( Dummy, 0 );
  for I:= Low(AArray) to High(AArray) do begin
    if Not(AArray[ i ].IsEmpty) then begin
      SetLength( Dummy, Length( Dummy ) + 1 );
      Dummy[ High( Dummy ) ]:= AArray[ i ];
    end;
  end;
  AArray:= Dummy;
end;

procedure DeleteArrayIndex(var AArray: StringArray; AIndex: Integer);
var I: Integer;
begin
  for I:= AIndex to High(AArray) - 1 do begin
    AArray[ I ]:= AArray[ I + 1 ];
  end;
  SetLength( AArray, Length( AArray ) - 1 );
end;

procedure GetAssociatedIcon(FileName: TFilename; PLargeIcon, PSmallIcon: PHICON);
// Gets the icons of a given file
var
  IconIndex: UINT;  // Position of the icon in the file
  FileExt, FileType: string;
  Reg: TRegistry;
  p: integer;
  p1, p2: pchar;
label
  noassoc;
begin
  IconIndex := 0;
  // Get the extension of the file
  FileExt := UpperCase(ExtractFileExt(FileName));
  if ((FileExt <> '.EXE') and (FileExt <> '.ICO')) or
      not FileExists(FileName) then begin
    // If the file is an EXE or ICO and it exists, then
    // we will extract the icon from this file. Otherwise
    // here we will try to find the associated icon in the
    // Windows Registry...
    Reg := nil;
    try
      Reg := TRegistry.Create(KEY_QUERY_VALUE);
      Reg.RootKey := HKEY_CLASSES_ROOT;
      if FileExt = '.EXE' then FileExt := '.COM';
      if Reg.OpenKeyReadOnly(FileExt) then
        try
          FileType := Reg.ReadString('');
        finally
          Reg.CloseKey;
        end;
      if (FileType <> '') and Reg.OpenKeyReadOnly(
          FileType + '\DefaultIcon') then
        try
          FileName := Reg.ReadString('');
        finally
          Reg.CloseKey;
        end;
    finally
      Reg.Free;
    end;

    // If we couldn't find the association, we will
    // try to get the default icons
    if FileName = '' then goto noassoc;

    // Get the filename and icon index from the
    // association (of form '"filaname",index')
    p1 := PChar(FileName);
    p2 := StrRScan(p1, ',');
    if p2 <> nil then begin
      p := p2 - p1 + 1; // Position of the comma
      IconIndex := StrToInt(Copy(FileName, p + 1,
        Length(FileName) - p));
      SetLength(FileName, p - 1);
    end;
  end;
  // Attempt to get the icon
  if ExtractIconEx(pchar(FileName), IconIndex,
      PLargeIcon^, PSmallIcon^, 1) <> 1 then
  begin
noassoc:
    // The operation failed or the file had no associated
    // icon. Try to get the default icons from SHELL32.DLL

    try // to get the location of SHELL32.DLL
      //FileName := IncludeTrailingBackslash(GetSystemDir)
      //  + 'SHELL32.DLL';
    except
      FileName := 'C:\WINDOWS\SYSTEM\SHELL32.DLL';
    end;
    // Determine the default icon for the file extension
    if      (FileExt = '.DOC') then IconIndex := 1
    else if (FileExt = '.EXE')
         or (FileExt = '.COM') then IconIndex := 2
    else if (FileExt = '.HLP') then IconIndex := 23
    else if (FileExt = '.INI')
         or (FileExt = '.INF') then IconIndex := 63
    else if (FileExt = '.TXT') then IconIndex := 64
    else if (FileExt = '.BAT') then IconIndex := 65
    else if (FileExt = '.DLL')
         or (FileExt = '.SYS')
         or (FileExt = '.VBX')
         or (FileExt = '.OCX')
         or (FileExt = '.VXD') then IconIndex := 66
    else if (FileExt = '.FON') then IconIndex := 67
    else if (FileExt = '.TTF') then IconIndex := 68
    else if (FileExt = '.FOT') then IconIndex := 69
    else IconIndex := 0;
    // Attempt to get the icon.
    if ExtractIconEx(pchar(FileName), IconIndex,
        PLargeIcon^, PSmallIcon^, 1) <> 1 then
    begin
      // Failed to get the icon. Just "return" zeroes.
      if PLargeIcon <> nil then PLargeIcon^ := 0;
      if PSmallIcon <> nil then PSmallIcon^ := 0;
    end;
  end;
end;

procedure LoadIconInTImage(AFileName: String; var AImage: TImage);
var LargeIcon: HICON;
begin
  GetAssociatedIcon(AFileName, @LargeIcon, nil);
  if (LargeIcon <> 0) then begin
    AImage.Picture.Icon.Handle:= LargeIcon;
  end;
end;

function CUITDigitoVerificador( CUIT: String; out Verificador: String ): String;
var I, MultiBy, Sumatoria: Integer;
    AllNumbers: Boolean;
begin
  if (CUIT.Length = 13) or (CUIT.Length = 12) or (CUIT.Length = 11) or (CUIT.Length = 10) then begin
    if ((CUIT.Length = 13) and (CUIT[ 3 ] = '-') and (CUIT[ 12 ] = '-')) then begin
      CUIT:= StringReplace( CUIT, CUIT[ 3 ], '', [rfReplaceAll] );
    end;
    AllNumbers:= True;
    for I:= 1 to CUIT.Length do begin
      if (CUIT[ I ] < '0') or (CUIT[ I ] > '9') then begin
        AllNumbers:= False;
      end;
    end;

    if AllNumbers then begin
      Sumatoria:= 0;
      MultiBy:= 2;
      if CUIT.Length = 11 then
        CUIT:= Copy( CUIT, 1, 10 );

      for I:= CUIT.Length downto 1 do begin
        Sumatoria:= Sumatoria + (StrToInt( CUIT[ I ] ) * MultiBy);

        if MultiBy = 7 then
          MultiBy:= 2
        else
          Inc(MultiBy);
      end;

      Sumatoria:= 11 - (Sumatoria mod 11);
      Verificador:= IntToStr( Sumatoria );
      case Sumatoria of
        10: Sumatoria:= 9;
        11: Sumatoria:= 0;
      end;
      Result:= IntToStr(Sumatoria);
    end;
  end;
end;

function GetCUITFromDNI( DNI: String; HombreMujerSociedad: Char ): String;
var PreFijo, Verificador: String;
begin
  if DNI.Length < 8 then begin
    DNI:= Space( 7 - DNI.Length, '0' ) + DNI;
  end;

  case HombreMujerSociedad of
    'H': PreFijo:= '20';
    'M': PreFijo:= '27';
    'S': PreFijo:= '30';
  end;
  if DNI.Length = 11 then
    PreFijo:= '';

  CUITDigitoVerificador( Prefijo + DNI, Verificador );
  if Verificador = '10' then begin
    case HombreMujerSociedad of
      'H': PreFijo:= '24';
      'M': PreFijo:= '23';
      'S': PreFijo:= '33';
    end;
  end;
  Result:= Prefijo + DNI + CUITDigitoVerificador( Prefijo + DNI, Verificador );
end;

procedure TrimArrayAnyChar( var AArray: StringArray );
var I: Integer;
    ResultArray: StringArray;
begin
  SetLength( ResultArray, 0 );
  for I:= Low( AArray ) to High( AArray ) do begin
    AArray[ i ]:= Trim( AArray[ i ] );
    if AArray[ i ] <> '' then begin
      SetLength( ResultArray, Length( ResultArray ) + 1 );
      ResultArray[ High( ResultArray ) ]:= AArray[ i ];
    end;
  end;
  AArray:= ResultArray;
end;

function StrToDateTimeMillisecond(const S: string): TDateTime;
var AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
begin
  AYear:= StrToInt(Copy( S, 7, 4 ));
  AMonth:= StrToInt(Copy( S, 4, 2 ));
  ADay:= StrToInt(Copy( S, 1, 2 ));
  if Length( S ) > 10 then begin
    AHour:= StrToInt(Copy( S, 13, 2 ));
    AMinute:= StrToInt(Copy( S, 16, 2 ));
    if Length( S ) >= 19 then begin
      ASecond:= StrToInt(Copy( S, 19, 2 ));
      if Length( S ) >= 22 then begin
        AMilliSecond:= StrToInt(Copy( S, 22, 3 ));
      end
      else begin
        AMilliSecond:= 0;
      end;
    end
    else begin
      ASecond:= 0;
    end;
  end
  else begin
    AHour:= 0;
    AMinute:= 0;
    ASecond:= 0;
    AMilliSecond:= 0;
  end;
  Result:= EncodeDateTime( AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond );
end;

function FormatCustom(const Format: String; const Args: array of const): String;
begin
  Result := System.SysUtils.Format(Format, Args, FormatSettings);
end;

function ResolveString( AStr: String ): String;
begin
  Result:= StringReplace( AStr, '{app}', ExcludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName )), [rfReplaceAll]);
end;

procedure QuickSort(var AnArray: StringArray; iLo: Integer = -1; iHi: Integer = -1);
var Lo, Hi: Integer;
    Pivot, T: String;
    Sigue: Boolean;
begin
  if Length( AnArray ) > 1 then begin
    Sigue:= (iLo = -1) or (iHi = -1);
    if iLo = -1 then
      iLo:= Low( AnArray );

    if iHi = -1 then
      iHi:= High( AnArray );


    Lo:= iLo;
    Hi:= iHi;
    Pivot := AnArray[(Lo + Hi) div 2];
    repeat
     while AnArray[Lo] < Pivot do Inc(Lo) ;
     while AnArray[Hi] > Pivot do Dec(Hi) ;
     if Lo <= Hi then
     begin
       T := AnArray[Lo];
       AnArray[Lo] := AnArray[Hi];
       AnArray[Hi] := T;
       Inc(Lo) ;
       Dec(Hi) ;
     end;
    until Lo > Hi;
    if (Hi > Low( AnArray )) and (Sigue) then QuickSort(AnArray, Low( AnArray ), Hi) ;
    if (Lo < High( AnArray )) and (Sigue) then QuickSort(AnArray, Lo, High( AnArray )) ;
  end;
end;

function MakeFileName( FilePath, FileName: String ): String;
begin
  Result:= IncludeTrailingPathDelimiter( FilePath ) + FileName;
end;

procedure CombineTwoStringList( List1, List2: TStringList );
var I: Integer;
begin
  for I:= 0 to List2.Count - 1 do begin
    if List1.IndexOf( List2[ I ] ) = -1 then begin
      List1.Add( List2[ I ] );
    end;
  end;
end;

procedure CopyMemIniFile( AMemINIFile: TMemIniFile; var Result: TMemIniFile );
var AStrList: TStringList;
begin
  AStrList:= TStringList.Create;
  AMemINIFile.GetStrings( AStrList );
  if Result = nil then begin
    Result:= TMemIniFile.Create( AMemINIFile.FileName );
  end;
  Result.Clear;
  Result.SetStrings( AStrList );
  AStrList.Free;
end;

function FileSearchPattern( DirName, Pattern: String; Recursive: Boolean = True): String;
var SR, SR2: TSearchRec;
    FileExts: StringArray;
    I: Integer;
    DummyStr: String;
begin
  FileExts:= Split( Pattern, ';' );

  Result:= '';
  DirName:= IncludeTrailingPathDelimiter( DirName );
  if FindFirst(DirName + '*', faDirectory + faHidden, SR ) = 0 then begin
    repeat
      if (((SR.Attr and faDirectory) <> 0) and (SR.Name = '.')) then begin
        for I:= Low(FileExts) to High(FileExts) do begin
          if FindFirst( IncludeTrailingPathDelimiter(DirName) + FileExts[ I ], $27, SR2) = 0 then begin
            repeat
              Result:= Result + DirName + SR2.Name + ';';
            until FindNext(SR2) <> 0;
          end;
          SysUtils.FindClose(SR2);
        end;
      end;

      if (((SR.Attr and faDirectory) <> 0) and (SR.Name <> '.') and (SR.Name <> '..') and (Recursive)) then begin
        DummyStr:= FileSearchPattern( IncludeTrailingPathDelimiter( DirName ) + SR.Name, Pattern );
        if DummyStr <> '' then begin
          Result:= Result + DummyStr + ';';
        end;
      end;
    until FindNext( SR ) <> 0;
    SysUtils.FindClose( SR );
  end;
  Result:= DeleteLastString( Result, ';' );
end;

function DirSearchPattern( DirName: String; Recursive: Boolean = True): String;
var SR: TSearchRec;
    FileExts: StringArray;
    I: Integer;
    DummyStr: String;
begin
  Result:= '';
  DirName:= IncludeTrailingPathDelimiter( DirName );
  if FindFirst(DirName + '*', faDirectory + faHidden, SR ) = 0 then begin
    repeat
      if (((SR.Attr and faDirectory) = faDirectory) and ((SR.Name <> '.') and (SR.Name <> '..'))) then begin
        if ((SR.Name <> '.') and (SR.Name <> '..')) then begin
          Result:= Result + DirName + SR.Name + ';';
        end;
      end;
    until FindNext( SR ) <> 0;
    SysUtils.FindClose( SR );
  end;
  Result:= DeleteLastString( Result, ';' );
end;

function OpenDlg( Title, Filter, InitialDir: String; var FileNames: StringArray ): Boolean; overload;
var OD: TOpenDialog;
    I: Integer;
begin
  OD:= TOpenDialog.Create( nil );
  OD.Title:= Title;
  OD.Filter:= Filter;
  OD.InitialDir:= InitialDir;
  if OD.Execute then begin
    Result:= True;
    SetLength( FileNames, OD.Files.Count );
    for I:= 0 to OD.Files.Count - 1 do begin
      FileNames[ I ]:= OD.Files[ 0 ];
    end;
  end
  else begin
    Result:= False;
  end;
  OD.Free;
end;

function OpenDlg( Title, Filter, InitialDir: String; var FileName: String ): Boolean; overload;
var FileNames: StringArray;
begin
  Result:= OpenDlg( Title, Filter, InitialDir, FileNames );
  if Result then begin
    FileName:= FileNames[ 0 ];
  end
  else begin
    FileName:= '';
  end;
end;

function SaveDlg( Title, Filter, InitialDir, DefaultExt: String; var FileName: String ): Boolean;
var SD: TSaveDialog;
begin
  SD:= TSaveDialog.Create( nil );
  SD.Title:= Title;
  SD.Filter:= Filter;
  SD.InitialDir:= InitialDir;
  SD.DefaultExt:= DefaultExt;
  SD.FileName:= FileName;
  if SD.Execute then begin
    Result:= True;
    FileName:= SD.FileName;
  end
  else begin
    Result:= False;
  end;
  SD.Free;
end;

function MsgBox(const Text, Caption: String; Flags: Longint): Integer; overload;
begin
  Result:= Application.MessageBox( PChar( Text ), PChar( Caption ), Flags );
end;

function MsbBox(AOwner: TComponent; const Text, Caption: String; ImageType: PChar; Args: array of String): Integer; overload;
// ImageType puede ser:
// IDI_APPLICATION, IDI_HAND, IDI_QUESTION, IDI_EXCLAMATION, IDI_ASTERISK, IDI_WINLOGO
var F: TForm;
    ALabel: TLabel;
    AButton: TButton;
    AImage: TImage;
begin
  F:= TForm.Create( AOwner );
  F.Position:= poScreenCenter;
  F.BorderIcons:= [biSystemMenu];
  F.BorderStyle:= bsDialog;
  F.Caption:= Caption;

  AImage:= TImage.Create( F );
  AImage.Parent:= F;
  CargarIcono( AImage, ImageType );
  AImage.Top:= 8;
  AImage.Left:= 8;

  ALabel:= TLabel.Create( F );
  ALabel.Parent:= F;
  ALabel.Top:= 32;
  ALabel.Left:= 8 + AImage.Left + AImage.Width;
  ALabel.WordWrap:= True;
  ALabel.Caption:= Text;
  if F.Canvas.TextWidth( ALabel.Caption ) > (Screen.Width * 0.80) then begin
    ALabel.AutoSize:= False;
    ALabel.Width:= Trunc((Screen.Width * 0.80) - 64);
  end
  else begin
    ALabel.AutoSize:= True;
  end;
  F.ClientWidth:= ALabel.Left + ALabel.Width;


  F.ClientHeight:= 211;
  Result:= F.ShowModal;
end;

function ComponeFileName( OriginalFN, TempFN: String ): String;
var I: Integer;
    BaseDir, OriginalUpper: String;
begin
  OriginalUpper:= UpperCase( OriginalFN );
  BaseDir:= UpperCase( PathDelim + IncludeTrailingPathDelimiter( ExtractFileName( ExcludeTrailingPathDelimiter( TempFN )) ) );
  I:= 1;
  while (Copy( OriginalUpper, I, BaseDir.Length ) <> BaseDir) and (I < OriginalUpper.Length) do begin
    Inc( I );
  end;
  if I = OriginalUpper.Length then begin
    //TempFN:= ExcludeTrailingPathDelimiter(ExtractFilePath( ExcludeTrailingPathDelimiter( ExtractFilePath( ExcludeTrailingPathDelimiter( TempFN ))))) + BaseDir + ExtractFileName(ExcludeTrailingPathDelimiter(ExtractFilePath( ExcludeTrailingPathDelimiter( OriginalFN ))));
    //TempFN:= StringReplace(  )
    Result:= ComponeFileName( OriginalFN, TempFN );
  end
  else begin
    Result:= IncludeTrailingPathDelimiter( TempFN ) + Copy( OriginalFN, I + BaseDir.Length, OriginalFN.Length );
  end;
end;

procedure DeleteDirRecursively(const DirName: String);
var FileOp: TSHFileOpStruct;
begin
  FillChar(FileOp, SizeOf(FileOp), 0);
  FileOp.wFunc := FO_DELETE;
  FileOp.pFrom := PChar(DirName+#0);//double zero-terminated
  FileOp.fFlags := FOF_SILENT or FOF_NOERRORUI or FOF_NOCONFIRMATION;
  SHFileOperation(FileOp);
end;

function CopyFileDlg(SourceFile: String; TargetFile: String; Silent: Boolean = True): Boolean;
var FS: TSHFileOpStruct;
begin
  FS.Wnd:= Application.DialogHandle;
  FS.wFunc:= FO_COPY;
  FS.pFrom:= PWideChar(SourceFile + #0);
  FS.pTo:= PWideChar(TargetFile + #0);
  if Silent then begin
    FS.fFlags:= FOF_NOCONFIRMATION + FOF_SILENT
  end
  else begin
    FS.fFlags:= FOF_NOCONFIRMATION;
  end;
  try
    Result:= (SHFileOperation(FS) = 0);
  except
    Result:= False;
  end;
end;

function StringEqualsTo( Str, Str2: String; IgnoreCase: Boolean = False ): Integer;
var I: Integer;
begin
  if IgnoreCase then begin
    Str:= Str.ToUpper;
    Str2:= Str2.ToUpper;
  end;
  I:= 1;
  while (StringStartWith( Copy(Str, 1, I ), Copy(Str2, 1, I ) )) and (I < Str2.Length) do begin
    Inc( I );
  end;

  Result:= I - 1;
end;

function StrIsPartOfIdx( Haystack, Needle: String; Idx: Integer; out Count: Integer; IgnoreCase: Boolean = False ): Boolean;
begin
  if IgnoreCase then begin
    Haystack:= LowerCase( Haystack );
    Needle:= LowerCase( Needle );
  end;
  Result:= Copy( Haystack, Idx, Needle.Length ) = Needle;
  Count:= Needle.Length;
end;

function StrHasAnyOfArray(AStr: String; out Idx: Integer; Args: array of String): Boolean;
var I: Integer;
begin
  Result:= False;
  Idx:= -1;
  for I:= Low(Args) to High(Args) do begin
    if Pos( Args[ I ], AStr ) > 0 then begin
      Result:= True;
      Idx:= I;
      Exit;
    end;
  end;
end;

function StrStartWithAnyOfArray(AStr: String; out Idx: Integer; Args: array of String): Boolean;
var I: Integer;
begin
  Result:= False;
  Idx:= -1;
  for I:= Low(Args) to High(Args) do begin
    if StringStartWith( AStr, Args[ I ] ) then begin
      Result:= True;
      Idx:= I;
      Exit;
    end;
  end;
end;

function AddStrToVector(AStr: String; Args: StringArray): StringArray;
begin
  SetLength( Args, Length( Args ) + 1 );
  Result:= Copy( Args, 1, Length( Args ) );
  Result[ High(Result) ]:= AStr;
end;

function StringsEqualTo( Str1, Str2: String; IgnoreCase: Boolean = False ): Integer;
var I: Integer;
    Str2Inter: String;
begin
  if IgnoreCase then begin
    Str1:= Str1.ToUpper;
    Str2:= Str2.ToUpper;
  end;
  if Str2.Length < Str1.Length then begin
    Str2Inter:= Str1;
    Str1:= Str2;
    Str2:= Str2Inter;
  end;

  Result:= -1;
  I:= 1;
  while (I <= Str1.Length) and (Str1[ I ] = Str2[ I ]) do begin
    Inc( I );
  end;
  Result:= I - 1;
end;

function CopyRight(S: String; Count: Integer): String;
begin
  Result:= Copy(S, S.Length - Count + 1, Count);
end;

end.
