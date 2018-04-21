object frmMasterDetail: TfrmMasterDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = '<Tabla detalle>'
  ClientHeight = 367
  ClientWidth = 641
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblMaster: TLabel
    Left = 8
    Top = 8
    Width = 295
    Height = 13
    AutoSize = False
    Caption = '<Master>'
  end
  object btnUp: TSpeedButton
    Left = 587
    Top = 303
    Width = 23
    Height = 22
    Glyph.Data = {
      DE000000424DDE00000000000000360000002800000009000000060000000100
      180000000000A800000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFF00000000000000
      0000000000000000000000000000FFFFFF00FFFFFFFFFFFF0000000000000000
      00000000000000FFFFFFFFFFFF00FFFFFFFFFFFFFFFFFF000000000000000000
      FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFF
      FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FF00}
    OnClick = btnUpClick
  end
  object btnDown: TSpeedButton
    Left = 610
    Top = 303
    Width = 23
    Height = 22
    Glyph.Data = {
      DE000000424DDE00000000000000360000002800000009000000060000000100
      180000000000A800000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
      FFFF000000FFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFF0000000000
      00000000FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF000000000000000000000000
      000000FFFFFFFFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FF00}
    OnClick = btnDownClick
  end
  object edtMaster: TEdit
    Left = 8
    Top = 27
    Width = 49
    Height = 21
    TabOrder = 0
    OnChange = edtMasterChange
  end
  object btnMaster: TButton
    Left = 58
    Top = 27
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
  end
  object pnlMaster: TPanel
    Left = 80
    Top = 27
    Width = 223
    Height = 21
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    TabOrder = 2
  end
  object Grid: TNextGrid
    Left = 8
    Top = 54
    Width = 625
    Height = 243
    AppearanceOptions = [aoHighlightSlideCells]
    Caption = ''
    InactiveSelectionColor = clInactiveCaption
    Options = [goHeader, goSelectFullRow]
    TabOrder = 3
    TabStop = True
    OnSelectCell = GridSelectCell
  end
  object btnEliminar: TButton
    Left = 8
    Top = 303
    Width = 75
    Height = 25
    Caption = 'Eliminar'
    Enabled = False
    TabOrder = 4
    OnClick = btnEliminarClick
  end
  object btnModificar: TButton
    Left = 89
    Top = 303
    Width = 75
    Height = 25
    Caption = 'Modificar'
    Enabled = False
    TabOrder = 5
    OnClick = btnModificarClick
  end
  object btnNuevo: TButton
    Left = 170
    Top = 303
    Width = 75
    Height = 25
    Caption = 'Nuevo'
    Enabled = False
    TabOrder = 6
    OnClick = btnNuevoClick
  end
  object btnCancelar: TButton
    Left = 558
    Top = 334
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 8
  end
  object btnAceptar: TButton
    Left = 477
    Top = 334
    Width = 75
    Height = 25
    Caption = 'Aceptar'
    ModalResult = 1
    TabOrder = 7
  end
end
