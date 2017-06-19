unit URawFBACBrowser;

interface

uses
  Lucho,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ImgList, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmRawFBACBrowser = class(TForm)
    GridBrowser: TNextGrid;
    edtBuscar: TButtonedEdit;
    Label1: TLabel;
    ImageList1: TImageList;
    btnAceptar: TButton;
    btnCancelar: TButton;
    cmbField: TComboBox;
    btnEliminar: TButton;
    btnModificar: TButton;
    btnNuevo: TButton;
    lblRecordCount: TLabel;
    procedure edtBuscarRightButtonClick(Sender: TObject);
    procedure edtBuscarChange(Sender: TObject);
    procedure edtBuscarLeftButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtBuscarKeyPress(Sender: TObject; var Key: Char);
    procedure GridBrowserKeyPress(Sender: TObject; var Key: Char);
    procedure edtBuscarKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridBrowserSelectCell(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
    fTable: String;
  public
    { Public declarations }
    fCanDeleteInBrowser: Boolean;
    fBrowseEnableWithDelete: BooleanArray;
    property Table: String read fTable write fTable;
    procedure ShowCantidad;
  end;

var
  frmRawFBACBrowser: TfrmRawFBACBrowser;

implementation

{$R *.dfm}

function ExtractSimbolFromMultiByteChar(Text: PAnsiChar): Char;
var Buffer: Char;
    Size: Integer;
begin
  Size:= MultiByteToWideChar(0,0,Text,-1,nil,0);
  if (Size > 0) then
  begin
    MultiByteToWideChar(0, MB_COMPOSITE, Text, -1, @Buffer, Size);
    Result:= Buffer;
  end;
end;

function ClearMultiByteChar(Text: String): String;
var i: Integer;
begin
  Result:= '';
  for I:= 1 to Length(Text) do begin
    Result:= Result + ExtractSimbolFromMultiByteChar(PAnsiChar(AnsiString(text[i])));
  end;
end;

procedure TfrmRawFBACBrowser.edtBuscarChange(Sender: TObject);
begin
  edtBuscar.RightButton.Visible:= (Trim(edtBuscar.Text) <> '');
end;

procedure TfrmRawFBACBrowser.edtBuscarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 38 then begin
    if GridBrowser.SelectedRow > 0 then begin
      GridBrowser.SelectedRow:= GridBrowser.SelectedRow - 1;
    end;
  end;
  if Key = 40 then begin
    if GridBrowser.SelectedRow < GridBrowser.RowCount then begin
      GridBrowser.SelectedRow:= GridBrowser.SelectedRow + 1;
    end;
  end;
  GridBrowser.ScrollToRow( GridBrowser.SelectedRow );
end;

procedure TfrmRawFBACBrowser.edtBuscarKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key:= #0;
    edtBuscarLeftButtonClick( edtBuscar );
  end;
end;

procedure TfrmRawFBACBrowser.edtBuscarLeftButtonClick(Sender: TObject);
var i, Rep, Desde: Integer;
    StrEdt, StrGrid: String;
    Found: Boolean;
begin
  Rep:= 0;
  Found:= False;
  StrEdt:= LowerCase( edtBuscar.Text );
  if (GridBrowser.SelectedRow+1 = GridBrowser.RowCount) then
    Desde:= 0
  else
    Desde:= (GridBrowser.SelectedRow + 1);

  while Rep <= 1 do begin
    for I:= Desde to (GridBrowser.RowCount - 1) do begin
      StrGrid:= ClearMultiByteChar( LowerCase(Copy( GridBrowser.Cell[ cmbField.ItemIndex+1, i ].AsString, 1, Length( StrEdt ))));
      if StrComp( PChar( StrEdt ), PChar( StrGrid) ) = 0 then begin
        GridBrowser.SelectedRow:= i;
        GridBrowser.ScrollToRow( i );
        Found:= True;
        Break;
      end;
    end;
    Inc( Rep );
    Desde:= 0;
    if Found then begin
      Rep:= 2;
    end;
  end;
  if (Not(Found) and (Rep >= 1)) then begin
    Application.MessageBox( PChar( 'El texto buscado no se encuentra en la lista' ), PChar( Self.Caption ), MB_OK+MB_ICONEXCLAMATION );
  end;
end;

procedure TfrmRawFBACBrowser.edtBuscarRightButtonClick(Sender: TObject);
begin
  edtBuscar.Text:= '';
end;

procedure TfrmRawFBACBrowser.FormShow(Sender: TObject);
begin
  GridBrowser.SetFocus;
  ShowCantidad;
end;

procedure TfrmRawFBACBrowser.GridBrowserKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Ord(Key) > 32) and (Ord(Key) < 256) then begin
    edtBuscar.SetFocus;
    edtBuscar.Text:= edtBuscar.Text + Key;
    edtBuscar.SelStart:= Length( edtBuscar.Text );
  end;
  if (Ord(Key) = 13) then begin
    btnAceptar.SetFocus;
  end;
end;

procedure TfrmRawFBACBrowser.GridBrowserSelectCell(Sender: TObject; ACol, ARow: Integer);
var I: Integer;
begin
  btnAceptar.Enabled:= (ARow > -1) and (GridBrowser.RowVisible[ ARow ]);
  btnEliminar.Enabled:= (btnAceptar.Enabled) and (fCanDeleteInBrowser);
  btnModificar.Enabled:= btnAceptar.Enabled;

  for I:= Low(fBrowseEnableWithDelete) to High(fBrowseEnableWithDelete) do begin
    (FindComponent( 'boton' + IntToStr( i ) ) as TButton).Enabled:= btnModificar.Enabled;
    // fBrowseEnableWithDelete[ i ]
  end;
end;

procedure TfrmRawFBACBrowser.ShowCantidad;
begin
  case GridBrowser.RowCount of
    0: lblRecordCount.Caption:= 'No hay registros';
    1: lblRecordCount.Caption:= '1 registro';
  else
    lblRecordCount.Caption:= FormatFloat( '#', GridBrowser.RowCount) + ' registros';
  end;
end;

end.
