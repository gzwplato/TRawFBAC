// 2016 Luciano Olocco
// Email: lolocco@gmail.com

unit ComboBoxHelper;

interface

uses StringListHelper, Vcl.StdCtrls;

type
  TComboBoxHelper = class helper for TComboBox
    procedure AddItemAndStoreString(ItemCaption, AStrToStore: String);
    function StoredStr(Index: Integer): String;
    function StoredSelected: String;
    procedure FreeTheStoredStrings;
    function IndexOfStoredStr(AStr: String): Integer;
  end;

implementation

{ TComboBoxHelper }

procedure TComboBoxHelper.AddItemAndStoreString(ItemCaption, AStrToStore: String);
begin
  Self.Items.AddItemAndStoreString(ItemCaption, AStrToStore);
end;

procedure TComboBoxHelper.FreeTheStoredStrings;
begin
  Self.Items.FreeTheStoredStrings;
end;

function TComboBoxHelper.IndexOfStoredStr(AStr: String): Integer;
var I: Integer;
begin
  Result:= -1;
  for I:= 0 to Self.Items.Count - 1 do begin
    if AStr = StoredStr(I) then begin
      Result:= I;
      Exit;
    end;
  end;
end;

function TComboBoxHelper.StoredSelected: String;
begin
  Result:= StoredStr(Self.ItemIndex);
end;

function TComboBoxHelper.StoredStr(Index: Integer): String;
begin
  Result:= Self.Items.StoredStr(Index);
end;

end.
