// 2016 Luciano Olocco
// Email: lolocco@gmail.com

unit ComboBoxHelper;

interface

uses StringListHelper, Vcl.StdCtrls;

type
  TComboBoxHelper = class helper for TComboBox
    procedure AddItemAndStoreString( ItemCaption, AStrToStore: String );
    function StoredStr( Index: Integer ): String;
    procedure FreeTheStoredStrings;
  end;

implementation

{ TComboBoxHelper }

procedure TComboBoxHelper.AddItemAndStoreString(ItemCaption, AStrToStore: String);
begin
  Self.Items.AddItemAndStoreString( ItemCaption, AStrToStore );
end;

procedure TComboBoxHelper.FreeTheStoredStrings;
begin
  Self.Items.FreeTheStoredStrings;
end;

function TComboBoxHelper.StoredStr(Index: Integer): String;
begin
  Result:= Self.Items.StoredStr( Index );
end;

end.
