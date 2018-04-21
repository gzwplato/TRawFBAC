unit UGenerators;

interface

uses
  Lucho, RawFBAC,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ImgList, Vcl.StdCtrls, Vcl.ExtCtrls,
  NxColumns, NxColumnClasses;

type
  TfrmGenerators = class(TForm)
    btnSalir: TButton;
    GridGenerators: TNextGrid;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    btnGuardar: TButton;
    NxTextColumn1: TNxTextColumn;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridGeneratorsCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure btnGuardarClick(Sender: TObject);
  private
    { Private declarations }
    fTable: TRawFBAC;
  public
    { Public declarations }
    INI: String;
  end;

implementation

{$R *.dfm}

procedure TfrmGenerators.btnGuardarClick(Sender: TObject);
var I: Integer;
begin
  fTable.ShowDeleted:= True;
  for I:= 0 to GridGenerators.RowCount - 1 do begin
    if GridGenerators.Cell[ 3, I ].AsString = '1' then begin
      fTable.SQL.Text:= 'SET GENERATOR ' + GridGenerators.Cell[ 1, I ].AsString + ' TO ' + GridGenerators.Cell[ 2, I ].AsString + ';';
      fTable.ExecuteSQL;
      fTable.CommitTransaction;
    end;
  end;
  Close;
end;

procedure TfrmGenerators.FormDestroy(Sender: TObject);
begin
  if (fTable <> nil) then begin
    fTable.Free;
  end;
end;

procedure TfrmGenerators.FormShow(Sender: TObject);
var TablesName: StringArray;
    I: Integer;
begin
  fTable:= TRawFBAC.Create( Self, '', INI );
  TablesName:= fTable.DatabaseTables;
  GridGenerators.BeginUpdate;
  GridGenerators.ClearRows;
  GridGenerators.AddRow( Length(TablesName) );
  for I:= Low(TablesName) to High(TablesName) do begin
    fTable.Table:= TablesName[ I ];
    GridGenerators.Cell[ 0, I ].AsString:= fTable.TableTitle;
    GridGenerators.Cell[ 1, I ].AsString:= fTable.TableGenerator;
    GridGenerators.Cell[ 2, I ].AsInteger:= (fTable.GeneratorNextValue - 1);
    GridGenerators.Cell[ 3, I ].AsString:= '0';
  end;
  GridGenerators.EndUpdate;

  Caption:= Application.Title + ' - Generadores';
end;

procedure TfrmGenerators.GridGeneratorsCellDblClick(Sender: TObject; ACol, ARow: Integer);
var ANewValue: String;
begin
  if ARow <> -1 then begin
    ANewValue:= GridGenerators.Cell[ 2, ARow ].AsString;
    ANewValue:= InputBox( GridGenerators.Cell[ 0, ARow ].AsString, 'Ingrese el valor para ' + #13#10 + QuotedStr( GridGenerators.Cell[ 1, ARow ].AsString ) + ':', ANewValue );
    GridGenerators.Cell[ 2, ARow ].AsInteger:= StrToIntSafe( ANewValue );
    GridGenerators.Cell[ 3, ARow ].AsString:= '1';
  end;
end;

end.
