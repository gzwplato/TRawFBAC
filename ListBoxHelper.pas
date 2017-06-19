// 2016 Luciano Olocco
// Email: lolocco@gmail.com

unit ListBoxHelper;

interface

uses StringListHelper, Vcl.StdCtrls;

type
  TListBoxHelper = class helper for TListBox
    procedure AddItemAndStoreString( ItemCaption, AStrToStore: String );
    function StoredStr( Index: Integer ): String;
    procedure FreeTheStoredStrings;
  end;

implementation

{ TComboBoxHelper }

procedure TListBoxHelper.AddItemAndStoreString(ItemCaption, AStrToStore: String);
begin
  Self.Items.AddItemAndStoreString( ItemCaption, AStrToStore );
end;

procedure TListBoxHelper.FreeTheStoredStrings;
begin
  Self.Items.FreeTheStoredStrings;
end;

function TListBoxHelper.StoredStr(Index: Integer): String;
begin
  Result:= Self.Items.StoredStr( Index );
end;

end.