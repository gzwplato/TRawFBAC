unit URawFBACExplorer;

interface

uses
  Lucho, RawFBAC,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ImgList, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmRawFBACExplorer = class(TForm)
    lstTables: TListBox;
    btnSalir: TButton;
    btnExplorar: TButton;
    chkShowDeleted: TCheckBox;
    btnBackup: TButton;
    btnBackupAll: TButton;
    btnRestore: TButton;
    SaveDlg: TSaveDialog;
    PBTabla: TProgressBar;
    PBDB: TProgressBar;
    btnGenerators: TButton;
    OpenDlg: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExplorarClick(Sender: TObject);
    procedure lstTablesClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure btnBackupAllClick(Sender: TObject);
    procedure btnGeneratorsClick(Sender: TObject);
    procedure btnRestoreClick(Sender: TObject);
  private
    { Private declarations }
    ATable: TRawFBAC;
    Tables: StringArray;
  public
    { Public declarations }
    INI: String;
  end;

implementation

{$R *.dfm}

procedure TfrmRawFBACExplorer.btnBackupAllClick(Sender: TObject);
var ATableStr, St: AnsiString;
    I: Integer;
begin
  SaveDlg.Title:= 'Respaldar todos las tablas';
  if (SaveDlg.Execute) then begin
    PBDB.Max:= Length( Tables );
    for I:= Low( Tables ) to High( Tables ) do begin
      PBDB.Position:= I;
      ATable.Table:= Tables[ I ];
      ATable.ShowDeleted:= chkShowDeleted.Checked;
      ATable.SQL.Text:= 'select * from ' + ATable.Table;
      ATable.ExecuteSQL;
      if ATable.RecordCount > 0 then begin
        ATableStr:= ATable.AllTable2Str( PBTabla );
        if ATableStr <> '' then begin
          if St <> '' then begin
            St:= St + #13#10;
          end;
          St:= St + ATableStr;
        end;
      end;
    end;
    if St <> '' then begin
      String2File( SaveDlg.FileName, St );
    end
    else begin
      Application.MessageBox( PChar('La base de datos no tiene registros para respaldar'), 'Respaldar', MB_OK + MB_ICONERROR );
    end;
  end;
  PBDB.Max:= 0;
  PBDB.Position:= 0;
end;

procedure TfrmRawFBACExplorer.btnBackupClick(Sender: TObject);
var St: AnsiString;
begin
  ATable.Table:= Tables[ lstTables.ItemIndex ];
  ATable.ShowDeleted:= chkShowDeleted.Checked;
  ATable.SQL.Text:= 'select * from ' + ATable.Table;
  ATable.ExecuteSQL;
  if ATable.RecordCount > 0 then begin
    SaveDlg.Title:= 'Respaldar ' + ATable.TableTitle;
    if (SaveDlg.Execute) then begin
      St:= ATable.AllTable2Str;
      if St <> '' then begin
        String2File( SaveDlg.FileName, St );
      end;
    end;
  end
  else begin
    Application.MessageBox( PChar('La tabla ' + ATable.TableTitle + ' no tiene registros para respaldar'), 'Respaldar', MB_OK + MB_ICONERROR );
  end;
end;

procedure TfrmRawFBACExplorer.btnExplorarClick(Sender: TObject);
begin
  ATable.Table:= Tables[ lstTables.ItemIndex ];
  ATable.ShowDeleted:= chkShowDeleted.Checked;
  ATable.BrowseTableAndCommit;
end;

procedure TfrmRawFBACExplorer.btnGeneratorsClick(Sender: TObject);
begin
  ATable.BrowseGenerators;
end;

procedure TfrmRawFBACExplorer.btnRestoreClick(Sender: TObject);
begin
  if OpenDlg.Execute then begin
    ATable.RestoreFromFile( OpenDlg.FileName, True );
  end;
end;

procedure TfrmRawFBACExplorer.FormDestroy(Sender: TObject);
begin
  ATable.Free;
end;

procedure TfrmRawFBACExplorer.FormShow(Sender: TObject);
var I: Integer;
begin
  ATable:= TRawFBAC.Create( Self, '', INI );
  Tables:= ATable.DatabaseTables;
  lstTables.Clear;
  for I:= Low(Tables) to High(Tables) do begin
    try
      ATable.Table:= Tables[ i ];
      lstTables.Items.Add( ATable.TableTitle  );
    except
      lstTables.Items.Add( Tables[ i ] );
    end;
  end;
  lstTablesClick( lstTables );
  Caption:= ExtractFileName( ATable.DBFilename ) + ' - Explorar';
end;

procedure TfrmRawFBACExplorer.lstTablesClick(Sender: TObject);
begin
  btnExplorar.Enabled:= lstTables.ItemIndex > -1;
  btnBackup.Enabled:= lstTables.ItemIndex > -1;
end;

end.
