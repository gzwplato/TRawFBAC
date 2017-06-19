object frmGenerators: TfrmGenerators
  Left = 376
  Top = 129
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Generadores'
  ClientHeight = 413
  ClientWidth = 438
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
  object btnSalir: TButton
    Left = 355
    Top = 380
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Salir'
    ModalResult = 2
    TabOrder = 2
  end
  object GridGenerators: TNextGrid
    Left = 8
    Top = 8
    Width = 422
    Height = 366
    AppearanceOptions = [aoHighlightSlideCells]
    Caption = ''
    Options = [goHeader, goSelectFullRow]
    TabOrder = 0
    TabStop = True
    OnCellDblClick = GridGeneratorsCellDblClick
    object NxTextColumn3: TNxTextColumn
      DefaultWidth = 160
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Tabla'
      Options = [coCanClick, coCanInput, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 0
      SortType = stAlphabetic
      Width = 160
      TextBefore = ' '
    end
    object NxTextColumn6: TNxTextColumn
      DefaultWidth = 180
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Generador'
      Options = [coAutoSize, coCanClick, coCanInput, coFixedSize, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
      Width = 180
    end
    object NxTextColumn5: TNxTextColumn
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Footer.Caption = '0,00 '
      Footer.Alignment = taRightJustify
      Header.Caption = 'Valor'
      Header.Alignment = taRightJustify
      Options = [coCanClick, coCanInput, coFixedSize, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 2
      SortType = stAlphabetic
    end
    object NxTextColumn1: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Cambio'
      ParentFont = False
      Position = 3
      SortType = stAlphabetic
      Visible = False
    end
  end
  object btnGuardar: TButton
    Left = 274
    Top = 380
    Width = 75
    Height = 25
    Caption = 'Guardar'
    TabOrder = 1
    OnClick = btnGuardarClick
  end
end
