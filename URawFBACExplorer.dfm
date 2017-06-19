object frmRawFBACExplorer: TfrmRawFBACExplorer
  Left = 376
  Top = 129
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 462
  ClientWidth = 446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lstTables: TListBox
    Left = 8
    Top = 8
    Width = 430
    Height = 338
    ItemHeight = 13
    TabOrder = 0
    OnClick = lstTablesClick
  end
  object btnSalir: TButton
    Left = 363
    Top = 429
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Salir'
    ModalResult = 2
    TabOrder = 1
  end
  object btnExplorar: TButton
    Left = 8
    Top = 398
    Width = 75
    Height = 25
    Caption = '&Explorar'
    Enabled = False
    TabOrder = 2
    OnClick = btnExplorarClick
  end
  object chkShowDeleted: TCheckBox
    Left = 8
    Top = 437
    Width = 180
    Height = 17
    Caption = 'Mostrar registros eliminados'
    TabOrder = 7
  end
  object btnBackup: TButton
    Left = 89
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Respaldar'
    Enabled = False
    TabOrder = 3
    OnClick = btnBackupClick
  end
  object btnBackupAll: TButton
    Left = 170
    Top = 398
    Width = 106
    Height = 25
    Caption = 'Respaldar todo'
    TabOrder = 4
    OnClick = btnBackupAllClick
  end
  object btnRestore: TButton
    Left = 282
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Restaurar'
    TabOrder = 5
    OnClick = btnRestoreClick
  end
  object PBTabla: TProgressBar
    Left = 8
    Top = 352
    Width = 430
    Height = 17
    TabOrder = 8
  end
  object PBDB: TProgressBar
    Left = 8
    Top = 375
    Width = 430
    Height = 17
    TabOrder = 9
  end
  object btnGenerators: TButton
    Left = 363
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Generadores'
    TabOrder = 6
    OnClick = btnGeneratorsClick
  end
  object SaveDlg: TSaveDialog
    DefaultExt = 'txt'
    Filter = 
      'Archivos de respaldo (*.txt;*.seq)|*.txt;*.seq|Todos los archivo' +
      's (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 400
    Top = 16
  end
  object OpenDlg: TOpenDialog
    DefaultExt = 'txt'
    Filter = 
      'Archivos de respaldo (*.txt;*.seq)|*.txt;*.seq|Todos los archivo' +
      's (*.*)|*.*'
    Left = 400
    Top = 76
  end
end
