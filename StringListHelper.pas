// 2016 Luciano Olocco
// Email: lolocco@gmail.com

unit StringListHelper;

interface

uses System.Classes;

type
   TString = class(TObject)
   private
     fStr: String;
   public
     constructor Create(const AStr: String);
     property Str: String read fStr write fStr;
   end;

type
  TStringListHelper = class helper for TStrings
    procedure AddItemAndStoreString(ItemCaption, AStrToStore: String; Position: Integer = -1);
    function StoredStr(Index: Integer): String;
    procedure SetStoredStr(Index: Integer; AValue: String);
    procedure FreeTheStoredStrings;
    procedure DeleteAItemAndFreeStored(Index: Integer);
    function StoredStrIndex(AStoredStr: String): Integer;
    procedure DeleteAItem(StoredStr: String);
  end;

implementation

{ TString }

constructor TString.Create(const AStr: String) ;
begin
   inherited Create;
   FStr := AStr;
end;

{ TStringListHelper }

procedure TStringListHelper.AddItemAndStoreString(ItemCaption, AStrToStore: String; Position: Integer = -1);
var AStr, AStrStored: String;
    I: Integer;
begin
  Self.AddObject( ItemCaption, TString.Create( AStrToStore ) );
  if Position > -1 then begin
    AStrStored:= StoredStr(Self.Count - 1);
    AStr:= Self.Strings[Self.Count - 1];
    for I:= Self.Count - 1 downto Position + 1 do begin
      Self.SetStoredStr(I, Self.StoredStr(I - 1));
      Self.Strings[I]:= Self.Strings[I - 1];
    end;
    Self.SetStoredStr(Position, AStrStored);
    Self.Strings[Position]:= AStr;
  end;
end;

procedure TStringListHelper.DeleteAItem(StoredStr: String);
var Idx: Integer;
begin
  Idx:= StoredStrIndex(StoredStr);
  if Idx > -1 then begin
    DeleteAItemAndFreeStored(Idx);
  end;
end;

procedure TStringListHelper.DeleteAItemAndFreeStored(Index: Integer);
begin
  if Index <> -1 then begin
    TString(Self.Objects[ Index ]).Free;
    Self.Objects[ Index ]:= nil;
    Self.Delete( Index );
  end;
end;

procedure TStringListHelper.FreeTheStoredStrings;
var i: Integer;
begin
  for i:= 0 to Self.Count - 1 do begin
    if (Assigned(Self.Objects[ i ])) and (Self.Objects[ i ] <> nil) then begin
      TString(Self.Objects[ i ]).Free;
      Self.Objects[ i ]:= nil;
    end;
  end;
end;

procedure TStringListHelper.SetStoredStr(Index: Integer; AValue: String);
begin
  (Self.Objects[ Index ] as TString).Str:= AValue;
end;

function TStringListHelper.StoredStr(Index: Integer): String;
begin
  Result:= (Self.Objects[ Index ] as TString).Str;
end;

function TStringListHelper.StoredStrIndex(AStoredStr: String): Integer;
var I: Integer;
begin
  Result:= -1;
  for I:= 0 to Count - 1 do begin
    if AStoredStr = StoredStr(I) then begin
      Result:= I;
      Exit;
    end;
  end;
end;

end.