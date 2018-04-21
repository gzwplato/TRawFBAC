unit URawFBACBrowser;

interface

uses
  Lucho, RawFBAC,
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
    btnImportar: TButton;
    procedure edtBuscarRightButtonClick(Sender: TObject);
    procedure edtBuscarChange(Sender: TObject);
    procedure edtBuscarLeftButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtBuscarKeyPress(Sender: TObject; var Key: Char);
    procedure GridBrowserKeyPress(Sender: TObject; var Key: Char);
    procedure edtBuscarKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridBrowserSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnImportarClick(Sender: TObject);
  private
    { Private declarations }
    fTable, fINI: String;
    fARawFBACInstance: TRawFBAC;
  public
    { Public declarations }
    fCanDeleteInBrowser: Boolean;
    fBrowseEnableWithDelete: BooleanArray;
    fBrowseOnWrite: Boolean;
    fBrowserSearchStarts: Boolean;
    property Table: String read fTable write fTable;
    property INI: String read fINI write fINI;
    property ARawFBACInstance: TRawFBAC read fARawFBACInstance write fARawFBACInstance;
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

procedure TfrmRawFBACBrowser.btnImportarClick(Sender: TObject);
var AFileName: String;
    DeleteContent: Boolean;
    Response: Integer;
begin
  if OpenDlg('Seleccione el archivo a importar/restaurar', 'Archivos de texto|*.csv;*.txt|Todos los archivos|*.*', ExtractFilePath(Application.ExeName), AFileName) then begin
    DeleteContent:= False;
    Response:= MsgBox('Se va a importar/restaurar el siguiente archivo:'+#13#10+AFileName+#13#10#13#10+'¿Desea borrar el contenido e importar los datos?'+#13#10#9+'Seleccione Si para borrar e importar los datos del archivo.'+#13#10#9+'Seleccione No para importar los datos sin eliminar el contenido actual.'+#13#10#9+'Seleccione Cancelar para dejar los datos como están.', 'Importar archivo', MB_YESNOCANCEL + MB_ICONQUESTION);
    case Response of
      mrYes: DeleteContent:= True;
      mrNo: DeleteContent:= False;
      mrCancel: Exit;
    end;
    fARawFBACInstance.RestoreFromFile(AFileName, DeleteContent);
  end;
end;

procedure TfrmRawFBACBrowser.edtBuscarChange(Sender: TObject);
begin
  edtBuscar.RightButton.Visible:= (Trim(edtBuscar.Text) <> '');
  if fBrowseOnWrite then begin
    edtBuscarLeftButtonClick(edtBuscar);
  end;
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
    if fBrowseOnWrite then begin
      btnAceptar.Click;
    end
    else begin
      edtBuscarLeftButtonClick( edtBuscar );
    end;
  end;
end;

procedure TfrmRawFBACBrowser.edtBuscarLeftButtonClick(Sender: TObject);
var I, J, Rep, Desde: Integer;
    StrEdt, StrGrid: String;
    Found: Boolean;
begin
  if ARawFBACInstance.IsBigTable then begin
    GridBrowser.BeginUpdate;
    GridBrowser.ClearRows;
    StrGrid:= Copy(GridBrowser.Columns[cmbField.ItemIndex + 1].Name, 6, 255);
    if fBrowserSearchStarts then begin
      fARawFBACInstance.CreateRecordSetLinked(StrGrid + '=' + LowerCase(edtBuscar.Text) + '%');
    end
    else begin
      fARawFBACInstance.CreateRecordSetLinked(StrGrid + ' like %' + LowerCase(edtBuscar.Text) + '%');
    end;
    GridBrowser.AddRow(fARawFBACInstance.RecordCount);
    for I:= 0 to fARawFBACInstance.RecordCount - 1 do begin
      GridBrowser.Cell[GridBrowser.ColumnByName[ 'NxColUniqueField' ].Position, I].AsString:= fARawFBACInstance.Field[fARawFBACInstance.UniqueField];
      for J:= 1 to GridBrowser.Columns.Count - 1 do begin
        if StringStartWith(GridBrowser.Columns[J].Name, 'NxCol', True) then begin
          StrEdt:= Copy(GridBrowser.Columns[J].Name, 6, 255);
        end
        else begin
          StrEdt:= GridBrowser.Columns[J].Name;
        end;
        GridBrowser.Cell[J, I].AsString:= fARawFBACInstance.FieldLinked[StrEdt];
      end;
      fARawFBACInstance.NextRecord;
    end;
    GridBrowser.EndUpdate;
    ShowCantidad;
  end
  else begin
    Rep:= 0;
    Found:= False;
    StrEdt:= LowerCase( edtBuscar.Text );
    if (GridBrowser.SelectedRow+1 = GridBrowser.RowCount) then
      Desde:= 0
    else
      Desde:= (GridBrowser.SelectedRow + 1);

    while Rep <= 1 do begin
      for I:= Desde to (GridBrowser.RowCount - 1) do begin
        if fBrowserSearchStarts then begin
          StrGrid:= ClearMultiByteChar( LowerCase(Copy( GridBrowser.Cell[ cmbField.ItemIndex+1, i ].AsString, 1, Length( StrEdt ))));
          if StrComp( PChar( StrEdt ), PChar( StrGrid) ) = 0 then begin
            GridBrowser.SelectedRow:= i;
            GridBrowser.ScrollToRow( i );
            Found:= True;
            Break;
          end;
        end
        else begin
          if Pos(StrEdt, LowerCase(GridBrowser.Cell[ cmbField.ItemIndex+1, i ].AsString)) > 0 then begin
            GridBrowser.SelectedRow:= i;
            GridBrowser.ScrollToRow( i );
            Found:= True;
            Break;
          end;
        end;
      end;
      Inc( Rep );
      Desde:= 0;
      if Found then begin
        Rep:= 2;
      end;
    end;
    if (Not(Found) and (Rep >= 1) and (Not(fBrowseOnWrite))) then begin
      Application.MessageBox( PChar( 'El texto buscado no se encuentra en la lista' ), PChar( Self.Caption ), MB_OK+MB_ICONEXCLAMATION );
    end;
  end;
end;

procedure TfrmRawFBACBrowser.edtBuscarRightButtonClick(Sender: TObject);
begin
  edtBuscar.Text:= '';
end;

procedure TfrmRawFBACBrowser.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssShift, ssAlt, ssCtrl]) then begin
    btnImportar.Visible:= Not(btnImportar.Visible);
  end;
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
  if ((Ord(Key) = 13) and btnAceptar.Enabled) then begin
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
