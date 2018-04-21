unit UMasterDetail;

interface

uses
  RawFBAC, Lucho,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumns, NxColumnClasses, NxScrollControl, NxCustomGridControl, NxCustomGrid,
  NxGrid, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmMasterDetail = class(TForm)
    lblMaster: TLabel;
    edtMaster: TEdit;
    btnMaster: TButton;
    pnlMaster: TPanel;
    Grid: TNextGrid;
    btnEliminar: TButton;
    btnModificar: TButton;
    btnNuevo: TButton;
    btnCancelar: TButton;
    btnAceptar: TButton;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    procedure edtMasterChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure btnModificarClick(Sender: TObject);
    procedure btnNuevoClick(Sender: TObject);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
  private
    { Private declarations }
    fMasterTable: TRawFBAC;
    fFieldsShowed: StringArray;
    fLastOrden: Integer;
    procedure ShowDataInGrid(ARow: Integer);
    procedure SubeOBaja(Sube: Boolean);
  public
    { Public declarations }
    DetailTable: TRawFBAC;
    Field: String;
    Fields2Show: String;
    FieldValue: String;
    ModifyMasterField: Boolean;
    OrderField: String;
  end;

var
  frmMasterDetail: TfrmMasterDetail;

implementation

{$R *.dfm}

procedure TfrmMasterDetail.btnDownClick(Sender: TObject);
begin
  SubeOBaja(False);
end;

procedure TfrmMasterDetail.btnEliminarClick(Sender: TObject);
begin
  DetailTable.CreateRecordSet( fFieldsShowed[0] + '=' + Grid.Cell[ 0, Grid.SelectedRow ].AsString );
  if DetailTable.RecordCount = 1 then begin
    if MsgBox( 'Se va a elimiar el registro seleccionado' + #13#10 + '¿Desea continuar?', Application.Title, MB_YESNO + MB_ICONQUESTION ) = mrYes then begin
      DetailTable.DeleteRecord;
      Grid.DeleteRow( Grid.SelectedRow );
      if btnUp.Visible then begin
        btnUp.Enabled:= False;
        btnDown.Enabled:= False;
      end;
    end;
  end
  else begin
    MsgBox( 'Error seleccionando registro', Application.Title, MB_OK + MB_ICONERROR );
  end;
end;

procedure TfrmMasterDetail.btnModificarClick(Sender: TObject);
begin
  DetailTable.CreateRecordSet( fFieldsShowed[0] + '=' + Grid.Cell[ 0, Grid.SelectedRow ].AsString );
  if DetailTable.RecordCount = 1 then begin
    if DetailTable.ShowModifyForm then begin
      ShowDataInGrid( Grid.SelectedRow );
    end;
  end
  else begin
    MsgBox( 'Error seleccionando registro', Application.Title, MB_OK + MB_ICONERROR );
  end;
end;

procedure TfrmMasterDetail.btnNuevoClick(Sender: TObject);
begin
  if OrderField <> '' then begin
    DetailTable.AddDefaultValue(OrderField, IntToStr(fLastOrden + 1));
  end;

  if DetailTable.ShowNewForm then begin
    Grid.AddRow;
    ShowDataInGrid( Grid.LastAddedRow );
    if btnUp.Visible then begin
      btnUp.Enabled:= False;
      btnDown.Enabled:= False;
    end;
  end;
end;

procedure TfrmMasterDetail.btnUpClick(Sender: TObject);
begin
  SubeOBaja(True);
end;

procedure TfrmMasterDetail.edtMasterChange(Sender: TObject);
var I: Integer;
begin
  DetailTable.ClearDefaultValues;
  Grid.BeginUpdate;
  Grid.ClearRows;
  if edtMaster.Text <> '' then begin
    DetailTable.CreateRecordSet( Field + '=' + edtMaster.Text + Iif(OrderField <> '', ',' + OrderField, '' ));
    Grid.AddRow( DetailTable.RecordCount );
    for I:= 0 to DetailTable.RecordCount - 1 do begin
      ShowDataInGrid( I );
      if OrderField <> '' then begin
        fLastOrden:= ValInt(DetailTable.Field[OrderField]);
      end;
      DetailTable.NextRecord;
    end;
    DetailTable.AddDefaultValue( Field, edtMaster.Text );
  end;
  Grid.EndUpdate;
  GridSelectCell(Grid, -1, -1);
  btnNuevo.Enabled:= edtMaster.Text <> '';

  if btnUp.Visible then begin
    btnUp.Enabled:= False;
    btnDown.Enabled:= False;
  end;
end;

procedure TfrmMasterDetail.FormCreate(Sender: TObject);
begin
  OrderField:= '';
  fLastOrden:= 0;
end;

procedure TfrmMasterDetail.FormDestroy(Sender: TObject);
begin
  fMasterTable.Free;
end;

procedure TfrmMasterDetail.FormShow(Sender: TObject);
var ATableLinked, AFieldShowed, AFieldSaved: String;
    ABrowseAllFields: Boolean;
    I: Integer;
    ACol: TNxTextColumn;
begin
  Caption:= DetailTable.TableTitle;
  lblMaster.Caption:= DetailTable.FieldTitle[Field];

  DetailTable.FieldLinkedInfo(Field, ATableLinked, AFieldShowed, AFieldSaved, ABrowseAllFields);

  fMasterTable:= TRawFBAC.Create( Self, ATableLinked, DetailTable.INIFilename );

  fMasterTable.AddEvents4Browser( fMasterTable, AFieldSaved, AFieldShowed, edtMaster, btnMaster, pnlMaster );
  if Not(ModifyMasterField) then begin
    DetailTable.DisableModifyFields:= Field;
  end;
  if OrderField <> '' then begin
    if DetailTable.DisableModifyFields = '' then begin
      DetailTable.DisableModifyFields:= OrderField;
    end
    else begin
      DetailTable.DisableModifyFields:= DetailTable.DisableModifyFields +  ',' + OrderField;
    end;
  end;


  fFieldsShowed:= Split(AFieldSaved + ',' + Iif(OrderField <> '', OrderField + ',', '') + Fields2Show, ',');
  Grid.BeginUpdate;
  Grid.Columns.Clear;
  Grid.Columns.AddColumns(TNxTextColumn, Length(fFieldsShowed));
  for I:= Low(fFieldsShowed) to High(fFieldsShowed) do begin
    Grid.Columns[I].Header.Caption:= DetailTable.FieldTitle[fFieldsShowed[I]];
    Grid.Columns[I].Width:= 120;
    if I = High(fFieldsShowed) then begin
      Grid.Columns[I].Options:= Grid.Columns[I].Options + [coAutoSize];
    end;
  end;
  Grid.Columns[0].Visible:= False;
  if (OrderField <> '') then begin
    Grid.Columns[1].Visible:= False;
  end;

  Grid.EndUpdate;
  edtMaster.Text:= FieldValue;

  edtMaster.Enabled:= ModifyMasterField;
  lblMaster.Enabled:= ModifyMasterField;
  btnMaster.Enabled:= ModifyMasterField;
  pnlMaster.Enabled:= ModifyMasterField;

  btnUp.Visible:= OrderField <> '';
  btnDown.Visible:= OrderField <> '';
  btnUp.Enabled:= False;
  btnDown.Enabled:= False;
end;

procedure TfrmMasterDetail.GridSelectCell(Sender: TObject; ACol, ARow: Integer);
begin
  btnModificar.Enabled:= ARow > -1;
  btnEliminar.Enabled:= ARow > -1;
  btnAceptar.Enabled:= ARow > -1;

  if btnUp.Visible then begin
    btnUp.Enabled:= ARow > 0;
    btnDown.Enabled:= ARow < (Grid.RowCount - 1);
  end;
end;

procedure TfrmMasterDetail.ShowDataInGrid(ARow: Integer);
var I: Integer;
begin
  for I:= Low(fFieldsShowed) to High(fFieldsShowed) do begin
    Grid.Cell[ I, ARow ].AsString:= DetailTable.FieldLinked[fFieldsShowed[I]];
  end;
end;

procedure TfrmMasterDetail.SubeOBaja(Sube: Boolean);
var ASQL: String;
begin
  if Sube then begin
    ASQL:= 'update ' + DetailTable.TableInFDB + ' set ' + OrderField + ' = ' + Grid.Cell[1, Grid.SelectedRow - 1].AsString + ' where ' + DetailTable.UniqueField + ' = ' + Grid.Cell[0, Grid.SelectedRow].AsString + ';';
    DetailTable.SQL.Text:= ASQL;
    DetailTable.ExecuteSQL;

    ASQL:= 'update ' + DetailTable.TableInFDB + ' set ' + OrderField + ' = ' + Grid.Cell[1, Grid.SelectedRow].AsString + ' where ' + DetailTable.UniqueField + ' = ' + Grid.Cell[0, Grid.SelectedRow - 1].AsString;
    DetailTable.SQL.Text:= ASQL;
    DetailTable.ExecuteSQL;
  end
  else begin
    ASQL:= 'update ' + DetailTable.TableInFDB + ' set ' + OrderField + ' = ' + Grid.Cell[1, Grid.SelectedRow + 1].AsString + ' where ' + DetailTable.UniqueField + ' = ' + Grid.Cell[0, Grid.SelectedRow].AsString + ';';
    DetailTable.SQL.Text:= ASQL;
    DetailTable.ExecuteSQL;

    ASQL:= 'update ' + DetailTable.TableInFDB + ' set ' + OrderField + ' = ' + Grid.Cell[1, Grid.SelectedRow].AsString + ' where ' + DetailTable.UniqueField + ' = ' + Grid.Cell[0, Grid.SelectedRow + 1].AsString;
    DetailTable.SQL.Text:= ASQL;
    DetailTable.ExecuteSQL;
  end;
  DetailTable.CommitTransaction;
  edtMasterChange(edtMaster);
end;

end.
