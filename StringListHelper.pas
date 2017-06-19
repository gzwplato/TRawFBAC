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
    procedure AddItemAndStoreString( ItemCaption, AStrToStore: String );
    function StoredStr( Index: Integer ): String;
    procedure FreeTheStoredStrings;
    procedure DeleteAItemAndFreeStored( Index: Integer );
  end;

implementation

{ TString }

constructor TString.Create(const AStr: String) ;
begin
   inherited Create;
   FStr := AStr;
end;

{ TStringListHelper }

procedure TStringListHelper.AddItemAndStoreString(ItemCaption, AStrToStore: String);
begin
  Self.AddObject( ItemCaption, TString.Create( AStrToStore ) );
end;

procedure TStringListHelper.DeleteAItemAndFreeStored(Index: Integer);
begin
  TString(Self.Objects[ Index ]).Free;
  Self.Objects[ Index ]:= nil;
  Self.Delete( Index );
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

function TStringListHelper.StoredStr(Index: Integer): String;
begin
  Result:= (Self.Objects[ Index ] as TString).Str;
end;

end.