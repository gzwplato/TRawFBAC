// TRawFBAC
// (c) 2012/13/14/15/16/17/18 Luciano Olocco
// E-Mail: lolocco@gmail.com

unit RawFBAC;

interface

uses Lucho, RawFB, RawFBUtils, RawFBServices, StringListHelper, ComponentBallonHintHelper,
     System.Generics.Collections, System.DateUtils, Vcl.ClipBrd, VCL.Controls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
     Winapi.Windows, Winapi.Messages, NxColumns, NxColumnClasses, System.Classes, System.SysUtils, INIFiles, VCL.Forms,
     VCL.Dialogs, Vcl.Graphics;

const
    CriteriasConst: array [0..7] of string = ('<>', '!', '<=', '<', '>=', '>', '=', 'like');

type
   TAddedColumnEvent = function(Sender: TObject; ATable: TObject; ColName: String): String of object;

type
  TEventRedirector = record
    ControlName: String;
    EventName: String;
    ANotifyEvent: TNotifyEvent;
    AKeyDownEvent: TKeyEvent;
    AKeyPressEvent: TKeyPressEvent;
  end;

type
  TVirtualFieldsEvents = record
    FieldName: String;
    ABeforeEvent: TNotifyEvent;
    AAfterEvent: TNotifyEvent;
  end;

type VirtualFieldsEventsArray = array of TVirtualFieldsEvents;

type
  TEventRedirectorArray = array of TEventRedirector;

type
  TBrowserCtrlsRedirector = record
    AFirebirdTable: TObject;
    BrowseField: String;
    ShowField: String;
    AEdit: TEdit;
    AButton: TButton;
    APanel: TPanel;
  end;

type
  TCalculatedField = record
    FieldName: String;
    Expression: String;
  end;

type
   TNewModifyButtonClickEvent = procedure(Sender: TObject; Modify: Boolean; var Accept: Boolean) of object;

type TRawFBAC = class(TObject)
  private
    { Private declarations }
    //F: TfrmRawFBACBrowser;
    fParent: TComponent;
    fFBClient: TRawFB;
    fFBClient2: TRawFB;
    fDBIndex: Integer;

    fDataValues: TStringList;
    fDataFields: TStringList;
    fFieldsChanged: TStringList;
    fDefault4Browse: String;
    fVirtualValues: TStringList;
    fVirtualValuesIndex: Integer;
    fINI: TMemIniFile;
    fTable: String;
    fTableInINI: String;
    fUKData: TStringList;
    fUKFields: TStringList;
    fDefaultValues: TStringList;
    fRecordCount: Integer;
    fTableRecentCreated: Boolean;
    fShowDeleted: Boolean;
    fCopyToClipBoardAMForm: Boolean;
    fShowABMButtons: Boolean;
    fDisableModifyFields: String;
    fFileExtensionForBLOBFields: String;
    fIsBigTable: Boolean;
    fGeneratorIncrement: Integer;
    fCalculatedField: array of TCalculatedField;
    fVirtualFieldsEvents: VirtualFieldsEventsArray;
    fTimeStampFormat: String;

    fNewModifyClickButton: TNewModifyButtonClickEvent;
    fCanDeleteInBrowser: Boolean;
    fBrowseCaptions: StringArray;
    fBrowseEnableWithDelete: BooleanArray;
    fBrowseClickEvents: array of TNotifyEvent;
    fBrowseOnWrite: Boolean;
    fBrowserSearchStarts: Boolean;

    fBrowseCaption: String;
    fColumnAddedNames: StringArray;
    fColumnAddedCaptions: StringArray;
    fColumnAddedEvents: array of TAddedColumnEvent;
    fColumnAlignments: array of TAlignment;

    fControlsEvents: TEventRedirectorArray;
    fBrowserCtrlsRedirectorList: TList<TBrowserCtrlsRedirector>;

    function AMForm(Modifying: Boolean): Boolean;
    function CreateTable: Boolean;
    procedure PutDataInArray;
    function GetField(FieldName: String): String;
    function GetFieldBlob(FieldName, FileName: String): String;
    procedure SetField(FieldName: String; const Value: String);
    procedure SetTable(const Value: String; CreateLinkedTables: Boolean); overload;
    procedure SetTable(const Value: String); overload;
    function GetFieldLinked(FieldName: String): String;
    function GetSQL: TStrings;
    procedure SetSQL(const Value: TStrings);
    function GetFieldType(FieldName: String): String; overload;
    function GetFieldType(TableName: String; FieldName: String): String; overload;
    function GetTableGenerator: String;
    function GetUniqueField: String;
    function GetFieldTitle(FieldName: String): String;
    function GetGridColWidth(FieldName: String): Integer;
    function GetTableTitle: String;
    function GetFieldCount: Integer;
    function GetFieldNameByNumber(i: Integer): String;
    function GetFieldSQLType(FieldName: String): String;
    function GetFieldWidth(FieldName: String): String;
    function GetFieldCompWidth(FieldName: String): Integer;
    function GetTableIndices: String;
    function GetFieldsArray: StringArray;
    function GetFieldIsVisible(FieldName: String): Boolean;
    function GetFieldIsIndexed(FieldName: String): Boolean;
    function FieldUseComponent(CompType, FieldName: String): Boolean;
    function PrepareEditText4Save(FieldName, Value: String): String;
    function FieldIsAloneInLine(FieldName: String): Boolean;
    function FieldIsCUIT(FieldName: String): Boolean;
    function FieldIsEdad(FieldName: String): Boolean;
    function FieldIsFile(FieldName: String): Boolean;
    function FieldIsFileFilter(FieldName: String): String;
    function FieldHasEnabler(FieldName: String): String;
    function AfterFieldIsCRLF(FieldName: String): Boolean;
    function BeforeFieldDrawHLine(FieldName: String; out AText: String): Boolean;
    function FieldIsNoType(FieldName: String): Boolean;
    function GetDataTypeFromFDB(FieldName: String): String;
    function GetLSLinkValue(FieldName, Value: String): String;
    function GetFieldIndexInQuery(Qry: TRawFB; FieldName: String): Integer;
    function GetClientLibrary: String;

    procedure CreateComponent(IsModifying: Boolean; AOwner: TWinControl ; FieldName: String; X, Y: Integer; var CompWidth, CompHeight: Integer);
    procedure btnModifyClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure edtLinkChange(Sender: TObject);
    procedure edtLinkExit(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnFileBrowseClick(Sender: TObject);

    // Eventos para los controles
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtHoraKeyPress(Sender: TObject; var Key: Char);
    procedure edtHoraKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtHoraExit(Sender: TObject);
    procedure NumericEditKeyPress(Sender: TObject; var Key: Char);
    procedure FloatEditKeyPress(Sender: TObject; var Key: Char);
    procedure edtCurrencyEnter(Sender: TObject);
    procedure edtCurrencyExit(Sender: TObject);
    procedure edtFechaExit(Sender: TObject);
    procedure edtFechaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtKeyPress(Sender: TObject; var Key: Char);
    procedure edtCUITChange(Sender: TObject);

    // Enabler
    procedure CtrlChangeEnabler(Sender: TObject);

    // Eventos para AddEvents4Browser
    procedure Edit4BrowserChange(Sender: TObject);
    procedure Button4BrowserClick(Sender: TObject);

    procedure SetShowDeleted(const Value: Boolean);
    function ComponentToString(Component: TComponent): string;
    function GetVirtualValue(FieldName: String): String;
    procedure SetVirtualValue(FieldName: String; const Value: String);
    procedure SetVirtualValuesIndex(const Value: Integer);

    procedure SetLogTableOnfINI;

    function GetWaitInterval: Integer;
    procedure SetWaitInterval(const Value: Integer);
    function GetINIFilename: String;
    procedure AddEventIfIsAssigned(Control: TControl; EventName: String; ANotifyEvent: TNotifyEvent; AKeyDownEvent: TKeyEvent; AKeyPressEvent: TKeyPressEvent; var Vector: TEventRedirectorArray);
    function GetFieldsNotNull: StringArray;
    function GetFieldLinkedSeparator(FieldName: String): String;
    function GetFieldIndex(FieldName: String): Integer;
    procedure AddedBrowseButtonsClick(Sender: TObject);
    procedure SetDisableModifyFields(const Value: String);
    function GetFieldIsSharedIndexed(FieldName: String): Boolean;
    function GetConnected: Boolean;
    function GetFieldTypeTitle(FieldName: String): String;
    function ReplaceCharForBackup(AStr: String): String;
    function ReplaceCharOfBackup(AStr: String): String;
    procedure SetConnected(const Value: Boolean);
    function GenerateCriterias(SortField: String): String;
    procedure MakeWhereFromSortField(SortField, Criterias: String; out Where: String; out OrderBy: String);
    function GetRecordIsDeleted: Boolean;
    function GetGeneratorValue(GeneratorName: String): Integer;
    procedure SetGeneratorValue(GeneratorName: String; const Value: Integer);
    function GetCalculatedField(FieldName: String): Extended;
    function GenerateExpressionForCalculatedField(Expression: String): String;
    function GetFieldIsVirtual(FieldName: String): Boolean;
    function GetFieldsNoDuplicate: StringArray;
    function GetAllowDeadLinks: Boolean;
    function GetTable: String;
    function GetFieldFormat(FieldName: String): String;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; Table: String; INIFileName: String = ''; FDBHostAndFile: String = '');
    constructor CreateMemINI(AOwner: TComponent; Table: String; INI: TMemIniFile; FDBHostAndFile: String = '');
    destructor Destroy; override;
    function DBHost: String;
    function DBFilename: String;
    function ServerVersion: String;
    function DBPort: String;
    property SQL: TStrings read GetSQL write SetSQL;
    procedure ExecuteSQL;
    procedure FirstRecord;
    procedure NextRecord;
    procedure PrevRecord;
    procedure LastRecord;
    procedure InitRecord;
    procedure InsertRecord;
    procedure InsertRecordNoNextValue;
    procedure UpDateRecord;
    procedure UpDateOrInsertRecord;
    procedure DeleteRecord;
    procedure DeleteRecordSet(Where: String);
    procedure DeleteRecordFisically;
    procedure CreateRecordSet(SortField: String; SelField: String = '*'; Criterias: String = ''); overload;
    function CreateRecordSetAndCount(SortField: String; SelField: String = '*'; Criterias: String = ''): Integer;
    procedure CreateRecordSetLinked(SortField: String; SelField: String = '*'; Criterias: String = '');
    function CreateRecordSetLinkedAndCount(SortField: String; SelField: String = '*'; Criterias: String = ''): Integer;
    procedure FillComboBoxItems(FieldName: String; var Combo: TComboBox);
    procedure FillStringListItems(FieldName: String; StrLst: TStrings);
    procedure FillStringListAllTable(Field2Show, Filter, OrderBy: String; StrLst: TStrings);
    procedure FillComboBoxAllTable(Field2Show, Filter, OrderBy: String; var Combo: TComboBox);
    function FillStringArrayWithFieldLS(FieldName: String): StringArray;
    procedure CommitTransaction;
    procedure FieldLinkedInfo(FieldName: String; var TableLinked, FieldShowed, FieldSaved: String; var BrowseAllFields: Boolean); overload;
    procedure FieldLinkedInfo(ATable, FieldName: String; var TableLinked, FieldShowed, FieldSaved: String; var BrowseAllFields: Boolean); overload;
    procedure CreateAllTables;
    procedure SetEvents4Edit(FieldType: String; Edit: TEdit);
    procedure AddEvents4Browser(AFirebirdTable: TRawFBAC; BrowseField, ShowField: String; AEdit: TEdit; AButton: TButton; APanel: TPanel);
    procedure ClearEvents4Browser;
    procedure UpdateTableStructure;
    procedure FreeTStringsFromComboBox(Combo: TComboBox);
    procedure FreeTStringsFromStringList(StrLst: TStrings);
    procedure AddDefaultValue(Field, Value: String);
    procedure ClearDefaultValues;
    procedure ClearVirtualValues;
    procedure VirtualValueNext;
    procedure VirtualValuePrev;
    procedure VirtualValueFirst;
    procedure VirtualValueLast;
    procedure VirtualValueNewRecord;
    procedure VirtualValueDeleteRecord;
    function FormatField4SQL(FieldName, Value: String): String;
    function FormatFieldType4SQL(FieldType, Value: String): String;
    function Eof: Boolean;
    function Bof: Boolean;
    function RecordCount: Integer;
    function RecordAffected: Integer;
    function BrowseTable(CreateNewRecordSet: Boolean = True): Boolean;
    function BrowseTableAndCommit: Boolean;
    function Fields4Browser: String;
    procedure SetFields4Browser(AValue: String);
    procedure SetDefault4Browse(AValue: String);
    function FieldIsNumeric(FieldName: String): Boolean;
    function FieldTypeIsNumeric(FieldType: String): Boolean;
    //function Default4Browse: String;
    function ShowModifyForm: Boolean;
    function ShowNewForm: Boolean;
    function DatabaseTables: StringArray;
    function GeneratorNextValue: Integer;
    function LSValueFromComboBox(FieldName: String; Combo: TComboBox): String;
    function LSItemIndexFromData(Value: String; Combo: TComboBox): Integer;
    function GetUKWhere: String;
    function VirtualValueEof: Boolean;
    function FormatText4Print(AText: String): String;
    function DBInfo(Params: String): String;
    procedure BrowseAddButton(Caption: String; EnableWithDeleteBtn: Boolean; ClickEvent: TNotifyEvent);
    procedure AddInfoToINI(Info: TStringList);

    procedure AddColumn(ColumnName, ColumnCaption: String; Alignment: TAlignment; EventName: TAddedColumnEvent);
    procedure ClearAddedColumns;
    function GetValueOfAddedColumn(ColumnName: String): String;

    procedure BrowseAllTables;
    procedure BrowseGenerators;

    property Parent: TComponent read fParent write fParent;
    property Field[FieldName: String]: String read GetField write SetField; default;
    property CalculatedField[FieldName: String]: Extended read GetCalculatedField;

    property FieldBlob[FieldName, FileName: String]: String read GetFieldBlob;
    property FieldLinked[FieldName: String]: String read GetFieldLinked;
    property FieldType[FieldName: String]: String read GetFieldType;
    property FieldSQLType[FieldName: String]: String read GetFieldSQLType;
    property FieldTypeInFDB[FieldName: String]: String read GetDataTypeFromFDB;
    property FieldTypeTitle[FieldName: String]: String read GetFieldTypeTitle;
    property FieldWidth[FieldName: String]: String read GetFieldWidth;
    property FieldTitle[FieldName: String]: String read GetFieldTitle;
    property FieldIsVisible[FieldName: String]: Boolean read GetFieldIsVisible;
    property FieldIsIndexed[FieldName: String]: Boolean read GetFieldIsIndexed;
    property FieldIsSharedIndexed[FieldName: String]: Boolean read GetFieldIsSharedIndexed;
    property FieldIsVirtual[FieldName: String]: Boolean read GetFieldIsVirtual;
    property FieldFormat[FieldName: String]: String read GetFieldFormat;
    property FieldIndex[FieldName: String]: Integer read GetFieldIndex;
    property FieldsArray: StringArray read GetFieldsArray;
    property FieldsNotNull: StringArray read GetFieldsNotNull;
    property FieldsNoDuplicate: StringArray read GetFieldsNoDuplicate;
    property IsBigTable: Boolean read fIsBigTable write fIsBigTable;
    property FieldLinkedSeparator[FieldName: String]: String read GetFieldLinkedSeparator;
    property Table: String read GetTable write SetTable;
    property TableInFDB: String read fTable;
    property TableGenerator: String read GetTableGenerator;
    property TableTitle: String read GetTableTitle;
    property TableIndices: String read GetTableIndices;
    property UniqueField: String read GetUniqueField;
    property FieldCount: Integer read GetFieldCount;
    property FieldNameByNumber[i: Integer]: String read GetFieldNameByNumber;
    property TableRecentCreated: Boolean read fTableRecentCreated;
    property ShowDeleted: Boolean read FShowDeleted write SetShowDeleted;
    property RecordIsDeleted: Boolean read GetRecordIsDeleted;
    property CopyToClipBoardAMForm: Boolean read fCopyToClipBoardAMForm write fCopyToClipBoardAMForm;
    property VirtualValue[FieldName: String]: String read GetVirtualValue write SetVirtualValue;
    property VirtualValuesIndex: Integer read FVirtualValuesIndex write SetVirtualValuesIndex;

    property DisableModifyFields: String read fDisableModifyFields write SetDisableModifyFields;
    property NewModifyButtonClick: TNewModifyButtonClickEvent read fNewModifyClickButton write fNewModifyClickButton;
    property CanDeleteInBrowser: Boolean read fCanDeleteInBrowser write fCanDeleteInBrowser;
    property BrowseCaption: String read fBrowseCaption write fBrowseCaption;
    property ShowABMButtons: Boolean read fShowABMButtons write fShowABMButtons;
    property Default4Browse: String read fDefault4Browse write fDefault4Browse;
    property BrowseOnWrite: Boolean read fBrowseOnWrite write fBrowseOnWrite;
    property WaitInterval: Integer read GetWaitInterval write SetWaitInterval;
    property INIFilename: String read GetINIFilename;
    property Connected: Boolean read GetConnected write SetConnected;
    property FileExtensionForBLOBFields: String read fFileExtensionForBLOBFields write fFileExtensionForBLOBFields;
    property GeneratorValue[GeneratorName: String]: Integer read GetGeneratorValue write SetGeneratorValue;
    property AllowDeadLinks: Boolean read GetAllowDeadLinks;
    property VirtualFieldsEvents: VirtualFieldsEventsArray read fVirtualFieldsEvents;

    procedure BackupDatabase(FBKFilename: String; var ALabel: TLabel);
    function GetValueOfAnotherTable(Table, Field, SortField: String): String;
    function SQLAddDeleted0(TheSQL: String): String;
    function ReadStringAndResolve(const Section, Ident: String; Default: String = ''): String;
    procedure WriteStringAndResolve(const Section, Ident, Value: String);
    function RecordSet2Str(IncludeFieldNames: Boolean; AProgressBar: TProgressBar = nil): AnsiString;
    function AllTable2Str(AProgressBar: TProgressBar = nil): AnsiString;
    function RestoreFromFile(AFilename: String; DeleteTable: Boolean): Boolean;
    procedure IncludeTableInINI(FirebirdInstance: TRawFBAC; ATable: String);
    function NextValueForGenerator(GeneratorName: String): Integer;
    procedure AddCalculatedField(FieldName, Expression: String);
    procedure ClearCalculatedFields;
    procedure AddFieldInAM(FieldName, FieldParams, AfterField: String; BeforeEdit, AfterEdit: TNotifyEvent; AColumnEvent: TAddedColumnEvent = nil);
    function ShowMasterDetailForm(AField: String; MasterFieldValue: String; Fields2Show: String = ''; ModifyMasterField: Boolean = False; OrderField: String = ''): Integer;
    procedure UpdateGeneratorWithLastTableValue(ATable: TRawFBAC);
    function LinkedStr(AStr, AValue: String): String;
    property TimeStampFormat: String read fTimeStampFormat write fTimeStampFormat;
    function UpdateTableWith(Criteria, Fields: String): String;
    property BrowserSearchStarts: Boolean read fBrowserSearchStarts write fBrowserSearchStarts;
end;

implementation

 {$R 'RawFBACRES.res' 'RawFBACRES.rc'}

uses URawFBACBrowser, UMasterDetail, URawFBACExplorer, UGenerators;

var fWaitInterval: Integer;
    InstanceCount: Integer;

{ TRawFBAC }

procedure TRawFBAC.FillComboBoxAllTable(Field2Show, Filter, OrderBy: String; var Combo: TComboBox);
begin
  FillStringListAllTable(Field2Show, Filter, OrderBy, Combo.Items);
end;

procedure TRawFBAC.FillComboBoxItems(FieldName: String; var Combo: TComboBox);
begin
  FillStringListItems(FieldName, Combo.Items);
end;

function TRawFBAC.FillStringArrayWithFieldLS(FieldName: String): StringArray;
var Datos: StringArray;
    DataStr, ATable, AShowedField, AStoredField: String;
    I: Integer;
begin
  Datos:= Split(fINI.ReadString(fTableInINI + '-F', FieldName, ''), ',');
  SetLength(Datos, 5);
  DataStr:= Datos[3];
  if DataStr.StartsWith('{LN:') and DataStr.EndsWith('}') then begin
    DataStr:= Copy(DataStr, 5, DataStr.Length - 5);
    ATable:= Mid(DataStr, 1, Pos(':', DataStr) - 1);
    AStoredField:= Mid(DataStr, Pos(':', DataStr) + 1, Pos('|', DataStr) - 1);
    AShowedField:= Mid(DataStr, Pos('|', DataStr) + 1, 255);

    if fFBClient2.InTransaction then begin
      fFBClient2.CommitTransaction;
    end;
    fFBClient2.SQL.Text:= 'select * from ' + ATable + ' order by ' + AShowedField;
    fFBClient2.SQLExecute;
    fFBClient2.LastRecord;
    DataStr:= '';
    for I:= 0 to fFBClient2.RecordSetCount - 1 do begin
      fFBClient2.RecordSetIndex:= I;
      DataStr:= DataStr + fFBClient2.Field[AStoredField] + '|' + fFBClient2.Field[AShowedField] + '|';
    end;
    fFBClient.CommitTransaction;
    DataStr:= DeleteLastString(DataStr, '|');
    Datos[3]:= DataStr;
    DataStr:= '';
    for I:= Low(Datos) to High(Datos) do begin
      DataStr:= DataStr + Datos[I] + ',';
    end;
    fINI.WriteString(fTableInINI + '-F', FieldName, DataStr);
  end
  else begin
    if DataStr.StartsWith('{"') and DataStr.EndsWith('"}') then begin
      DataStr:= Copy(DataStr, 3, DataStr.Length - 4);
      ATable:= CopyToStrPos(DataStr, ':');
      AShowedField:= Copy(DataStr, ATable.Length + 2, DataStr.Length);
      Datos[3]:= ReadStringAndResolve(ATable, AShowedField, '');
    end;
  end;
  Result:= Split(Datos[3], '|');
end;

procedure TRawFBAC.FillStringListAllTable(Field2Show, Filter, OrderBy: String; StrLst: TStrings);
begin
  FreeTStringsFromStringList(StrLst);
  StrLst.Clear;
  if fFBClient2.InTransaction then
    fFBClient2.CommitTransaction;

  fFBClient2.SQL.Text:= 'select * from ' + fTable;
  if Filter <> '' then begin
    fFBClient2.SQL.Text:= fFBClient2.SQL.Text + ' where ' + Filter;
  end;
  if OrderBy <> '' then begin
    fFBClient2.SQL.Text:= fFBClient2.SQL.Text + ' order by ' + OrderBy;
  end;

  fFBClient2.SQLExecute;
  fFBClient2.FirstRecord;
  while Not(fFBClient2.Eof) do begin
    StrLst.AddItemAndStoreString(fFBClient2.Field[Field2Show], fFBClient2.Field[UniqueField]);
    fFBClient2.NextRecord;
  end;
end;

procedure TRawFBAC.FillStringListItems(FieldName: String; StrLst: TStrings);
var i: Integer;
    Datos: StringArray;
begin
  Datos:= FillStringArrayWithFieldLS(FieldName);

  StrLst.FreeTheStoredStrings;
  StrLst.Clear;
  i:= 0;
  while i < High(Datos) do begin
    StrLst.AddItemAndStoreString(Datos[i + 1], Datos[i]);
    i:= i + 2;
  end;
end;

function TRawFBAC.CreateTable: Boolean;
  function CreateIndexName(AName: String): String;
  begin
    if Length(AName) >= 28 then begin
      Result:= Copy(AName, 1, 28);
    end
    else begin
      Result:= AName;
    end;
  end;

var ActualTable: String;
    J: Integer;
    Indices: StringArray;
    Barra, Coma: Char;
    AIndexName: String;
    GeneratorInitValue: String;
begin
  Barra:= '|';
  Coma:= ',';

  try
    ActualTable:= 'CREATE TABLE ' + fTable + '(PRV_TIMESTAMP TimeStamp,';

    for J := 0 to GetFieldCount - 1 do begin
      ActualTable:= ActualTable + '   ' + GetFieldNameByNumber(J) + ' ' + FieldSQLType[GetFieldNameByNumber(J)] + ',';
    end;
    ActualTable:= ActualTable + '   Deleted_FLD Char(1) Default ''0'',';

    Indices:= Split(GetTableIndices, ',');

    ActualTable:= ActualTable + 'PRIMARY KEY (' + ReplaceString(Indices[0], Barra, Coma) + '));' + #1;
    fFBClient2.SQL.Text:= ActualTable;

    for J := 1 to High(Indices) do begin
      if (UpperCase(GetUniqueField) <> UpperCase(Indices[J])) then
        AIndexName:= CreateIndexName(UpperCase(Table) + '_' + UpperCase(ReplaceString(Indices[J], Barra, '_')));
        fFBClient2.SQL.Add ('CREATE INDEX ' + AIndexName + '_A ON ' + Table + '(' + UpperCase(ReplaceString(Indices[J], Barra, Coma)) + ');' + #1);
      fFBClient2.SQL.Add ('CREATE DESCENDING INDEX ' + AIndexName + '_D ON ' + Table + '(' + UpperCase(ReplaceString(Indices[J], Barra, Coma)) + ');' + #1);
      fFBClient2.SQL.Add ('');
    end;

    if GetTableGenerator <> '' then begin
      fFBClient2.SQL.Add('CREATE GENERATOR ' + GetTableGenerator + ';' + #1);

      GeneratorInitValue:= ReadStringAndResolve('General', 'GeneratorInitValue', '1');
      if ReadStringAndResolve(fTableInINI, 'GeneratorInitValue', '') <> '' then begin
        GeneratorInitValue:= ReadStringAndResolve(fTable, 'GeneratorInitValue', '');
      end;
      //GeneratorInitValue:= IntToStr(ValInt(GeneratorInitValue) - 1);

      fFBClient2.SQL.Add('SET GENERATOR ' + GetTableGenerator + ' TO ' + GeneratorInitValue + ';' + #1);
    end;
    fFBClient2.SQL.Add ('COMMIT;');
    try
      fFBClient2.SQLsExecute(fFBClient2.SQL, #1);
      Result:= True;
    except

    end;
  except
    Result:= False;
  end;
  fFBClient2.CommitTransaction;
end;

procedure TRawFBAC.CtrlChangeEnabler(Sender: TObject);
  function EnableTheCtrl(Str1, Str2: String; Idx: Integer): Boolean;
  begin
    case Idx of
      0: Result:= Str1 = Str2;
      1: Result:= Str1 <> Str2;
    end;
  end;

var CtrlName, EnablerStr: String;
    I, Idx, J: Integer;
    CtrlEnableBool: Boolean;
    SepFound: String;
    SepArrayDyn: StringArray;
const SepArray: array [0..1] of string = ('=', '<>');
begin
  CtrlName:= (Sender as TControl).Name;
  if CtrlName.Length > 3 then begin
    CtrlName:= Copy(CtrlName, 4, CtrlName.Length);

    for I:= Low(FieldsArray) to High(FieldsArray) do begin
      EnablerStr:= FieldHasEnabler(FieldsArray[I]);

      SetLength(SepArrayDyn, Length(SepArray));
      for J:= Low(SepArray) to High(SepArray) do begin
        SepArrayDyn[J]:= CtrlName + SepArray[J];
      end;

      if StrStartWithAnyOfArray(EnablerStr, Idx, SepArrayDyn) then begin
        EnablerStr:= Copy(EnablerStr, Pos(SepArray[Idx], EnablerStr) + Length(SepArray[Idx]), EnablerStr.Length);
        if FieldUseComponent('TEdit', CtrlName) then begin
          CtrlEnableBool:= EnableTheCtrl((Sender as TEdit).Text, EnablerStr, Idx);
        end
        else begin
          if FieldUseComponent('TCheckBox', CtrlName) then begin
            CtrlEnableBool:= ((EnablerStr = '1') and ((Sender as TCheckBox).Checked)) or ((EnablerStr = '0') and ((Sender as TCheckBox).Checked = False))
          end
          else begin
            if FieldUseComponent('TComboBox', CtrlName) then begin
              CtrlEnableBool:= EnableTheCtrl(LSValueFromComboBox('', (Sender as TComboBox)), EnablerStr, Idx);
            end;
          end;
        end;

        if (Sender as TControl).Parent.FindComponent('lbl' + MakeComponentName(FieldsArray[I])) <> nil then begin
          ((Sender as TControl).Parent.FindComponent('lbl' + MakeComponentName(FieldsArray[I])) as TLabel).Enabled:= CtrlEnableBool;
          if FieldUseComponent('TEdit', FieldsArray[I]) then begin
            ((Sender as TControl).Parent.FindComponent('edt' + MakeComponentName(FieldsArray[I])) as TEdit).Enabled:= CtrlEnableBool;
          end
          else begin
            if FieldUseComponent('TCheckBox', FieldsArray[I]) then begin
              ((Sender as TControl).Parent.FindComponent('chk' + MakeComponentName(FieldsArray[I])) as TCheckBox).Enabled:= CtrlEnableBool;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TRawFBAC.AddCalculatedField(FieldName, Expression: String);
var I, Idx: Integer;
begin
  Idx:= -1;
  for I:= Low(fCalculatedField) to High(fCalculatedField) do begin
    if fCalculatedField[I].FieldName = UpperCase(FieldName) then begin
      Idx:= I;
      Break;
    end;
  end;
  if Idx = -1 then begin
    SetLength(fCalculatedField, Length(fCalculatedField) + 1);
    Idx:= High(fCalculatedField);
  end;
  fCalculatedField[Idx].FieldName:= UpperCase(FieldName);
  fCalculatedField[Idx].Expression:= GenerateExpressionForCalculatedField(Expression);
end;

procedure TRawFBAC.AddColumn(ColumnName, ColumnCaption: String; Alignment: TAlignment; EventName: TAddedColumnEvent);
var NewCant: Integer;
begin
  NewCant:= Length(fColumnAddedCaptions) + 1;
  if NewCant = 0 then begin
    NewCant:= 1;
  end;

  SetLength(fColumnAddedNames, NewCant);
  SetLength(fColumnAddedCaptions, NewCant);
  SetLength(fColumnAddedEvents, NewCant);
  SetLength(fColumnAlignments, NewCant);

  fColumnAddedNames[High(fColumnAddedCaptions)]:= ColumnName;
  fColumnAddedCaptions[High(fColumnAddedCaptions)]:= ColumnCaption;
  fColumnAddedEvents[High(fColumnAddedEvents)]:= EventName;
  fColumnAlignments[High(fColumnAddedEvents)]:= Alignment;
end;

procedure TRawFBAC.AddDefaultValue(Field, Value: String);
var NewValue: String;
begin
  NewValue:= Field + '=' + Value;
  if fDefaultValues.IndexOf(NewValue) > -1 then begin
    fDefaultValues.Delete(fDefaultValues.IndexOf(NewValue));
  end
  else begin
    if IndexPartOf(fDefaultValues, Field + '=') > -1 then begin
      fDefaultValues.Delete(IndexPartOf(fDefaultValues, Field + '='));
    end;
  end;
  fDefaultValues.Add(NewValue);
end;

procedure TRawFBAC.AddedBrowseButtonsClick(Sender: TObject);
var Num: String;
    I: Integer;
    UKData: StringArray;
    Where: String;
    F: TfrmRawFBACBrowser;
begin
  F:= ((Sender as TButton).Parent as TfrmRawFBACBrowser);
  Num:= Copy((Sender as TButton).Name, Length('boton') + 1, 255);
  if fBrowseEnableWithDelete[StrToInt(Num)] then begin
    Where:= '';
    UKData:= Split(F.GridBrowser.Cell[F.GridBrowser.ColumnByName['NxColUniqueField'].Position, F.GridBrowser.SelectedRow].AsString, '|');
    for I:= Low(UKData) to High(UKData) do begin
      Where:= Where + fUKFields[i] + '=' + UKData[i] + ',';
      fUKData[i]:= UKData[i];
    end;
    Where:= DeleteLastComma(Where);

    CreateRecordSet(Where, '*');
    if Not(fFBClient.Eof) then begin
      PutDataInArray;
    end;
  end;
  fBrowseClickEvents[StrToInt(Num)](Sender);
end;

procedure TRawFBAC.AddEventIfIsAssigned(Control: TControl; EventName: String; ANotifyEvent: TNotifyEvent; AKeyDownEvent: TKeyEvent; AKeyPressEvent: TKeyPressEvent; var Vector: TEventRedirectorArray);
begin
  if Assigned(ANotifyEvent) or Assigned(AKeyDownEvent) or Assigned(AKeyPressEvent) then begin
    SetLength(Vector, Length(Vector) + 1);
    Vector[High(Vector)].ControlName:= Control.Name;
    Vector[High(Vector)].EventName:= EventName;
    Vector[High(Vector)].ANotifyEvent:= ANotifyEvent;
    Vector[High(Vector)].AKeyDownEvent:= AKeyDownEvent;
    Vector[High(Vector)].AKeyPressEvent:= AKeyPressEvent;
  end;
end;

procedure TRawFBAC.AddEvents4Browser(AFirebirdTable: TRawFBAC; BrowseField, ShowField: String; AEdit: TEdit; AButton: TButton; APanel: TPanel);
var ARecord: TBrowserCtrlsRedirector;
begin
  if Not(Assigned(fBrowserCtrlsRedirectorList)) then begin
    fBrowserCtrlsRedirectorList:= TList<TBrowserCtrlsRedirector>.Create;
  end;
  ARecord.AFirebirdTable:= AFirebirdTable;
  ARecord.BrowseField:= BrowseField;
  ARecord.ShowField:= ShowField;
  ARecord.AEdit:= AEdit;
  ARecord.AButton:= AButton;
  ARecord.APanel:= APanel;

  SetEvents4Edit('IN', AEdit);
  AddEventIfIsAssigned(AEdit, 'OnChange', AEdit.OnChange, nil, nil, fControlsEvents);
  AEdit.OnChange:= Edit4BrowserChange;
  AButton.OnClick:= Button4BrowserClick;

  fBrowserCtrlsRedirectorList.Add(ARecord);
end;

procedure TRawFBAC.AddFieldInAM(FieldName, FieldParams, AfterField: String; BeforeEdit, AfterEdit: TNotifyEvent; AColumnEvent: TAddedColumnEvent);
  procedure SplitIdentAndValue(const AText: String; out AIdent, AValue: String);
  var I: Integer;
  begin
    I:= Pos('=', AText);
    AIdent:= Copy(AText, 1, I - 1);
    AValue:= Copy(AText, I + 1, AText.Length);
  end;

var SL, SL2: TStrings;
    I, J: Integer;
    AIdent, AValue: String;
    AnArray: StringArray;
    AddField: Boolean;
begin
  FieldName:= UpperCase(FieldName);
  SL:= TStringList.Create;
  fINI.ReadSectionValues(fTableInINI + '-F', SL);
  for I:= 0 to SL.Count - 1 do begin
    if SL[I].StartsWith(UpperCase(AfterField) + '=', True) then begin
      for J:= (I + 1) to SL.Count - 1 do begin
        fINI.DeleteKey(fTableInINI + '-F', Copy(SL[J], 1, Pos('=', SL[J]) - 1));
      end;
      AnArray:= Split(FieldParams, ',', False);
      if Length(AnArray) < 5 then
        SetLength(AnArray, 5);
      AnArray[4]:= 'VF';
      FieldParams:= ArrayToString(AnArray, ',', False);

      fINI.WriteString(fTableInINI + '-F', FieldName, FieldParams);
      for J:= (I + 1) to SL.Count - 1 do begin
        SplitIdentAndValue(SL[J], AIdent, AValue);
        fINI.WriteString(fTableInINI + '-F', AIdent, AValue);
      end;
      J:= -1;

      AddField:= True;
      for J:= Low(fVirtualFieldsEvents) to High(fVirtualFieldsEvents) do begin
        if fVirtualFieldsEvents[J].FieldName = FieldName then begin
          AddField:= False;
          Break;
        end;
      end;

      if AddField then begin
        SetLength(fVirtualFieldsEvents, Length(fVirtualFieldsEvents) + 1);
        J:= High(fVirtualFieldsEvents);

        fVirtualFieldsEvents[J].FieldName:= FieldName;
        fVirtualFieldsEvents[J].ABeforeEvent:= BeforeEdit;
        fVirtualFieldsEvents[J].AAfterEvent:= AfterEdit;
      end;
      Break;
    end;
  end;

  SL.Free;
end;

procedure TRawFBAC.AddInfoToINI(Info: TStringList);
var SL: TStringList;
begin
  SL:= TStringList.Create;
  fINI.GetStrings(SL);
  SL.AddStrings(Info);
  fINI.SetStrings(SL);
  SL.Free;
end;

function TRawFBAC.AfterFieldIsCRLF(FieldName: String): Boolean;
var Datos: StringArray;
    St: String;
begin
  St:= fINI.ReadString(fTableInINI + '-F', FieldName, '');
  Datos:= Split(St, ',');
  SetLength(Datos, 5);
  Result:= (Pos('{CRLF}', UpperCase(Datos[4])) > 0);
  //Result:= StringStartWith(UpperCase(Datos[4]), '{CRLF}');
end;

function TRawFBAC.AllTable2Str(AProgressBar: TProgressBar = nil): AnsiString;
var I, RowCount: Integer;
    IncludeFieldNames: Boolean;
    St: AnsiString;
begin
  SQL.Text:= 'select * from ' + Table;
  ExecuteSQL;
  RowCount:= RecordCount;
  if AProgressBar <> nil then begin
    AProgressBar.Max:= RowCount;
  end;
  I:= 1;
  IncludeFieldNames:= True;
  St:= '';
  while I < RowCount do begin
    SQL.Text:= 'select * from ' + Table + ' order by ' + GetUniqueField + ' rows ' + IntToStr(I) + ' to ' + IntToStr(I + 99);
    ExecuteSQL;
    St:= St + RecordSet2Str(IncludeFieldNames, AProgressBar);
    Inc(I, 100);
    IncludeFieldNames:= False;
  end;
  if St <> '' then begin
    Result:= St;
  end
  else begin
    Result:= '';
  end;
  CommitTransaction;
  if AProgressBar <> nil then begin
    AProgressBar.Max:= 0;
    AProgressBar.Position:= 0;
  end;
end;

function TRawFBAC.AMForm(Modifying: Boolean): Boolean;
var F: TForm;
    ContLinea, HeightThisLine, X, Y, I, J, CompWidth, CompHeight,
    MaxWidth: Integer;
    FieldsNames: StringArray;
    btnA, btnC: TButton;
    Value, Form2Str, AHLine: String;
    ABevel: TBevel;
    ALabel: TLabel;
begin
  F:= TForm.Create(Self.fParent);
  F.Caption:= TableTitle + ' - ';
  if Modifying then begin
    F.Caption:= F.Caption + 'Modificar';
    F.Tag:= 1;
  end
  else begin
    F.Caption:= F.Caption + 'Nuevo';
    F.Tag:= 0;
    InitRecord;
  end;

  X:= 8;
  Y:= 8;
  FieldsNames:= FieldsArray;

  MaxWidth:= 0;
  ContLinea:= 0;
  HeightThisLine:= 0;
  for I:= Low(FieldsNames) to High(FieldsNames) do begin
    if FieldIsVisible[FieldsNames[I]] then begin
      Inc(ContLinea);
      if (FieldIsAloneInLine(FieldsNames[i])) or (BeforeFieldDrawHLine(FieldsNames[I], AHLine)) then begin
        X:= 8;
        if ContLinea > 0 then begin
          Y:= Y + HeightThisLine + 8;
          HeightThisLine:= 0;
          ContLinea:= 0;
        end;

        if BeforeFieldDrawHLine(FieldsNames[I], AHLine) then begin
          ABevel:= TBevel.Create(F);
          ABevel.Parent:= F;
          ABevel.Name:= 'bvl' + MakeComponentName(FieldsNames[I]);
          ABevel.Shape:= bsTopLine;
          ABevel.Height:= 2;
          ABevel.Left:= X;
          ABevel.Top:= Y;

          ALabel:= TLabel.Create(F);
          ALabel.Parent:= F;
          ALabel.Name:= 'lbb' + MakeComponentName(FieldsNames[I]);
          ALabel.Left:= X;
          ALabel.Top:= Y - (ALabel.Height div 2);
          ALabel.Caption:= AHLine;
          ALabel.Transparent:= False;
          Y:= Y + 10;
        end;
      end;

      CreateComponent(Modifying, F, FieldsNames[I], X, Y, CompWidth, CompHeight);
      if (X + CompWidth) > MaxWidth then
        MaxWidth:= X + CompWidth;

      X:= X + CompWidth + 8;
      if CompHeight > HeightThisLine then begin
        HeightThisLine:= CompHeight;
      end;

      if (AfterFieldIsCRLF(FieldsNames[i])) or (i = High(FieldsNames)) or (FieldIsAloneInLine(FieldsNames[i])) or
         (((X * 100) div Screen.WorkAreaWidth) > 50) then begin
        X:= 8;
        Y:= Y + HeightThisLine + 8;
        ContLinea:= 0;
        HeightThisLine:= 0;
      end;
    end;
  end;
  for I:= 0 to F.ControlCount - 1 do begin
    if (F.Controls[I] is TEdit) then begin
      (F.Controls[I] as TEdit).OnChange((F.Controls[I] as TEdit));
    end
    else begin
      if (F.Controls[I] is TCheckBox) then begin
        (F.Controls[I] as TCheckBox).OnClick((F.Controls[I] as TCheckBox));
      end
      else begin
        if (F.Controls[I] is TComboBox) then begin
          (F.Controls[I] as TComboBox).OnChange((F.Controls[I] as TComboBox));
        end;
      end;
    end;
  end;

  for I:= 0 to F.ControlCount - 1 do begin
    if (F.Controls[I] is TBevel) then begin
      (F.Controls[I] as TBevel).Width:= MaxWidth - 8;
    end;
  end;


  // Crear botones: 'Guardar' y 'Cancelar'
  btnC:= TButton.Create(F);
  btnC.Parent:= F;
  btnC.Cancel:= True;
  btnC.Caption:= '&Cancelar';
  btnC.ModalResult:= mrCancel;
  btnC.Top:= Y + 8;
  btnC.Left:= MaxWidth - btnC.Width;

  btnA:= TButton.Create(F);
  btnA.Parent:= F;
  btnA.Cancel:= True;
  btnA.Caption:= '&Guardar';
  //btnA.ModalResult:= mrOK;
  btnA.OnClick:= btnGuardarClick;
  btnA.Top:= btnC.Top;
  btnA.Left:= btnC.Left - btnA.Width - 8;

  F.BorderStyle:= bsSingle;
  F.BorderIcons:= [biSystemMenu];
  F.Position:= poScreenCenter;

  F.ClientWidth:= MaxWidth + 8;
  F.ClientHeight:= Y + btnC.Height + 16;

  btnA.TabOrder:= btnC.TabOrder;

  // Borrar línea de abajo
  if fCopyToClipBoardAMForm then begin
    Form2Str:= ComponentToString(F);
    Form2Str:= Form2Str + #13#10;
    for I:= 0 to F.ComponentCount - 1 do begin
      Form2Str:= Form2Str + ComponentToString(F.Components[i]);
      Form2Str:= Form2Str + #13#10;
    end;
    Clipboard.AsText:= Form2Str;
  end
  else begin
    Result:= F.ShowModal = mrOK;
    if Result then begin
      for I:= Low(FieldsNames) to High(FieldsNames) do begin
        if Not(FieldIsVirtual[FieldsNames[I]]) then begin
          if FieldIsVisible[FieldsNames[I]] then begin
            Value:= '';
            if FieldUseComponent('TEdit', FieldsNames[i]) then begin
              Value:= (F.FindComponent('edt' + MakeComponentName(FieldsNames[i])) as TEdit).Text;
            end;
            if FieldUseComponent('TComboBox', FieldsNames[i]) then begin
              Value:= LSValueFromComboBox(FieldsNames[i], (F.FindComponent('cmb' + MakeComponentName(FieldsNames[i])) as TComboBox));
            end;
            if FieldUseComponent('TCheckBox', FieldsNames[i]) then begin
              Value:= Iif((F.FindComponent('chk' + MakeComponentName(FieldsNames[i])) as TCheckBox).Checked, '1', '0');
            end;
            if FieldUseComponent('TDateTimePicker', FieldsNames[i]) then begin
              Value:= FormatDateTime('dd/mm/yyyy', (F.FindComponent('dtp' + MakeComponentName(FieldsNames[i])) as TDateTimePicker).Date);
            end;

            //Field[FieldsNames[i]]:= PrepareEditText4Save(FieldsNames[i], Value);
            Field[FieldsNames[i]]:= Value;
          end;
        end
        else begin
          // Es virtual
          for J:= Low(fVirtualFieldsEvents) to High(fVirtualFieldsEvents) do begin
            if fVirtualFieldsEvents[J].FieldName = UpperCase(FieldsNames[I]) then begin
              if FieldUseComponent('TEdit', FieldsNames[I]) then begin
                fVirtualFieldsEvents[J].AAfterEvent((F.FindComponent('edt' + MakeComponentName(FieldsNames[I])) as TEdit));
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  while F.ControlCount > 0 do begin
    if (F.Controls[0].ClassName = 'TComboBox') then
      FreeTStringsFromComboBox((F.Controls[0] as TComboBox));
    F.Controls[0].Free
  end;

  F.Free;
end;

procedure TRawFBAC.BackupDatabase(FBKFilename: String; var ALabel: TLabel);
var FBBackup: TRawFBServices;
    Tabla, St, AMessage: String;
begin
  {
  PB1.Max:= FBQuery.Fields.FieldByName('Tablas').AsInteger;
  PB1.Position:= 0;
  FBDatabase.Connected:= False;
  }
  FBBackup:= TRawFBServices.Create;
  FBBackup.User:= fFBClient.User;
  FBBackup.Password:= fFBClient.Password;
  FBBackup.Host:= fFBClient.Host;
  FBBackup.Port:= fFBClient.Port;
  FBBackup.Attach;
  FBBackup.StartBackup(Self.fFBClient.Database, FBKFilename);

  while FBBackup.GetNextLine(AMessage) do begin
    if Pos('records written', AMessage) > 0 then begin
      St:= Trim(Copy(AMessage, 6, Pos('records written', AMessage)-6));
      St:= FloatToStrF(StrToInt(St), ffNumber, 100, 0);
      ALabel.Caption:= 'Respaldando tabla: ' + Tabla + ' (' + St + ' registros)'
    end;
    if Pos('records restored', AMessage) > 0 then begin
      St:= Trim(Copy(AMessage, 6, Pos('records restored', AMessage)-6));
      St:= FloatToStrF(StrToInt(St), ffNumber, 100, 0);
      ALabel.Caption:= 'Restaurando tabla: ' + Tabla + ' (' + St + ' registros)'
    end;
    if PosQuita('restoring data for table ', AMessage) then begin
      ALabel.Caption:= 'Restaurando tabla: ' + AMessage;
      Tabla:= AMessage;
    end;
    if PosQuita('writing data for table ', AMessage) then begin
      ALabel.Caption:= 'Respaldando tabla: ' + AMessage;

      Tabla:= AMessage;
      //PB1.Position:= PB1.Position + 1;
    end;
    if PosQuita('writing domains ', AMessage) then begin
      ALabel.Caption:= 'Respaldando dominios';
    end;
    if PosQuita('restoring domains ', AMessage) then begin
      ALabel.Caption:= 'Restaurando dominios';
    end;
    if PosQuita('writing id generators', AMessage) then begin
      ALabel.Caption:= 'Respaldando generadores';
    end;
    if PosQuita('restoring id generators', AMessage) then begin
      ALabel.Caption:= 'Restaurando generadores';
    end;
    if PosQuita('activating and creating deferred index', AMessage) then begin
      ALabel.Caption:= 'Creando y activando índice ' + AMessage;
    end;
    ALabel.Refresh;
  end;
  FBBackup.Free;
end;

function TRawFBAC.BeforeFieldDrawHLine(FieldName: String; out AText: String): Boolean;
var Datos: StringArray;
    St: String;
const
    DrawHLine = '{DRAWHLINE:';
begin
  St:= fINI.ReadString(fTableInINI + '-F', FieldName, '');
  Datos:= Split(St, ',');
  SetLength(Datos, 6);
  Result:= StringStartWith(UpperCase(Datos[5]), DrawHLine);
  if Result then begin
    AText:= Copy(Datos[5], Pos(DrawHLine, UpperCase(Datos[5])) + Length(DrawHLine), Length(Datos[5]));
    AText:= DeleteLastString(AText, '}');
  end;
end;

function TRawFBAC.Bof: Boolean;
begin
  Result:= fFBClient.RecordSetIndex = 0;
end;

procedure TRawFBAC.BrowseAddButton(Caption: String; EnableWithDeleteBtn: Boolean; ClickEvent: TNotifyEvent);
var Cant: Integer;
begin
  Cant:= High(fBrowseCaptions);
  if Cant = -1 then
    Cant:= 0
  else
    Inc(Cant);

  SetLength(fBrowseCaptions, Cant + 1);
  SetLength(fBrowseEnableWithDelete, Cant + 1);
  SetLength(fBrowseClickEvents, Cant + 1);

  fBrowseCaptions[Cant]:= Caption;
  fBrowseEnableWithDelete[Cant]:= EnableWithDeleteBtn;
  fBrowseClickEvents[Cant]:= ClickEvent;
end;

procedure TRawFBAC.BrowseAllTables;
var F: TfrmRawFBACExplorer;
begin
  F:= TfrmRawFBACExplorer.Create(fParent);
  F.INI:= fINI.FileName;
  F.ShowModal;
  F.Free;
end;

procedure TRawFBAC.BrowseGenerators;
var F: TfrmGenerators;
begin
  F:= TfrmGenerators.Create(fParent);
  F.ShowModal;
  F.Free;
end;

function TRawFBAC.BrowseTable(CreateNewRecordSet: Boolean = True): Boolean;
var R, J, K: Integer;
    Cols: StringArray;
    ACol: TNxTextColumn;
    Opt: TColumnOptions;
    Selected, St: String;
    I: Integer;
    btn: TButton;
    F: TfrmRawFBACBrowser;
begin
  Selected:= GetField(UniqueField);

  F:= TfrmRawFBACBrowser.Create(fParent);
  F.btnModificar.OnClick:= btnModifyClick;
  F.btnNuevo.OnClick:= btnNewClick;
  F.btnEliminar.OnClick:= btnDeleteClick;

  F.fCanDeleteInBrowser:= fCanDeleteInBrowser;
  F.fBrowseEnableWithDelete:= fBrowseEnableWithDelete;
  F.fBrowseOnWrite:= fBrowseOnWrite;
  F.fBrowserSearchStarts:= fBrowserSearchStarts;

  F.Table:= fTable;
  F.INI:= fINI.FileName;
  F.Caption:= GetTableTitle;
  F.ARawFBACInstance:= Self;
  Cols:= Split(Fields4Browser, ',');
  for R:= -1 to High(Cols) do begin
    if R = -1 then begin // UniqueField
      ACol:= TNxTextColumn.Create(F.GridBrowser);
      ACol.Name:= 'NxColUniqueField';
      ACol.Visible:= False;
    end
    else begin
      ACol:= TNxTextColumn.Create(F.GridBrowser);
      ACol.Name:= 'NxCol' + Cols[R];
      ACol.Header.Caption:= ' ' + FieldTitle[Cols[R]];
      ACol.Width:= GetGridColWidth(Cols[R]);
      if FieldIsNumeric(Cols[R]) then begin
        ACol.SortType:= stNumeric;
      end
      else begin
        if FieldType[Cols[R]] = 'DA' then begin
          ACol.SortType:= stDate;
        end
        else begin
          ACol.SortType:= stCaseInsensitive;
        end;
      end;
      ACol.Visible:= Not(FieldIsVirtual[Cols[R]]);
    end;
    F.GridBrowser.Columns.AddColumn(ACol);
  end;
  for I:= Low(fColumnAddedCaptions) to High(fColumnAddedCaptions) do begin
    ACol:= TNxTextColumn.Create(F.GridBrowser);
    ACol.Name:= 'AddCol' + IntToStr(I);
    ACol.Header.Caption:= ' ' + fColumnAddedCaptions[I];
    ACol.Width:= 50;
    ACol.Alignment:= fColumnAlignments[I];
    F.GridBrowser.Columns.AddColumn(ACol);
  end;

  F.cmbField.Clear;
  for R:= 0 to F.GridBrowser.Columns.Count - 1 do begin
    if F.GridBrowser.Columns[R].Visible then begin
      F.cmbField.Items.Add(F.GridBrowser.Columns[R].Header.Caption);
      if LowerCase('NxCol' + fDefault4Browse) = LowerCase(F.GridBrowser.Columns[R].Name) then begin
        F.cmbField.ItemIndex:= F.cmbField.Items.Count - 1;
      end;
    end;
  end;

  for I := 0 to High(fBrowseCaptions) do begin
    Btn:= TButton.Create(F);
    Btn.Name:= 'boton' + IntToStr(i);
    Btn.Parent:= F;
    Btn.Top:= F.btnEliminar.Top;
    Btn.Left:= 8 + (i * (Btn.Width + 8));
    Btn.Caption:= fBrowseCaptions[i];
    Btn.OnClick:= AddedBrowseButtonsClick;
    Btn.Enabled:= Not(fBrowseEnableWithDelete[i]);
  end;
  F.btnEliminar.Visible:= fShowABMButtons;
  F.btnModificar.Visible:= fShowABMButtons;
  F.btnNuevo.Visible:= fShowABMButtons;

  if CreateNewRecordSet or IsBigTable then begin
    if IsBigTable then begin
      CommitTransaction;
    end
    else begin
      CreateRecordSetLinked('', '*');
    end;
  end;
  F.GridBrowser.BeginUpdate;
  F.GridBrowser.ClearRows;
  F.GridBrowser.AddRow(RecordCount);
  FirstRecord;

  for R:= 0 to RecordCount - 1 do begin
    St:= '';
    for K:= 0 to fUKFields.Count - 1 do begin
      St:= St + fUKData.Strings[K] + '|';
    end;
    St:= DeleteLastString(St, '|');
    F.GridBrowser.Cell[0, R].AsString:= St;
    for J:= 0 to High(Cols) do begin
      F.GridBrowser.Cell[J + 1, R].AsString:= FieldLinked[Cols[J]];
    end;
    if Selected = GetField(UniqueField) then begin
      F.GridBrowser.SelectedRow:= R;
    end;
    for I:= Low(fColumnAddedCaptions) to High(fColumnAddedCaptions) do begin
      F.GridBrowser.Cell[J + 1 + I, R].AsString:= fColumnAddedEvents[I](fParent, Self, fColumnAddedNames[I]);
    end;
    if Field['Deleted_Fld'] = '1' then begin
      for J:= 0 to High(Cols) do begin
        F.GridBrowser.Cell[J + 1, R].Color:= clRed;
      end;

    end;
    NextRecord;
  end;
  CommitTransaction;

  F.GridBrowser.SortColumn(F.GridBrowser.ColumnByName['NxCol' + fDefault4Browse], True);
  Opt:= F.GridBrowser.Columns[F.GridBrowser.Columns.Count - 1].Options + [coAutoSize];
  F.GridBrowser.Columns[F.GridBrowser.Columns.Count - 1].Options:= Opt;
  F.GridBrowser.EndUpdate;

  if fBrowseCaption <> '' then begin
    F.Caption:= fBrowseCaption;
  end;

  R:= F.ShowModal;
  if R = 1 then begin
    Cols:= Split(F.GridBrowser.Cell[0, F.GridBrowser.SelectedRow].AsString, '|');
    St:= '';
    for I:= 0 to fUKFields.Count - 1 do begin
      St:= St + fUKFields.Strings[I] + '=' + Cols[i] + ',';
    end;
    St:= DeleteLastComma(St);
    CreateRecordSetLinked(St, '*');
  end;
  Result:= (R = 1); // Aceptó

  for I := 0 to High(fBrowseCaptions) do begin
    F.FindComponent('boton' + IntToStr(i)).Free;
  end;
  SetLength(fBrowseCaptions, 0);
  SetLength(fBrowseClickEvents, 0);

  F.Free;
end;

function TRawFBAC.BrowseTableAndCommit: Boolean;
begin
  Result:= BrowseTable;
  CommitTransaction;
end;

procedure TRawFBAC.btnBrowseClick(Sender: TObject);
var Fire: TRawFBAC;
    FieldName, TableLinked, FieldShowed, FieldSaved: String;
    BrowseAllFields: Boolean;
begin
  FieldName:= Copy((Sender as TButton).Name, 4, 255);
  FieldLinkedInfo(FieldName, TableLinked, FieldShowed, FieldSaved, BrowseAllFields);
  Fire:= TRawFBAC.CreateMemINI(((Sender as TButton).Parent as TForm), TableLinked, fINI);
  if Fire.BrowseTable then begin
    (((Sender as TButton).Parent as TForm).FindComponent('edt' + MakeComponentName(FieldName)) as TEdit).Text:= Fire.Field[FieldSaved];
  end;
  Fire.CommitTransaction;
  Fire.Free;
end;

procedure TRawFBAC.btnDeleteClick(Sender: TObject);
var UKData: StringArray;
    Where: String;
    I: Integer;
    F: TfrmRawFBACBrowser;
begin
  F:= ((Sender as TButton).Parent as TfrmRawFBACBrowser);
  Where:= '';
  UKData:= Split(F.GridBrowser.Cell[F.GridBrowser.ColumnByName['NxColUniqueField'].Position, F.GridBrowser.SelectedRow].AsString, '|');
  for I:= Low(UKData) to High(UKData) do begin
    Where:= Where + fUKFields[i] + '=' + UKData[i] + ',';
  end;
  Where:= DeleteLastComma(Where);

  CreateRecordSet(Where, '*');
  if Not(Eof) then begin
    if Application.MessageBox('¿Está seguro que desea eliminar el registro?', 'Eliminar registro', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES then begin
      if FShowDeleted then begin
        DeleteRecordFisically;
      end
      else begin
        DeleteRecord;
      end;
      F.GridBrowser.DeleteRow(F.GridBrowser.SelectedRow);
      F.ShowCantidad;
    end;
  end;
  F.GridBrowser.OnSelectCell(F.GridBrowser, F.GridBrowser.SelectedColumn, F.GridBrowser.SelectedRow);
end;

procedure TRawFBAC.btnFileBrowseClick(Sender: TObject);
var FieldName, FileName: String;
begin
  FieldName:= Copy((Sender as TButton).Name, 4, 255);
  if FieldIsFile(FieldName) then begin
    if OpenDlg(FieldTitle[FieldName], FieldIsFileFilter(FieldName), '', FileName) then begin
      ((Sender as TButton).Parent.FindComponent('edt' + FieldName) as TEdit).Text:= FileName;
    end;
  end;
end;

procedure TRawFBAC.btnGuardarClick(Sender: TObject);
var i: Integer;
    Fields2Ctrl: StringArray;
    Value, NoDuplicateStr, NoDuplicateError: String;
    Afrm: TForm;
begin
  Fields2Ctrl:= FieldsNotNull;
  Afrm:= ((Sender as TButton).Parent as TForm);
  for I:= Low(Fields2Ctrl) to High(Fields2Ctrl) do begin
    if (FieldIsVisible[Fields2Ctrl[I]]) and (Fields2Ctrl[I] <> UniqueField) then begin
      if FieldUseComponent('TEdit', Fields2Ctrl[i]) then begin
        Value:= (Afrm.FindComponent('edt' + MakeComponentName(Fields2Ctrl[i])) as TEdit).Text;
        if Trim(Value) = '' then begin
          Application.MessageBox(PChar('El campo ' + FieldTitle[Fields2Ctrl[i]] + ' no puede ser nulo.'), 'Atención', MB_OK+MB_ICONERROR);
          (Afrm.FindComponent('edt' + MakeComponentName(Fields2Ctrl[i])) as TEdit).SetFocus;
          Exit;
        end;
      end;
      if FieldUseComponent('TComboBox', Fields2Ctrl[i]) then begin
        Value:= LSValueFromComboBox(Fields2Ctrl[i], (Afrm.FindComponent('cmb' + MakeComponentName(Fields2Ctrl[i])) as TComboBox));
        if (Afrm.FindComponent('cmb' + MakeComponentName(Fields2Ctrl[i])) as TComboBox).ItemIndex = -1 then begin
          Application.MessageBox(PChar('El campo ' + FieldTitle[Fields2Ctrl[i]] + ' no puede ser nulo.'), 'Atención', MB_OK+MB_ICONERROR);
          (Afrm.FindComponent('cmb' + MakeComponentName(Fields2Ctrl[i])) as TComboBox).SetFocus;
          Exit;
        end;
      end;
    end;
  end;

  // No duplicate
  NoDuplicateStr:= '';
  NoDuplicateError:= '';
  Fields2Ctrl:= FieldsNoDuplicate;
  for I:= Low(Fields2Ctrl) to High(Fields2Ctrl) do begin
    if (FieldIsVisible[Fields2Ctrl[I]]) and (Fields2Ctrl[I] <> UniqueField) then begin
      if FieldUseComponent('TEdit', Fields2Ctrl[i]) then begin
        Value:= (Afrm.FindComponent('edt' + MakeComponentName(Fields2Ctrl[i])) as TEdit).Text;
      end;
      if FieldUseComponent('TComboBox', Fields2Ctrl[i]) then begin
        Value:= LSValueFromComboBox(Fields2Ctrl[i], (Afrm.FindComponent('cmb' + MakeComponentName(Fields2Ctrl[i])) as TComboBox));
      end;
      if Value <> '' then begin
        NoDuplicateStr:= NoDuplicateStr + 'Upper(' + Fields2Ctrl[I] + ') = ' + QuotedStr(UpperCase(Value)) + ' or ';
        NoDuplicateError:= NoDuplicateError + FieldTitle[Fields2Ctrl[I]] + ': ' + Value + #13#10;
      end;
    end;
  end;
  if NoDuplicateStr <> '' then begin
    fFBClient2.SQL.Text:= 'select * from ' + fTable + ' A where ' + DeleteLastString(NoDuplicateStr, ' or ');
    fFBClient2.SQL.Text:= SQLAddDeleted0(fFBClient2.SQL.Text);
    fFBClient2.SQLExecute;
    fFBClient2.LastRecord;
    if ((fFBClient2.RecordSetCount > 0) and (Afrm.Tag = 0)) or ((fFBClient2.RecordSetCount > 1) and (Afrm.Tag = 1)) then begin
      Application.MessageBox(PChar('No se pueden ingresar valores duplicados' + #13#10#13#10 + 'Alguno de los siguientes valores ya están cargados:' + #13#10 + NoDuplicateError), 'Atención', MB_OK+MB_ICONERROR);
      Exit;
    end;
  end;
  Afrm.ModalResult:= mrOK;
end;

procedure TRawFBAC.btnModifyClick(Sender: TObject);
var I: Integer;
    UKData: StringArray;
    Fields4BrowserArray: StringArray;
    Where: String;
    Accept: Boolean;
    F: TfrmRawFBACBrowser;
begin
  F:= ((Sender as TButton).Parent as TfrmRawFBACBrowser);
  Where:= '';
  UKData:= Split(F.GridBrowser.Cell[F.GridBrowser.ColumnByName['NxColUniqueField'].Position, F.GridBrowser.SelectedRow].AsString, '|');
  for I:= Low(UKData) to High(UKData) do begin
    Where:= Where + fUKFields[i] + '=' + UKData[i] + ',';
    fUKData[i]:= UKData[i];
  end;
  Where:= DeleteLastComma(Where);

  CreateRecordSet(Where, '*');
  if Not(fFBClient.Eof) then begin
    PutDataInArray;
    if Assigned(fNewModifyClickButton) then begin
      fNewModifyClickButton(Sender, True, Accept);
    end
    else begin
      Accept:= ShowModifyForm;
    end;

    if Accept then begin
      F.GridBrowser.BeginUpdate;
      Fields4BrowserArray:= Split(Fields4Browser, ',');
      Where:= '';
      for I:= 0 to fUKFields.Count - 1 do begin
        Where:= Where + Field[fUKFields[i]] + '|';
      end;
      F.GridBrowser.Cell[0, F.GridBrowser.SelectedRow].AsString:= DeleteLastString(Where, '|');
      for I:= Low(Fields4BrowserArray) to High(Fields4BrowserArray) do begin
        F.GridBrowser.Cell[I + 1, F.GridBrowser.SelectedRow].AsString:= FieldLinked[Fields4BrowserArray[i]];
      end;
      for I:= Low(fColumnAddedCaptions) to High(fColumnAddedCaptions) do begin
        F.GridBrowser.Cell[High(Fields4BrowserArray) + 2 + I, F.GridBrowser.SelectedRow].AsString:= fColumnAddedEvents[I](fParent, Self, fColumnAddedNames[I]);
      end;

      F.GridBrowser.EndUpdate;
      F.ShowCantidad;

      fFBClient2.CommitTransaction;
      fFBClient.CommitTransaction;
    end;
  end;
end;

procedure TRawFBAC.btnNewClick(Sender: TObject);
var I: Integer;
    Fields4BrowserArray: StringArray;
    St: String;
    Accept: Boolean;
    F: TfrmRawFBACBrowser;
begin
  F:= ((Sender as TButton).Parent as TfrmRawFBACBrowser);
  if Assigned(fNewModifyClickButton) then begin
    fNewModifyClickButton(Sender, False, Accept);
  end
  else begin
    Accept:= ShowNewForm;
  end;

  if Accept then begin
    F.GridBrowser.BeginUpdate;
    F.GridBrowser.AddRow;
    Fields4BrowserArray:= Split(Fields4Browser, ',');
    St:= '';
    for I:= 0 to fUKFields.Count - 1 do begin
      St:= St + fUKData[i] + '|';
    end;
    St:= DeleteLastString(St, '|');
    F.GridBrowser.Cell[0, F.GridBrowser.LastAddedRow].AsString:= St;
    for I:= Low(Fields4BrowserArray) to High(Fields4BrowserArray) do begin
      F.GridBrowser.Cell[I + 1, F.GridBrowser.LastAddedRow].AsString:= FieldLinked[Fields4BrowserArray[i]];
    end;
    for I:= Low(fColumnAddedCaptions) to High(fColumnAddedCaptions) do begin
      F.GridBrowser.Cell[High(Fields4BrowserArray) + 2 + I, F.GridBrowser.LastAddedRow].AsString:= fColumnAddedEvents[I](fParent, Self, fColumnAddedNames[I]);
    end;

    F.GridBrowser.SelectedRow:= F.GridBrowser.LastAddedRow;
    F.GridBrowser.ScrollToRow(F.GridBrowser.SelectedRow);
    F.GridBrowser.EndUpdate;
    F.ShowCantidad;
    fFBClient2.CommitTransaction;
    fFBClient.CommitTransaction;
  end;
end;

procedure TRawFBAC.Button4BrowserClick(Sender: TObject);
var I: TBrowserCtrlsRedirector;
begin
  for I in fBrowserCtrlsRedirectorList do begin
    if (I.AButton = Sender as TButton) then begin
      if (I.AFirebirdTable as TRawFBAC).BrowseTable then begin
        I.AEdit.Text:= (I.AFirebirdTable as TRawFBAC).Field[I.BrowseField];
      end;
      (I.AFirebirdTable as TRawFBAC).CommitTransaction;
    end;
  end;
end;

procedure TRawFBAC.ClearAddedColumns;
begin
  SetLength(fColumnAddedNames, 0);
  SetLength(fColumnAddedCaptions, 0);
  SetLength(fColumnAddedEvents, 0);
  SetLength(fColumnAlignments, 0);
end;

procedure TRawFBAC.ClearCalculatedFields;
begin
  SetLength(fCalculatedField, 0);
end;

procedure TRawFBAC.ClearDefaultValues;
begin
  fDefaultValues.Clear;
end;

procedure TRawFBAC.ClearEvents4Browser;
begin
  if Assigned(fBrowserCtrlsRedirectorList) then begin
    fBrowserCtrlsRedirectorList.Clear;
  end;
  SetLength(fControlsEvents, 0);
end;

procedure TRawFBAC.ClearVirtualValues;
begin
  fVirtualValues.Clear;
  fVirtualValuesIndex:= -1;
end;

procedure TRawFBAC.CommitTransaction;
begin
  if fFBClient.InTransaction then begin
    fFBClient.CommitTransaction;
  end;
end;

function TRawFBAC.ComponentToString(Component: TComponent): string;
var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

constructor TRawFBAC.Create(AOwner: TComponent; Table: String; INIFileName: String = ''; FDBHostAndFile: String = '');
begin
  if INIFileName = '' then begin
    INIFileName:= ChangeFileExt(Application.ExeName, '.ini');
    if Not(FileExists(INIFileName)) then begin
      INIFileName:= ChangeFileExt(Application.ExeName, '.rdf');
    end;
  end;

  if (Pos(':\', INIFileName) = 0) and (Pos('\\', INIFileName) = 0) and (Not(INIFileName.StartsWith('/'))) then begin
    INIFileName:= IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + INIFileName;
  end;

  fINI:= TMemIniFile.Create(INIFileName);

  CreateMemINI(AOwner, Table, fINI, FDBHostAndFile);
end;

procedure TRawFBAC.CreateAllTables;
var I: Integer;
    Tablas: TStringList;
    F: TRawFBAC;
begin
  Tablas:= TStringList.Create;
  F:= TRawFBAC.CreateMemINI(fParent, '', fINI);
  fINI.ReadSections(Tablas);
  for I:= 0 to Tablas.Count - 1 do begin
    if (Copy(Tablas[i], Length(Tablas[i]) - 1, 1) <> '-') and (UpperCase(Tablas[i]) <> 'GENERAL') then begin
      F.SetTable(Tablas[i]);
      F.UpdateTableStructure;
    end;
  end;
  F.Free;
  Tablas.Free;
end;

procedure TRawFBAC.CreateComponent(IsModifying: Boolean; AOwner: TWinControl ; FieldName: String; X, Y: Integer; var CompWidth, CompHeight: Integer);
var FieldTypeSt, CompName: String;
    Lbl: TLabel;
    Edt: TEdit;
    Btn: TButton;
    Pnl: TPanel;
    Chk: TCheckBox;
    Cmb: TComboBox;
    Dtp: TDateTimePicker;
    Img: TImage;
    DisableForced: Boolean;
    DefaultValue: String;
    Idx, I, J: Integer;
begin
  DisableForced:= (Pos(',' + UpperCase(FieldName) + ',', fDisableModifyFields) > 0);

  Idx:= IndexPartOf(fDefaultValues, FieldName + '=');
  if Idx <> -1 then
    DefaultValue:= Copy(fDefaultValues.Strings[Idx], Pos('=', fDefaultValues.Strings[Idx]) + 1, fDefaultValues.Strings[Idx].Length)
  else
    DefaultValue:= '';

  CompWidth:= 0;
  CompHeight:= 0;
  CompName:= MakeComponentName(FieldName);
  FieldTypeSt:= FieldType[FieldName];
  if FieldUseComponent('TLabel', FieldName) then begin
    Lbl:= TLabel.Create(AOwner);
    Lbl.Name:= 'lbl' + CompName;
    Lbl.Parent:= AOwner;
    Lbl.Top:= Y;
    Lbl.Left:= X;
    Lbl.Caption:= FieldTitle[FieldName];
    Lbl.AutoSize:= True;
    Y:= Y + Lbl.Height + 2;
    if Lbl.Height > CompHeight then
      CompHeight:= Lbl.Height;
    if Lbl.Width > CompWidth then
      CompWidth:= Lbl.Width;
    if DisableForced then
      Lbl.Enabled:= False;

  end;
  if FieldUseComponent('TEdit', FieldName) then begin
    Edt:= TEdit.Create(AOwner);
    Edt.Name:= 'edt' + CompName;
    Edt.Parent:= AOwner;
    Edt.Top:= Y;
    Edt.Left:= X;
    Edt.Width:= GetFieldCompWidth(FieldName);
    CompHeight:= CompHeight + Edt.Height;
    Edt.Enabled:= ((UniqueField <> FieldName)); //and (Not(IsModifying)) or (IsModifying));

    Edt.OnChange:= CtrlChangeEnabler;

    if DisableForced then
      Edt.Enabled:= False;

    if FieldTypeSt = 'ST' then begin
      Edt.MaxLength:= StrToInt(GetFieldWidth(FieldName));
      if FieldIsCUIT(FieldName) then begin
        Img:= TImage.Create(AOwner);
        Img.Parent:= AOwner;
        Img.Name:= 'Img' + FieldName + '_Edt';
        Img.Picture.Bitmap.LoadFromResourceName(HInstance, 'INVALID');
        Img.Transparent:= True;
        Img.AutoSize:= True;
        Img.Top:= Edt.Top + 1;
        Edt.Width:= Edt.Width - Img.Width - 2;
        Img.Left:= Edt.Left + Edt.Width + 2;
      end;
      if FieldIsFile(FieldName) then begin
        Btn:= TButton.Create(AOwner);
        Btn.Name:= 'btn' + CompName;
        Btn.Parent:= AOwner;
        Btn.Height:= Edt.Height;
        Btn.Width:= Btn.Height;
        Btn.Caption:= '...';
        Btn.Top:= Y;
        Edt.Width:= Edt.Width - Btn.Width - 2;
        Btn.Left:= Edt.Left + Edt.Width + 2;
        Btn.OnClick:= btnFileBrowseClick;
      end;
    end;
    if FieldTypeSt = 'DA' then begin
      if FieldIsEdad(FieldName) then begin
        Lbl:= TLabel.Create(AOwner);
        Lbl.Parent:= AOwner;
        Lbl.Name:= 'lbl' + FieldName + '_Edt';
        Lbl.Top:= Edt.Top + 3;
        Lbl.Left:= Edt.Left + Edt.Width + 8;
        CompWidth:= CompWidth + 100;
        Lbl.Caption:= '';
      end;
    end;

    if IsModifying then begin
      Edt.Text:= Field[FieldName];
    end
    else begin
      if (UniqueField = FieldName) then begin
        fFBClient2.SQL.Text:= 'SELECT GEN_ID(' + GetTableGenerator + ', 0) FROM RDB$DATABASE';
        fFBClient2.SQLExecute;
        Edt.Text:= IntToStr( StrToInt(fFBClient2.Field['GEN_ID']) + fGeneratorIncrement);
        fFBClient2.RollBackTransaction;
      end
      else begin
        Edt.Text:= DefaultValue;
      end;
    end;
    if (FieldIsVirtual[FieldName]) then begin
      for I:= Low(fVirtualFieldsEvents) to High(fVirtualFieldsEvents) do begin
        if fVirtualFieldsEvents[I].FieldName = UpperCase(FieldName) then begin
          fVirtualFieldsEvents[I].ABeforeEvent(Edt);
        end;
      end;
    end;

    SetEvents4Edit(FieldTypeSt, Edt);
    if Assigned(Edt.OnExit) then begin
      Edt.OnExit(Edt);
    end;

    if Edt.Width > CompWidth then begin
      CompWidth:= Edt.Width;
    end;

    if FieldIsCUIT(FieldName) then begin
      CompWidth:= CompWidth + Img.Width;
    end;
    if FieldIsFile(FieldName) then begin
      CompWidth:= CompWidth + Btn.Width;
    end;
  end;

  if FieldUseComponent('TCheckBox', FieldName) then begin
    Chk:= TCheckBox.Create(AOwner);
    Chk.Name:= 'chk' + CompName;
    Chk.Parent:= AOwner;
    Chk.Top:= Y + 17; // 20
    Chk.Left:= X;
    Chk.Caption:= FieldTitle[FieldName];
    Chk.Width:= (chk.Parent as TForm).Canvas.TextWidth(chk.Caption) + 20;
    if IsModifying then begin
      Chk.Checked:= Field[FieldName] = '1';
    end
    else begin
      Chk.Checked:= DefaultValue = '1';
    end;

    if DisableForced then
      Chk.Enabled:= False;

    Y:= Y + Chk.Height;
    if Chk.Height > CompHeight then
      CompHeight:= Chk.Height + 20;
    if Chk.Width > CompWidth then
      CompWidth:= Chk.Width;

    Chk.OnClick:= CtrlChangeEnabler;
  end;
  if FieldUseComponent('TComboBox', FieldName) then begin
    Cmb:= TComboBox.Create(AOwner);
    Cmb.Name:= 'cmb' + CompName;
    Cmb.Parent:= AOwner;
    Cmb.Top:= Y;
    Cmb.Left:= X;
    Cmb.Style:= csDropDownList;
    Cmb.Width:= GetFieldCompWidth(FieldName);
    CompHeight:= CompHeight + Cmb.Height;
    FillComboBoxItems(FieldName, Cmb);
    if IsModifying then begin
      Cmb.ItemIndex:= LSItemIndexFromData(Field[FieldName], Cmb);
    end
    else begin
      Cmb.ItemIndex:= LSItemIndexFromData(DefaultValue, Cmb);
    end;
    if DisableForced then
      Cmb.Enabled:= False;

    if Cmb.Width > CompWidth then
      CompWidth:= Cmb.Width;

    Cmb.OnChange:= CtrlChangeEnabler;
  end;
  if FieldUseComponent('TDateTimePicker', FieldName) then begin
    Dtp:= TDateTimePicker.Create(AOwner);
    Dtp.Name:= 'dtp' + CompName;
    Dtp.Parent:= AOwner;
    Dtp.Top:= Y;
    Dtp.Left:= X;
    Dtp.Width:= GetFieldCompWidth(FieldName);
    CompHeight:= CompHeight + Dtp.Height;

    if ((IsModifying) and (StrIsDate(Field[FieldName])))then begin
      Dtp.Date:= StrToDate(Field[FieldName]);
    end
    else begin
      if (StrIsDate(DefaultValue)) then begin
        Dtp.Date:= StrToDate(DefaultValue);
      end;
    end;
    if DisableForced then
      Dtp.Enabled:= False;

    if Dtp.Width > CompWidth then
      CompWidth:= Dtp.Width;
  end;
  if FieldUseComponent('TButton', FieldName) then begin
    Btn:= TButton.Create(AOwner);
    Btn.Name:= 'btn' + CompName;
    Btn.Parent:= AOwner;
    Btn.Top:= Y + 13;
    Btn.Left:= X;
    Btn.Caption:= FieldTitle[FieldName];
    Btn.Width:= (Btn.Parent as TForm).Canvas.TextWidth(Btn.Caption) + 20;

    for J:= Low(fVirtualFieldsEvents) to High(fVirtualFieldsEvents) do begin
      if fVirtualFieldsEvents[J].FieldName = FieldName then begin
        btn.OnClick:= fVirtualFieldsEvents[J].ABeforeEvent;
      end;
    end;

    if DisableForced then
      Btn.Enabled:= False;

    Y:= Y + Btn.Height;
    if Btn.Height > CompHeight then
      CompHeight:= Btn.Height + 20;
    if Btn.Width > CompWidth then
      CompWidth:= Btn.Width;
  end;
  if FieldTypeSt = 'LN' then begin
    Btn:= TButton.Create(AOwner);
    Btn.Name:= 'btn' + CompName;
    Btn.Parent:= AOwner;
    Btn.Height:= Edt.Height;
    Btn.Width:= Btn.Height;
    Btn.Caption:= '...';
    Btn.Top:= Y;
    Btn.Left:= X + 42;
    Btn.OnClick:= btnBrowseClick;

    Pnl:= TPanel.Create(AOwner);
    Pnl.Name:= 'pnl' + CompName;
    Pnl.Parent:= AOwner;
    Pnl.Caption:= '';
    Pnl.BevelOuter:= bvLowered;
    Pnl.Alignment:= taLeftJustify;
    Pnl.Height:= Edt.Height;
    Pnl.Top:= Y;
    Pnl.Left:= Btn.Left + Btn.Width + 2;
    Pnl.Width:= 217;
    if (Edt.Width + Pnl.Width + Btn.Width + 8) > CompWidth then begin
      CompWidth:= Edt.Width + Pnl.Width + Btn.Width + 6;
    end;

    if FieldIsNoType(FieldName) then begin
      Edt.Visible:= False;
      Btn.Left:= X;
      Pnl.Left:= (X + Btn.Width + 4);
      Pnl.Width:= Pnl.Width + Edt.Width;
    end;

    Edt.OnChange:= edtLinkChange;
    edtLinkChange(Edt);
    if Not(AllowDeadLinks) then begin
      Edt.OnExit:= edtLinkExit;
    end;

    if DisableForced then begin
      Btn.Enabled:= False;
      Pnl.Enabled:= False;
    end;
  end;
end;

constructor TRawFBAC.CreateMemINI(AOwner: TComponent; Table: String; INI: TMemIniFile; FDBHostAndFile: String);
var fHost, fDBFilename: String;
    I: Integer;
begin
  FormatSettings.ShortDateFormat:= 'dd/mm/yyyy';
  FormatSettings.LongDateFormat:= 'dddd, dd'' de ''MMMM'' de ''yyyy';
  fTimeStampFormat:= 'dd-mm-yyyy, HH:mm:ss.zzz';
  //FormatSettings.ShortTimeFormat:= 'HH:mm:ss';

  fBrowseCaption:= '';
  fShowDeleted:= False;
  fShowABMButtons:= True;
  fCanDeleteInBrowser:= True;
  fTableRecentCreated:= False;
  fParent:= AOwner;
  fFileExtensionForBLOBFields:= '.tmp';

  CopyMemIniFile(INI, fINI);
  fBrowseOnWrite:= ReadStringAndResolve('General', 'BrowseOnWrite', '0') = '1';

  try
    if (FDBHostAndFile = '') then begin
      FDBHostAndFile:= DBHost + ':' + DBFilename;
    end;
    fHost:= Copy(FDBHostAndFile, 1, Pos(':', FDBHostAndFile) - 1);
    fDBFilename:= Copy(FDBHostAndFile, Pos(':', FDBHostAndFile) + 1, 255);

    fDBIndex:= -1;

    fFBClient:= TRawFB.Create;
    fFBClient2:= TRawFB.Create;

    fFBClient.CanUseEmbedded:= ReadStringAndResolve('General', 'UseEmbedded', '0') = '1';
    fFBClient2.CanUseEmbedded:= ReadStringAndResolve('General', 'UseEmbedded', '0') = '1';

    fFBClient.Host:= fHost;
    fFBClient.Database:= fDBFilename;

    fFBClient.User:= ReadStringAndResolve('General', 'UserName', 'SYSDBA');
    fFBClient.Password:= ReadStringAndResolve('General', 'Password', 'masterkey');
    //fFBClient.User:= 'SYSDBA';
    //fFBClient.PassWord:= 'masterkey';

    fFBClient.Port:= StrToInt(DBPort);
    fFBClient.FBLibrary:= GetClientLibrary;

    fFBClient2.Host:= fHost;
    fFBClient2.Database:= fDBFilename;

    fFBClient2.User:= ReadStringAndResolve('General', 'UserName', 'SYSDBA');
    fFBClient2.Password:= ReadStringAndResolve('General', 'Password', 'masterkey');

    fFBClient2.Port:= StrToInt(DBPort);
    fFBClient2.FBLibrary:= GetClientLibrary;

    fFBClient.Connect;
    fFBClient2.Connect;

    fFBClient.LogStatementsStartsWith:= 'delete';
    fFBClient.LogStatements2File:= ChangeFileExt(Application.ExeName, '_DeleteLogs.log');

    fFBClient2.LogStatementsStartsWith:= 'delete';
    fFBClient2.LogStatements2File:= ChangeFileExt(Application.ExeName, '_DeleteLogs.log');
  except
    fFBClient.Connected:= False;
    try
      fFBClient.CreateDatabase;
      fFBClient.Connect;
      fFBClient2.Connect;
    except
      Application.MessageBox(PChar('No se puede conectar a la base de datos:' + #13#10 + fFBClient.Host + ':' + IntToStr(fFBClient.Port) + ':' + fFBClient.Database), PChar(Application.Title), MB_OK + MB_ICONERROR);
      Halt;
    end;
  end;
  Inc(InstanceCount);

  fDataValues:= TStringList.Create;
  fDataFields:= TStringList.Create;
  fFieldsChanged:= TStringList.Create;
  fVirtualValues:= TStringList.Create;
  fUKData:= TStringList.Create;
  fUKFields:= TStringList.Create;
  fDefaultValues:= TStringList.Create;

  if Table <> '' then begin
    SetTable(Table);
  end
  else begin
    fTable:= '';
    fTableInINI:= '';
  end;
  SetLength(fBrowseCaptions, 0);
  SetLength(fBrowseClickEvents, 0);
  fCopyToClipBoardAMForm:= False;
end;

procedure TRawFBAC.CreateRecordSet(SortField: String; SelField: String = '*'; Criterias: String = '');
var SortFieldSQL, OrderBySQL, SplitDelim: String;
    SortArray, SplitStr, CriteriasArray: StringArray;
    I, J, Count: Integer;
begin
  MakeWhereFromSortField(SortField, Criterias, SortFieldSQL, OrderBySQL);

  SQL.Clear;
  SQL.Add('select ');
  SQL.Add(SelField);
  SQL.Add(' from ' + FTable + ' A ');
  SQL.Add(SortFieldSQL);
  if OrderBySQL <> '' then
    SQL.Add('order by ' + DeleteLastComma(OrderBySQL));

  ExecuteSQL;
end;

function TRawFBAC.CreateRecordSetAndCount(SortField: String; SelField: String = '*'; Criterias: String = ''): Integer;
begin
  Self.CreateRecordSet(SortField, SelField, Criterias);
  Result:= Self.RecordCount;
end;

procedure TRawFBAC.CreateRecordSetLinked(SortField: String; SelField: String = '*'; Criterias: String = '');
var I, J: Integer;
    TableLinked, FieldShowed, FieldSaved, LastFieldLinked: String;
    BrowseAllFields: Boolean;
    Fields: TStrings;
    Fields4Linked, Join4Linked, SortFieldSQL, ShowedStr, OrderBySQL: String;
    TableAlias: Char;
    FieldShowedDummy, SplitStr, SortArray, CriteriasArray: StringArray;
    Separator, SplitDelim: String;
begin
  Fields4Linked:= '';
  Join4Linked:= '';
  Fields:= TStringList.Create;
  SelField:= Trim(SelField);
  if SelField = '*' then begin
    fINI.ReadSection(fTableInINI + '-F', Fields);
  end
  else begin
    Fields.CommaText:= SelField;
  end;
  TableAlias:= 'A';
  for I:= 0 to Fields.Count - 1 do begin
    if Not(FieldIsVirtual[Fields[I]]) then begin
      if FieldType[Fields[I]] = 'LN' then begin
        Separator:= GetFieldLinkedSeparator(Fields[I]);
        if Separator = '' then begin
          Separator:= ' ';
        end;
        FieldLinkedInfo(Fields[i], TableLinked, FieldShowed, FieldSaved, BrowseAllFields);
        SplitStr:= Split(FieldShowed, '.');
        FieldShowedDummy:= SplitStr;
        Inc(TableAlias);
        ShowedStr:= TableAlias + '.' + FieldShowedDummy[0] + '||' + QuotedStr(Separator) + '||';
        Join4Linked:= Join4Linked + ' left join ' + TableLinked + ' ' + TableAlias + ' on A.' + Fields[i] + ' = ' + TableAlias + '.' + FieldSaved;
        for J:= Low(SplitStr) to High(SplitStr) do begin
          if GetFieldType(TableLinked, SplitStr[J]) = 'LN' then begin
            Inc(TableAlias);
            LastFieldLinked:= SplitStr[J];
            FieldLinkedInfo(TableLinked, SplitStr[J], TableLinked, FieldShowed, FieldSaved, BrowseAllFields);
            Join4Linked:= Join4Linked + ' left join ' + TableLinked + ' ' + TableAlias + ' on ' + Chr(Ord(TableAlias)-1) + '.' + LastFieldLinked + ' = ' + TableAlias + '.' + FieldSaved;

            FieldShowedDummy:= Split(FieldShowed, '.');
            ShowedStr:= ShowedStr + TableAlias + '.' + FieldShowedDummy[0] + '||' + QuotedStr(Separator) + '||';
          end;
        end;
        Fields4Linked:= Fields4Linked + DeleteLastString(ShowedStr, '||' + QuotedStr(Separator) + '||') + ' AS ' + Fields[I] + '_Linked, '
      end;
      Fields4Linked:= Fields4Linked + 'A.' + Fields[I] + ', ';
    end;
  end;
  SortFieldSQL:= '';
  OrderBySQL:= '';

//  if Criterias = '' then begin
//    Criterias:= GenerateCriterias(SortField);
//
//    {for I:= 1 to SortField.Length do begin
//      if (SortField[I] = '>') or (SortField[I] = '=') or (SortField[I] = '<') or (SortField[I] = '!') then begin
//        Criterias:= Criterias + SortField[I];
//      end;
//    end;}
//  end;
//  CriteriasArray:= Split(Criterias, ',');
//
//  SortArray:= Split(SortField, ',');
//  for I:= 0 to High(SortArray) do begin
//    if OrderBySQL = '' then
//      OrderBySQL:= ' order by ';
//
//    SortField:= SortArray[I];
//    if CriteriasArray[I] <> '' then begin
//      SetLength(SplitStr, 2);
//      SplitStr[0]:= SortField;
//      for J:= 1 to SortField.Length do begin
//        if (SortField[J] = Criterias[1]) then begin
//          SetLength(SplitStr, 2);
//          SplitStr[0]:= Copy(SortField, 1, J - 1);
//          SplitStr[1]:= Copy(SortField, J + 1, Length(SortField));
//          SplitStr[1]:= FormatField4SQL(SplitStr[0], SplitStr[1]);
//
//          SplitDelim:= Criterias[1];
//          if SplitDelim = '!' then begin
//            SplitDelim:= '<>';
//          end;
//
//          Criterias:= Copy(Criterias, 2, Criterias.Length);
//        end;
//      end;
//      if SortFieldSQL = '' then
//        SortFieldSQL:= ' where ';
//
//      SortFieldSQL:= SortFieldSQL + 'A.' + SplitStr[0] + SplitDelim + SplitStr[1]  + ' and ';
//      OrderBySQL:= OrderBySQL + 'A.' + SplitStr[0] + ',';
//    end;
//
//
//    {FieldShowedDummy:= StringArrayAssign(['like', '!', '>=', '<=', '>', '<', '=']);
//    PosInArray(FieldShowedDummy, SplitStr[i], J);
//    if J > -1 then begin
//      FieldShowed:= DeleteStringAfterString(SplitStr[i], FieldShowedDummy[J]);
//      SplitStr[I]:= FieldShowed + FieldShowedDummy[J] + FormatField4SQL(FieldShowed,DeQuotedStr(Copy(SplitStr[I], Length(FieldShowed)+Length(FieldShowedDummy[J])+1, Length(SplitStr[I]))));
//      OrderBySQL:= OrderBySQL + 'A.' + FieldShowed + ',';
//
//      SplitStr[i]:= DeleteLastString(SplitStr[i], 'desc');
//
//      if SortFieldSQL = '' then
//        SortFieldSQL:= ' where ';
//      if (Pos('!', SplitStr[i]) > 0) or (Pos('=', SplitStr[i]) > 0) or (Pos('<', SplitStr[i]) > 0) or (Pos('>', SplitStr[i]) > 0) or (Pos('like', LowerCase(SplitStr[i])) > 0) then
//        SortFieldSQL:= SortFieldSQL + 'A.' + StringReplace(SplitStr[i], '!', '<>', [rfReplaceAll]) + ' and ';
//
//    end
//    else begin
//      OrderBySQL:= OrderBySQL + 'A.' + SplitStr[i] + ',';
//    end;}
//  end;

  MakeWhereFromSortField(SortField, Criterias, SortFieldSQL, OrderBySQL);

  SQL.Clear;
  SQL.Add('select ');
  SQL.Add(DeleteLastComma(Fields4Linked) + ', A.Deleted_Fld');
  SQL.Add(' from ' + FTable + ' A ');
  SQL.Add(DeleteLastComma(Join4Linked) + ' ');
  SQL.Add(DeleteLastString(SortFieldSQL, ' and '));
  OrderBySQL:= DeleteLastComma(OrderBySQL);
  if OrderBySQL <> '' then begin
    SQL.Add(' order by ' + OrderBySQL);
  end;

  ExecuteSQL;
  PutDataInArray;

  Fields.Free;
end;


function TRawFBAC.CreateRecordSetLinkedAndCount(SortField: String; SelField: String = '*'; Criterias: String = ''): Integer;
begin
  CreateRecordSetLinked(SortField, SelField, Criterias);
  Result:= Self.RecordCount;
end;

function TRawFBAC.DatabaseTables: StringArray;
var I: Integer;
    Tablas: TStringList;
    T: StringArray;
begin
  Tablas:= TStringList.Create;
  fINI.ReadSections(Tablas);
  SetLength(T, 0);
  for I:= 0 to Tablas.Count - 1 do begin
    if (Copy(Tablas[i], Length(Tablas[i]) - 1, 1) <> '-') and (UpperCase(Tablas[i]) <> 'GENERAL') then begin
      SetLength(T, Length(T) + 1);
      T[High(T)]:= Tablas[i];
    end;
  end;
  Result:= T;
  Tablas.Free;
end;

function TRawFBAC.DBFilename: String;
begin
  Result:= ReadStringAndResolve('General', 'Database', '');
end;

function TRawFBAC.DBHost: String;
begin
  Result:= ReadStringAndResolve('General', 'Host', 'localhost');
end;

function TRawFBAC.DBInfo(Params: String): String;
var ParamsArray: StringArray;
    I: Integer;
    ATable: TRawFBAC;
begin
  Result:= '';
  ParamsArray:= Split(Params, ',');
  for I:= 0 to High(ParamsArray) do begin
    if ParamsArray[I] = 'ActiveTransactions' then begin
      ATable:= TRawFBAC.CreateMemINI(fParent, '', fINI);
      ATable.ShowDeleted:= True;
      ATable.SQL.Text:= 'SELECT COUNT(*) AS TOTAL FROM MON$TRANSACTIONS';
      ATable.ExecuteSQL;
      Result:= Result + 'Active Transactions=' + IntToStr(StrToInt(ATable.fFBClient.Field['Total']) - 1) + ',';
      ATable.CommitTransaction;
      ATable.Free;
    end;
    if ParamsArray[I] = 'NextTransaction' then begin
      //Result:= Result + 'Next Transaction=' + IntToStr(DBArray[fDBIndex].DatabaseInfo.InfoNextTransaction) + ',';
    end;
    if ParamsArray[I] = 'Sweep' then begin
      //Result:= Result + 'Sweep=' + IntToStr(DBArray[fDBIndex].DatabaseInfo.InfoOldestSnapshot - DBArray[fDBIndex].DatabaseInfo.InfoOldestTransaction) + ',';
    end;
    if ParamsArray[I] = 'GC' then begin
      //Result:= Result + 'Garbage Collection=' + IntToStr(DBArray[fDBIndex].DatabaseInfo.InfoNextTransaction - DBArray[fDBIndex].DatabaseInfo.InfoOldestActive) + ',';
    end;
  end;
  Result:= DeleteLastComma(Result);
end;

function TRawFBAC.DBPort: String;
begin
  Result:= ReadStringAndResolve('General', 'Port', '3050');
end;

{function TRawFBAC.Default4Browse: String;
begin
  Result:= fINI.ReadString(fTable, 'Default4Browse' , '');
end;
}

procedure TRawFBAC.DeleteRecord;
var SQLDel: String;
begin
  //SQLDel:= 'delete from ' + FTable + ' where ' + UniqueField + ' = ' + fUKData;
  SQLDel:= 'update ' + fTable + ' set PRV_TIMESTAMP = ''Now'', Deleted_FLD = ''1'' where ' + GetUKWhere;
  SQL.Clear;
  SQL.Add(SQLDel);
  ExecuteSQL;
  CommitTransaction;
end;

procedure TRawFBAC.DeleteRecordFisically;
var SQLDel: String;
begin
  SQLDel:= 'delete from ' + FTable + ' where ' + GetUKWhere;
  SQL.Clear;
  SQL.Add(SQLDel);
  ExecuteSQL;
end;

procedure TRawFBAC.DeleteRecordSet(Where: String);
var WhereSQL, SplitDelim: String;
    WhereArray, SplitStr: StringArray;
    i: Integer;
begin
  WhereSQL:= '';
  WhereArray:= Split(Where, ',');
  for I:= 0 to High(WhereArray) do begin
    Where:= WhereArray[I];
    if (Pos('>', Where) > 0) or (Pos('=', Where) > 0) or (Pos('<', Where) > 0) then begin
      SplitStr:= SplitMulti(Where, '>=<', SplitDelim);
      if Trim(SplitStr[1]) <> '' then begin
        if WhereSQL = '' then
          WhereSQL:= ' where ' + SplitStr[0] + ' ' + SplitDelim + ' ' + QuotedStr(Trim(SplitStr[1]))
        else
          WhereSQL:= WhereSQL + ' and ' + SplitStr[0] + ' ' + SplitDelim + ' ' + QuotedStr(Trim(SplitStr[1]))

      end;
    end;
  end;

  SQL.Clear;
  SQL.Add('update ' + FTable + ' set PRV_TIMESTAMP = ''Now'', Deleted_Fld = ''1''' + WhereSQL);
  ExecuteSQL;
end;

destructor TRawFBAC.Destroy;
begin
  fINI.Free;
  fFBClient.Free;
  fFBClient2.Free;

  fDataValues.Free;
  fDataFields.Free;
  fFieldsChanged.Free;
  fVirtualValues.Free;
  fUKData.Free;
  fUKFields.Free;
  fDefaultValues.Free;
  SetLength(fVirtualFieldsEvents, 0);
  Dec(InstanceCount);

  if Assigned(fBrowserCtrlsRedirectorList) then begin
    fBrowserCtrlsRedirectorList.Free;
  end;

  inherited;
end;

procedure TRawFBAC.edtLinkChange(Sender: TObject);
var Str2Show, FieldName, TableLinked, FieldShowed, FieldSaved: String;
    BrowseAllFields: Boolean;
    DummyTable: TRawFBAC;
    DummyArray: StringArray;
    i: Integer;
begin
  FieldName:= Copy((Sender as TEdit).Name, 4, Length((Sender as TEdit).Name));
  Str2Show:= '';
  if Trim((Sender as TEdit).Text) <> '' then begin
    FieldLinkedInfo(FieldName, TableLinked, FieldShowed, FieldSaved, BrowseAllFields);
    DummyTable:= TRawFBAC.CreateMemINI(fParent, TableLinked, fINI);
    if DummyTable.CreateRecordSetLinkedAndCount(FieldSaved+'='+Trim((Sender as TEdit).Text), '*') > 0 then begin
      DummyArray:= Split(FieldShowed, '.');
      for I:= Low(DummyArray) to High(DummyArray) do begin
        Str2Show:= Str2Show + DummyTable.FieldLinked[DummyArray[I]] + GetFieldLinkedSeparator(FieldName);
      end;
      Str2Show:= DeleteLastString(Str2Show, GetFieldLinkedSeparator(FieldName));
    end;
    DummyTable.Free;
  end;
  (((Sender as TEdit).Parent as TForm).FindComponent('pnl' + MakeComponentName(FieldName)) as TPanel).Caption:= ' ' + Str2Show;

  CtrlChangeEnabler(Sender);
end;

procedure TRawFBAC.edtLinkExit(Sender: TObject);
var FieldName: String;
    FieldTitle: String;
begin
  FieldName:= Copy((Sender as TEdit).Name, 4, Length((Sender as TEdit).Name));
  FieldTitle:= (((Sender as TEdit).Parent as TForm).FindComponent('lbl' + MakeComponentName(FieldName)) as TLabel).Caption;
  if (Trim((((Sender as TEdit).Parent as TForm).FindComponent('pnl' + MakeComponentName(FieldName)) as TPanel).Caption) = '') and (Trim((Sender as TEdit).Text) <> '') then begin
    (Sender as TEdit).ShowBallonTip(TIconKind.Error, 'Error ingresando el dato ' + FieldTitle, 'El dato ingresado no existe en la tabla asociada');
    (Sender as TEdit).Text:= '';
  end;
end;

function TRawFBAC.Eof: Boolean;
begin
  Result:= fFBClient.Eof;
end;

procedure TRawFBAC.ExecuteSQL;
begin
  try
    if fFBClient.InTransaction then begin
      fFBClient.CommitTransaction;
    end;
    SQL.Text:= SQLAddDeleted0(SQL.Text);
    //Clipboard.AsText:= SQL.Text;
    fFBClient.StartTransaction;

    fFBClient.SQLExecute;
    fFBClient.FirstRecord;
  except
    Application.MessageBox(PChar('Exception: ' + SQL.Text), PChar(Application.Title), MB_OK + MB_ICONERROR);
  end;
  if fWaitInterval > 0 then begin
    Sleep(fWaitInterval);
  end;

  PutDataInArray;
  fRecordCount:= -1;
end;

function TRawFBAC.FieldHasEnabler(FieldName: String): String;
var Datos: StringArray;
    St: String;
begin
  St:= fINI.ReadString(fTableInINI + '-F', FieldName, '');
  Datos:= Split(St, ',');
  SetLength(Datos, 6);
  Result:= Datos[5];
  if (Result.StartsWith('{Enable:')) and (Result.EndsWith('}')) then begin
    Result:= Copy(Result, 9, Result.Length - 9);
  end;
end;

function TRawFBAC.FieldIsAloneInLine(FieldName: String): Boolean;
var A: StringArray;
    I: Integer;
begin
  Result:= False;
  A:= Split(fINI.ReadString(Table, 'FieldsAloneInLine', ''), ',');
  for I:= Low(A) to High(A) do begin
    if UpperCase(FieldName) = UpperCase(A[i]) then begin
      Result:= True;
      Break;
    end;
  end;
end;

function TRawFBAC.FieldIsCUIT(FieldName: String): Boolean;
var Datos: StringArray;
    St: String;
begin
  St:= fINI.ReadString(fTableInINI + '-F', FieldName, '');
  Datos:= Split(St, ',');
  SetLength(Datos, 4);
  Result:= UpperCase(Datos[3]) = 'CUIT';
end;

function TRawFBAC.FieldIsEdad(FieldName: String): Boolean;
var Datos: StringArray;
    St: String;
begin
  St:= fINI.ReadString(fTableInINI + '-F', FieldName, '');
  Datos:= Split(St, ',');
  SetLength(Datos, 4);
  Result:= UpperCase(Datos[3]) = 'EDAD';
end;

function TRawFBAC.FieldIsFile(FieldName: String): Boolean;
var Datos: StringArray;
    St: String;
begin
  St:= fINI.ReadString(fTableInINI + '-F', FieldName, '');
  Datos:= Split(St, ',');
  SetLength(Datos, 4);
  Result:= StringStartWith(UpperCase(Datos[3]), 'FILE:');
end;

function TRawFBAC.FieldIsFileFilter(FieldName: String): String;
var Datos: StringArray;
    St: String;
begin
  Result:= '';
  St:= fINI.ReadString(fTableInINI + '-F', FieldName, '');
  Datos:= Split(St, ',');
  SetLength(Datos, 4);
  if StringStartWith(UpperCase(Datos[3]), 'FILE:') then begin
    Datos:= Split(Datos[3], ':');
    SetLength(Datos, 2);
    Result:= Datos[1];
  end;
end;


function TRawFBAC.FieldIsNoType(FieldName: String): Boolean;
var Datos: StringArray;
    St: String;
begin
  St:= fINI.ReadString(fTableInINI + '-F', FieldName, '');
  Datos:= Split(St, ',');
  SetLength(Datos, 5);
  Result:= (Pos('{NOTYPE}', UpperCase(Datos[4])) > 0);
end;

function TRawFBAC.FieldIsNumeric(FieldName: String): Boolean;
begin
  Result:= FieldTypeIsNumeric(FieldType[FieldName]);
end;

function TRawFBAC.FieldTypeIsNumeric(FieldType: String): Boolean;
begin
  Result:= (FieldType = 'UK') or (FieldType = 'CU') or (FieldType = 'NU') or (FieldType = 'IN');
end;

procedure TRawFBAC.FieldLinkedInfo(ATable, FieldName: String; var TableLinked, FieldShowed, FieldSaved: String; var BrowseAllFields: Boolean);
var Datos: StringArray;
    DatosDummy: StringArray;
begin
  Datos:= Split(fINI.ReadString(ATable + '-F', FieldName, ''), ',');

  BrowseAllFields:= False;
  //if (High(Datos) = 3) and (GetFieldType(FieldName) = 'LN') then begin
  if (High(Datos) >= 3) and (Datos[1] = 'LN') then begin
    TableLinked:= Copy(Datos[3], 1, Pos(':', Datos[3])- 1);
    DatosDummy:= Split(Datos[3], '|');
    //FieldSaved:= Copy(DatosDummy[0], Pos(':', DatosDummy[0]) + 1, Pos('|', DatosDummy[0]) - (Pos(':', DatosDummy[0]) + 1));
    //FieldShowed:= Copy(Datos[3], Pos('|', Datos[3]) + 1, Length(Datos[3]));
    FieldSaved:= Copy(DatosDummy[0], Pos(':', DatosDummy[0]) + 1, Length(DatosDummy[0]));
    FieldShowed:= DatosDummy[1];
    if High(DatosDummy) >= 2 then
      BrowseAllFields:= DatosDummy[2] = '*';
  end
  else begin
    TableLinked:= '';
    FieldShowed:= '';
    FieldSaved:= '';
    BrowseAllFields:= True;
  end;
end;

procedure TRawFBAC.FieldLinkedInfo(FieldName: String; var TableLinked, FieldShowed, FieldSaved: String; var BrowseAllFields: Boolean);
begin
  FieldLinkedInfo(fTableInINI, FieldName, TableLinked, FieldShowed, FieldSaved, BrowseAllFields);
end;

function TRawFBAC.Fields4Browser: String;
begin
  Result:= ReadStringAndResolve(fTableInINI, 'Fields4Browser', '');
end;

function TRawFBAC.FieldUseComponent(CompType, FieldName: String): Boolean;
var FieldTypeSt: String;
begin
  FieldTypeSt:= FieldType[FieldName];
  Result:= False;
  if CompType = 'TLabel' then begin
    Result:= (StringCase(FieldTypeSt, ['UK','DA','TI','ST','LN','CU','NU','IN','LS','TS']) <> -1);
  end;
  if CompType = 'TEdit' then begin
    Result:= (StringCase(FieldTypeSt, ['DA','UK','TI','ST','LN','CU','NU','IN','TS']) <> -1);
  end;
  if CompType = 'TCheckBox' then begin
    Result:= (StringCase(FieldTypeSt, ['BO']) <> -1);
  end;
  if CompType = 'TComboBox' then begin
    Result:= (StringCase(FieldTypeSt, ['LS']) <> -1);
  end;
  if CompType = 'TButton' then begin
    Result:= (StringCase(FieldTypeSt, ['BT']) <> -1);
  end;
  {if CompType = 'TDateTimePicker' then begin
    Result:= (StringCase(FieldTypeSt, ['DA']) <> -1);
  end;}
end;

procedure TRawFBAC.FirstRecord;
begin
  fFBClient.FirstRecord;
end;

function TRawFBAC.GenerateCriterias(SortField: String): String;
var I, J, Idx: Integer;
    SortArray, DummyArray: StringArray;
    FieldRep: String;
begin
  Result:= '';

  SortArray:= Split(SortField, ',');
  for I:= Low(SortArray) to High(SortArray) do begin
    if SortArray[I].StartsWith('(') and SortArray[I].EndsWith(')') then begin
      if StrHasAnyOfArray(SortArray[I], Idx, CriteriasConst) then begin
        FieldRep:= Copy(SortArray[I], 2, Pos(CriteriasConst[Idx], SortArray[I]) - 2);
        DummyArray:= Split(Copy(SortArray[I], Pos(CriteriasConst[Idx], SortArray[I]) + Length(CriteriasConst[Idx])), '|');
        for J:= Low(DummyArray) to High(DummyArray) do begin
          DummyArray[J]:= CriteriasConst[Idx];
        end;
        Result:= Result + ArrayToString(DummyArray, ',', False);
      end;
    end
    else begin
      if StrHasAnyOfArray(SortArray[I], Idx, CriteriasConst) then begin
        Result:= Result + CriteriasConst[Idx];
      end;
    end;
    Result:= Result + ',';
  end;
  Result:= DeleteLastComma(Result);
end;

function TRawFBAC.GenerateExpressionForCalculatedField(Expression: String): String;
var I: Integer;
const ValidOperators = ['+', '-', '*', '/', '^', '\'];
begin
  for I:= 1 to Expression.Length do begin
    if Expression[I] in ValidOperators then begin
      Result:= Result + ' ' + Expression[I] + ' ';
    end
    else begin
      Result:= Result + Expression[I];
    end;
  end;
end;

function TRawFBAC.GeneratorNextValue: Integer;
begin
  fFBClient2.SQL.Text:= 'SELECT GEN_ID(' + GetTableGenerator + ', 0) FROM RDB$DATABASE';
  fFBClient2.SQLExecute;
  Result:= StrToInt(fFBClient2.Field['GEN_ID']) + fGeneratorIncrement;
  fFBClient2.RollBackTransaction;
end;

function TRawFBAC.GetAllowDeadLinks: Boolean;
begin
  Result:= fINI.ReadString(fTableInINI, 'General', 'AllowDeadLinks') = '1';
end;

function TRawFBAC.GetCalculatedField(FieldName: String): Extended;
  function ExpressionIsField(Expression: String): Boolean;
  begin
    if Expression.Length > 0 then begin
      Result:= (Expression.StartsWith('''')) and (Expression.EndsWith(''''));
      Result:= Result or (Expression[1] in ['a'..'z', 'A'..'Z']);
    end
    else begin
      Result:= False;
    end;
  end;

  function ResolveArray(TotalExpression: StringArray): String;
  var Op1, Op2: Extended;
  begin
    if (Length(TotalExpression) = 3) and (TotalExpression[0] <> '') and (TotalExpression[2] <> '') then begin
      if ExpressionIsField(TotalExpression[0]) then begin
        Op1:= ExtractCurrencyValueEx2Ext(Field[TotalExpression[0]]);
      end
      else begin
        Op1:= ExtractCurrencyValueEx2Ext(TotalExpression[0]);
      end;

      if ExpressionIsField(TotalExpression[2]) then begin
        Op2:= ExtractCurrencyValueEx2Ext(Field[TotalExpression[2]]);
      end
      else begin
        Op2:= ExtractCurrencyValueEx2Ext(TotalExpression[2]);
      end;

      if TotalExpression[1] = '+' then begin
        Result:= IncludeCurrencyValueEx(Op1 + Op2);
      end
      else begin
        if TotalExpression[1] = '-' then begin
          Result:= IncludeCurrencyValueEx(Op1 - Op2);
        end
        else begin
          if TotalExpression[1] = '*' then begin
            Result:= IncludeCurrencyValueEx(Op1 * Op2);
          end
          else begin
            if TotalExpression[1] = '/' then begin
              Result:= IncludeCurrencyValueEx(Op1 / Op2);
            end;
          end;
        end;
      end;
    end
    else begin
      if Length(TotalExpression) = 3 then begin
        Result:= TotalExpression[1];
      end
      else begin
        Result:= '';
      end;
    end;
  end;

var I, J, Idx, StartThisExp: Integer;
    Expression, Op1, Op2: String;
    ExpressionArray, TotalExpression: StringArray;
    InParenthesis: Boolean;
begin
  Result:= 0;
  for I:= Low(fCalculatedField) to High(fCalculatedField) do begin
    if fCalculatedField[I].FieldName = UpperCase(FieldName) then begin
      Expression:= fCalculatedField[I].Expression;
      SetLength(ExpressionArray, 0);
      Idx:= -1;
      InParenthesis:= False;
      StartThisExp:= 1;
      for J:= 1 to Expression.Length do begin
        if Expression[J] = '(' then begin
          if J > 1 then begin
            SetLength(ExpressionArray, Length(ExpressionArray) + 1);
            Idx:= High(ExpressionArray);
            ExpressionArray[Idx]:= Copy(Expression, StartThisExp, J - StartThisExp);
          end;
          InParenthesis:= True;
          StartThisExp:= J + 1;
        end
        else begin
          if Expression[J] = ')' then begin
            InParenthesis:= False;
            SetLength(ExpressionArray, Length(ExpressionArray) + 1);
            Idx:= High(ExpressionArray);
            ExpressionArray[Idx]:= Copy(Expression, StartThisExp, J - StartThisExp);
            StartThisExp:= J + 1;
          end
        end;
      end;

      if Copy(Expression, StartThisExp, J - StartThisExp) <> '' then begin
        SetLength(ExpressionArray, Length(ExpressionArray) + 1);
        Idx:= High(ExpressionArray);
        ExpressionArray[Idx]:= Copy(Expression, StartThisExp, J - StartThisExp);
      end;

      for J := Low(ExpressionArray) to High(ExpressionArray) do begin
        TotalExpression:= Split(ExpressionArray[J], ' ');
        ExpressionArray[J]:= ResolveArray(TotalExpression);
      end;
      J:= 0;
      while (Length(ExpressionArray) >= 3) do begin
        ExpressionArray[0]:= ResolveArray(Copy(ExpressionArray, 0, 3));
        for Idx:= 2 to High(ExpressionArray) do begin
          ExpressionArray[Idx - 1]:= ExpressionArray[Idx];
        end;
        SetLength(ExpressionArray, Length(ExpressionArray) - 1);
      end;
      Result:= ExtractCurrencyValueEx2Ext(ExpressionArray[0]);
      Break;
    end;
  end;
end;

function TRawFBAC.GetClientLibrary: String;
begin
  Result:= ReadStringAndResolve('General', 'ClientLibrary', '');
end;

function TRawFBAC.GetConnected: Boolean;
begin
  Result:= fFBClient.Connected;
end;

function TRawFBAC.GetDataTypeFromFDB(FieldName: String): String;
var TheSQL: String;
begin
  Result:= '';
  TheSQL:= 'SELECT r.RDB$FIELD_NAME, f.RDB$FIELD_LENGTH, f.RDB$FIELD_PRECISION, f.RDB$FIELD_SCALE, f.RDB$FIELD_TYPE FROM RDB$RELATION_FIELDS r ' +
           'LEFT JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME WHERE r.RDB$RELATION_NAME = ' + QuotedStr(UpperCase(fTable)) + ' and r.RDB$FIELD_NAME = ' + QuotedStr(UpperCase(FieldName));
  fFBClient2.SQL.Text:= TheSQL;
  fFBClient2.SQLExecute;
  fFBClient2.FirstRecord;
  if Not(fFBClient2.Eof) then begin
    //Result:= Trim(Query2.Fields.ByNameAsString['RDB$FIELD_TYPE']);
    case StrToInt(fFBClient2.Field['RDB$FIELD_TYPE']) of
      8 : Result:= 'Integer' + Iif(UpperCase(UniqueField) = UpperCase(FieldName), ' NOT NULL', '');
      12: Result:= 'Date';
      14: Result:= 'Char(' + fFBClient2.Field['RDB$FIELD_LENGTH'] + ')';
      7,16: Result:= 'Numeric(' + IntToStr(StrToInt(fFBClient2.Field['RDB$FIELD_PRECISION'])) + ',' + IntToStr(StrToInt(fFBClient2.Field['RDB$FIELD_PRECISION']) - StrToInt(fFBClient2.Field['RDB$FIELD_LENGTH'])) + ')';
      35: Result:= 'Timestamp';
      37: Result:= 'Varchar(' + fFBClient2.Field['RDB$FIELD_LENGTH'] + ') CHARACTER SET ISO8859_1 COLLATE ES_ES_CI_AI';
     261: Result:= 'Blob sub_type 0';
    end;
  end;
  fFBClient2.CommitTransaction;
end;

function TRawFBAC.GetField(FieldName: String): String;
var I: Integer;
begin
  Result:= '';
  i:= fDataFields.IndexOf(FieldName);
  if (I > -1) then begin
    if FieldType[FieldName] = 'BL' then begin
      Result:= GetFieldBlob(FieldName, GetSafeFilename(GetTempDirectory, fTable + '-' + FieldName + '-' + Field[GetUniqueField] + fFileExtensionForBLOBFields));
    end
    else begin
      if (FieldType[FieldName] = 'TS') and (fDataValues[i] <> '') and (LowerCase(fDataValues[i]) <> 'now') then begin
        Result:= FormatDateTime(fTimeStampFormat, StrToDateTimeMillisecond(fDataValues[i]));
      end
      else begin
        Result:= fDataValues[i];
        if (FieldTypeIsNumeric(FieldType[FieldName]) or (FieldType[FieldName] = 'BO')) and (Trim(Result) = '') then begin
          Result:= '0';
        end;
      end;
    end;
  end
  else begin
    if (UpperCase(FieldName) = 'PRV_TIMESTAMP') or (FieldType[FieldName] = 'TS') then begin
      //Result:= FormatDateTime('dd.mm.yyyy, HH:mm:ss', fFBClient.Field[FieldName]);
      Result:= FormatDateTime(fTimeStampFormat, StrToDateTimeMillisecond(fFBClient.Field[FieldName]));
    end
    else begin
      Result:= fFBClient.Field[FieldName];
    end;
  end;
end;

function TRawFBAC.GetFieldBlob(FieldName, FileName: String): String;
var AStream: TMemoryStream;
begin
  Result:= '';
  if FieldType[FieldName] = 'BL' then begin
    AStream:= TMemoryStream.Create;
    fFBClient.BlobField(FieldName, AStream);

    AStream.SaveToFile(FileName);
    AStream.Free;

    Result:= FileName;
  end;
end;

function TRawFBAC.GetFieldCompWidth(FieldName: String): Integer;
var FieldTypeSt: String;
begin
  FieldTypeSt:= FieldType[FieldName];
  Result:= 0;
  if FieldUseComponent('TEdit', FieldName) then begin
    if (FieldTypeSt = 'IN') or (FieldTypeSt = 'UK') or (FieldTypeSt = 'NU') or (FieldTypeSt = 'CU') then begin
      Result:= 65;
    end else begin
      if FieldTypeSt = 'LN' then begin
        Result:= 40;
      end else begin
        if (FieldTypeSt = 'TS') then begin
          Result:= 140;
        end
        else begin
          if (FieldTypeSt = 'DA') then begin
            Result:= 100;
          end
          else begin
            Result:= 60 + (StrToInt(FieldWidth[FieldName]) * 4);
            if Result > 600 then
              Result:= 600;
          end;
        end;
      end;
    end;
  end;
  if FieldUseComponent('TComboBox', FieldName) then begin
    Result:= 145;
  end;
  if FieldUseComponent('TDateTimePicker', FieldName) then begin
    Result:= 85;
  end;
end;

function TRawFBAC.GetFieldCount: Integer;
var St: TStringList;
begin
  St:= TStringList.Create;
  fINI.ReadSection(fTableInINI + '-F', St);
  Result:= St.Count;
  St.Free;
end;

function TRawFBAC.GetFieldFormat(FieldName: String): String;
var St: StringArray;
begin
  St:= Split(fINI.ReadString(fTableInINI + '-F', FieldName, ''), ',');
  SetLength(St, 5);
  if (St[3].StartsWith('{Format:')) and (St[3].EndsWith('}')) then begin
    Result:= Copy(St[3], 9, Length(St[3]) - 9);
  end;
end;

function TRawFBAC.GetFieldIndex(FieldName: String): Integer;
begin
  Result:= fDataFields.IndexOf(UpperCase(FieldName));
end;

function TRawFBAC.GetFieldIndexInQuery(Qry: TRawFB; FieldName: String): Integer;
begin
  Result:= Qry.FieldNumberByName[FieldName];
end;

function TRawFBAC.GetFieldIsIndexed(FieldName: String): Boolean;
var St: StringArray;
begin
  St:= Split(UpperCase(fINI.ReadString(fTableInINI, 'Indices', '')), ',');
  Result:= Indice(UpperCase(FieldName), St) <> -1;
end;

function TRawFBAC.GetFieldIsSharedIndexed(FieldName: String): Boolean;
var St, St2: StringArray;
    I, J: Integer;
begin
  Result:= False;
  St:= Split(UpperCase(fINI.ReadString(fTableInINI, 'Indices', '')), ',');
  for I:= Low(St) to High(St) do begin
    St2:= Split(St[i], '|');
    if High(St2) > 0 then begin
      for J:= Low(St2) to High(St) do begin
        Result:= Indice(UpperCase(FieldName), St2) <> -1;
      end;
    end;
  end;
end;

function TRawFBAC.GetFieldIsVirtual(FieldName: String): Boolean;
var St: StringArray;
begin
  St:= Split(fINI.ReadString(fTableInINI + '-F', FieldName, ''), ',');
  SetLength(St, 5);
  Result:= UpperCase(St[4]) = 'VF';
end;

function TRawFBAC.GetFieldIsVisible(FieldName: String): Boolean;
var St: StringArray;
begin
  St:= Split(fINI.ReadString(fTableInINI + '-F', FieldName, ''), ',');
  SetLength(St, 5);
  Result:= UpperCase(St[4]) <> 'I';
end;

function TRawFBAC.GetFieldLinked(FieldName: String): String;
var TableLinked, FieldShowed, FieldSaved: String;
    BrowseAllFields: Boolean;
begin
  Result:= '';
  if FieldName.StartsWith('AddCol') then begin
    FieldShowed:= Copy(FieldName, 7, 255);
    Result:= fColumnAddedEvents[StrToInt(FieldShowed)](fParent, Self, fColumnAddedNames[StrToInt(FieldShowed)]);
  end
  else begin
    if GetFieldType(FieldName) = 'LN' then begin
      if fFBClient.FieldNumberByName[FieldName + '_Linked'] > -1 then begin
        Result:= fFBClient.Field[FieldName + '_Linked'];
      end
      else begin
        FieldLinkedInfo(FieldName, TableLinked, FieldShowed, FieldSaved, BrowseAllFields);
        if fFBClient2.InTransaction then
          fFBClient2.CommitTransaction;

        if Pos('.',FieldShowed) > 0 then begin
          FieldShowed:= Copy(FieldShowed, 1, Pos('.',FieldShowed) - 1);
        end;

        if GetField(FieldName) <> '' then begin
          fFBClient2.SQL.Text:= 'select ' + FieldShowed + ' from ' + TableLinked + ' where ' + FieldSaved + ' = ' + QuotedStr(GetField(FieldName));
          fFBClient2.SQLExecute;
          if fFBClient2.RecordSetCount > 0 then begin
            Result:= fFBClient2.Field[FieldShowed];
          end
          else begin
            GetField(FieldName);
          end;
        end
        else begin
          Result:= '';
        end;
      end;
    end
    else begin
      if GetFieldType(FieldName) = 'LS' then begin
        Result:= GetLSLinkValue(FieldName, GetField(FieldName));
      end
      else begin
        if GetFieldType(FieldName) = 'BO' then begin
          Result:= Iif(GetField(FieldName) = '1', 'Sí', 'No');
        end
        else begin
          if FieldFormat[FieldName] = '' then begin
            Result:= GetField(FieldName)
          end
          else begin
            Result:= Format(FieldFormat[FieldName], [StrToIntDef(GetField(FieldName), 0)]);
          end;
        end;
      end;
    end;
  end;
end;

function TRawFBAC.GetFieldLinkedSeparator(FieldName: String): String;
var Dummy, SA: StringArray;
    I: Integer;
begin
  SA:= Split(fINI.ReadString(fTableInINI + '-F', FieldName, ''), ',');
  SetLength(SA, 5);
  Result:= '';
  Dummy:= Split(SA[4], ' ');
  for I:= Low(Dummy) to High(Dummy) do begin
    Result:= Result + Chr(ValInt(Dummy[i]));
  end;
end;

function TRawFBAC.GetFieldNameByNumber(I: Integer): String;
var St: TStringList;
begin
  St:= TStringList.Create;
  fINI.ReadSection(fTableInINI + '-F', St);
  Result:= St.Strings[I];
  St.Free;
end;

function TRawFBAC.GetFieldsArray: StringArray;
var St: TStringList;
    I: Integer;
begin
  St:= TStringList.Create;
  fINI.ReadSection(fTableInINI + '-F', St);
  SetLength(Result, St.Count);
  for I:= 0 to St.Count - 1 do begin
    Result[i]:= St[i];
  end;
  St.Free;
end;

function TRawFBAC.GetFieldsNoDuplicate: StringArray;
var St: String;
begin
  St:= fINI.ReadString(FTableInINI, 'NoDuplicate', '');
  if St = '*' then begin
    Result:= GetFieldsArray;
  end
  else begin
    Result:= Split(St, ',');
  end;
end;

function TRawFBAC.GetFieldsNotNull: StringArray;
var St: String;
begin
  St:= fINI.ReadString(FTableInINI, 'FieldsNotNull', '');
  if St = '*' then begin
    Result:= GetFieldsArray;
  end
  else begin
    Result:= Split(St, ',');
  end;
end;

function TRawFBAC.GetFieldSQLType(FieldName: String): String;
var Charset: String;
begin
  CharSet:= ') CHARACTER SET ISO8859_1 COLLATE ES_ES_CI_AI';

  case StringCase(GetFieldType(FieldName), ['ST','UK','CU','DA','TI','BO','NU','LS','IN', 'LN','TS', 'BL']) of
    0,7: Result:= 'Varchar(' + GetFieldWidth(FieldName) + CharSet;
    1,9: Result:= 'Integer NOT NULL';
    2: Result:= 'Numeric(10,2)';
    3: Result:= 'Date';
    4: Result:= 'Char(5)';
    5: Result:= 'Char(1)';
    6: Result:= 'Numeric(' + ReplaceString(GetFieldWidth(FieldName), '.', ',') + ')';
    8: Result:= 'Integer';
   10: Result:= 'Timestamp';
   11: Result:= 'Blob sub_type 0';
  end;
  if GetFieldType(FieldName) = 'LN' then
    Result:= StringReplace(Result, ' NOT NULL', '', [rfReplaceAll]);
end;

function TRawFBAC.GetFieldTitle(FieldName: String): String;
var St: String;
    A: StringArray;
begin
  St:= fINI.ReadString(FTableInINI + '-F', FieldName, '');
  A:= Split(St, ',');
  if Length(A) >= 1 then
    Result:= A[0]
  else
    Result:= '';
end;

function TRawFBAC.GetFieldType(TableName, FieldName: String): String;
var St: String;
    A: StringArray;
begin
  if FieldName = 'PRV_TIMESTAMP' then begin
    Result:= 'TS';
  end
  else begin
    St:= fINI.ReadString(TableName + '-F', FieldName, '');
    A:= Split(St, ',');
    SetLength(A, 2);
    Result:= A[1];
  end;
end;

function TRawFBAC.GetFieldTypeTitle(FieldName: String): String;
var AStr: String;
begin
  AStr:= FieldType[FieldName];
  if AStr = 'UK' then
    Result:= 'Unique Key'
  else
    if AStr = 'DA' then
      Result:= 'Date'
    else
      if AStr = 'TI' then
        Result:= 'Time'
      else
        if AStr = 'ST' then
          Result:= 'String'
        else
          if AStr = 'LN' then
            Result:= 'Link'
          else
            if AStr = 'CU' then
              Result:= 'Currency'
            else
              if AStr = 'NU' then
                Result:= 'Numeric'
              else
                if AStr = 'IN' then
                  Result:= 'Integer'
                else
                  if AStr = 'BO' then
                    Result:= 'Boolean'
                  else
                    if AStr = 'LS' then
                      Result:= 'List'
                    else
                      if AStr = 'TS' then
                        Result:= 'TimeStamp'
                      else
                        if AStr = 'BL' then
                          Result:= 'BLOB';

end;

function TRawFBAC.GetFieldType(FieldName: String): String;
begin
  Result:= GetFieldType(fTableInINI, FieldName);
end;

function TRawFBAC.GetFieldWidth(FieldName: String): String;
var St: String;
    StA: StringArray;
begin
  St:= fINI.ReadString(fTableInINI + '-F', FieldName, '');
  StA:= Split(St, ',');
  SetLength(StA, 3);
  Result:= StA[2];
  if Result = '' then
    Result:= '0';
end;

function TRawFBAC.GetGeneratorValue(GeneratorName: String): Integer;
begin
  try
    fFBClient2.SQL.Text:= 'SELECT GEN_ID(' + GeneratorName + ', 0) AS GEN FROM RDB$DATABASE';
    fFBClient2.SQLExecute;
    Result:= StrToInt(fFBClient2.Field['GEN']);
  except
    Result:= 0;
  end;
end;

function TRawFBAC.GetGridColWidth(FieldName: String): Integer;
var R: Integer;
begin
  if FieldIsNumeric(FieldName) then begin
    R:= 80;
  end
  else begin
    R:= 240;
  end;
  Result:= R;
end;

function TRawFBAC.GetINIFilename: String;
begin
  Result:= fINI.FileName;
end;

function TRawFBAC.GetLSLinkValue(FieldName, Value: String): String;
var Datos: StringArray;
    DummyStr: StringArray;
    i: Integer;
begin
  Datos:= Split(fINI.ReadString(Table + '-F', FieldName, ''), ',');
  SetLength(Datos, 5);
  if Datos[3].StartsWith('{"') and Datos[3].EndsWith('"}') then begin
    DummyStr:= Split(Copy(Datos[3], 3, Datos[3].Length - 4), ':');
    Datos[3]:= fINI.ReadString(DummyStr[0], DummyStr[1], '');
  end;

  Datos:= Split(ResolveString(Datos[3]), '|');

  i:= 0;
  Result:= '';
  while i < High(Datos) do begin
    if Trim(Datos[i]) = Trim(Value) then begin
      Result:= Datos[i + 1];
      Exit;
    end;
    i:= i + 2;
  end;

end;

function TRawFBAC.GetRecordIsDeleted: Boolean;
begin
  Result:= fFBClient.Field['Deleted_Fld'] = '1';
end;

function TRawFBAC.GetSQL: TStrings;
begin
  Result:= fFBClient.SQL;
end;

function TRawFBAC.GetTable: String;
begin
  Result:= fTable;
  if fTableInINI <> fTable then begin
    Result:= Result + ' as ' + fTableInINI;
  end;
end;

function TRawFBAC.GetTableGenerator: String;
begin
  Result:= fINI.ReadString(fTableInINI, 'Generator', '');
  if fTable <> fTableInINI then begin
    Result:= UpperCase(fTable) + '_' + UpperCase(GetUniqueField) + '_GEN';
  end;
end;

function TRawFBAC.GetTableIndices: String;
begin
  Result:= fINI.ReadString(fTableInINI, 'Indices', '');
end;

function TRawFBAC.GetTableTitle: String;
begin
  Result:= fINI.ReadString(fTable, 'Title', fTable);
end;

function TRawFBAC.GetUKWhere: String;
var I: Integer;
    St: String;
begin
  St:= '';
  for I:= 0 to fUKFields.Count - 1 do begin
    St:= St + fUKFields[I] + ' = ' + QuotedStr(fUKData[I]) + ' and ';
  end;
  St:= DeleteLastString(St, ' and ');
  Result:= St;
end;

function TRawFBAC.GetUniqueField: String;
var I: Integer;
begin
  Result:= '';
  for I:= 0 to fDataFields.Count - 1 do begin
    if FieldType[fDataFields[I]] = 'UK' then begin
      Result:= fDataFields[I];
      Break;
    end;
  end;
end;

function TRawFBAC.GetValueOfAddedColumn(ColumnName: String): String;
var I: Integer;
begin
  // AddColumn(ColumnName, ColumnCaption: String; Alignment: TAlignment; EventName: TAddedColumnEvent);
  Result:= '';
  for I:= Low(fColumnAddedNames) to High(fColumnAddedNames) do begin
    if fColumnAddedNames[I] = ColumnName then begin
      Result:= fColumnAddedEvents[I](Self, Self, ColumnName);
    end;
  end;
end;

function TRawFBAC.GetValueOfAnotherTable(Table, Field, SortField: String): String;
var ATable: TRawFBAC;
begin
  ATable:= TRawFBAC.CreateMemINI(Self.Parent, Table, fINI);
  if ATable.CreateRecordSetAndCount(SortField, '*') > 0 then begin
    Result:= ATable.Field[Field];
  end
  else begin
    Result:= '';
  end;
  ATable.Free;
end;

function TRawFBAC.GetVirtualValue(FieldName: String): String;
var i, FieldLength: Integer;
    FldsVals: StringArray;
    FieldUpper: String;
begin
  Result:= '';
  if fVirtualValuesIndex > -1 then begin
    FieldUpper:= UpperCase(FieldName) + '=';
    FieldLength:= FieldName.Length;
    FldsVals:= Split(fVirtualValues[fVirtualValuesIndex], '|');
    for I:= Low(FldsVals) to High(FldsVals) do begin
      if SameStr(FieldUpper, UpperCase(Copy(FldsVals[i], 1, FieldLength)) + '=') then begin
        Result:= Copy(FldsVals[i], FieldLength+2, Length(FldsVals[i]));
        Break;
      end;
    end;
  end
end;

function TRawFBAC.GetWaitInterval: Integer;
begin
  Result:= fWaitInterval;
end;

procedure TRawFBAC.IncludeTableInINI(FirebirdInstance: TRawFBAC; ATable: String);
var I: Integer;
    SL: TStringList;
begin
  SL:= TStringList.Create;
  SL.Clear;
  FirebirdInstance.fINI.ReadSection(ATable, SL);
  SL.Insert(0, '[' + ATable + ']');
  for I:= 1 to SL.Count - 1 do begin
    SL[I]:= SL[I] + '=' + FirebirdInstance.fINI.ReadString(ATable, SL[I], '');
  end;
  Self.AddInfoToINI(SL);

  SL.Clear;
  FirebirdInstance.fINI.ReadSection(ATable + '-F', SL);
  SL.Insert(0, '[' + ATable + '-F]');
  for I:= 1 to SL.Count - 1 do begin
    SL[I]:= SL[I] + '=' + FirebirdInstance.fINI.ReadString(ATable + '-F', SL[I], '');
  end;
  Self.AddInfoToINI(SL);

  SL.Free;
end;

procedure TRawFBAC.InitRecord;
var I, Idx: Integer;
begin
  for I:= 0 to fDataValues.Count - 1 do begin
    Idx:= IndexPartOf(fDefaultValues, fDataFields[i] + '=');
    if Idx <> -1 then
      fDataValues[I]:= Copy(fDefaultValues.Strings[Idx], Pos('=', fDefaultValues.Strings[Idx]) + 1, fDefaultValues.Strings[Idx].Length)
    else
      fDataValues[I]:= '';
  end;
end;

procedure TRawFBAC.InsertRecord;
var SQLIns, Valores, Blobs: String;
    I: Integer;
    BlobArray: StringArray;
    AStream: TFileStream;
begin
  Blobs:= '';
  SQLIns:= 'insert into ' + fTable + ' (PRV_TIMESTAMP, ';
  Valores:= ' values (''Now'',';
  for I:= 0 to fDataFields.Count - 1 do begin
    SQLIns:= SQLIns + fDataFields[i] + ',';
    if (FieldType[fDataFields[i]] = 'UK') then begin
      //Valores:= Valores + 'next value for ' + TableGenerator + ',';
      Valores:= Valores + 'GEN_ID(' + TableGenerator + ', ' + IntToStr(fGeneratorIncrement) + '),';
    end
    else begin
      if (FieldType[fDataFields[i]] = 'BL') then begin
        Valores:= Valores + ':Blob' + fDataFields[i] + ',';
        Blobs:= Blobs + fDataFields[i] + ',';
      end
      else begin
        Valores:= Valores + FormatField4SQL(fDataFields[i], fDataValues[i]) + ',';
      end;
    end;
  end;
  SQLIns[Length(SQLIns)]:= ')';
  Valores[Length(Valores)]:= ')';

  if fFBClient2.InTransaction then
    fFBClient2.CommitTransaction;

  fFBClient2.StartTransaction;

  fFBClient2.SQL.Clear;
  fFBClient2.SQL.Add(SQLIns);
  fFBClient2.SQL.Add(Valores);
  fFBClient2.SQL.Add(' returning ');
  Valores:= '';
  for I:= 0 to fUKFields.Count - 1 do begin
    Valores:= Valores + fUKFields.Strings[i] + ',';
  end;
  fFBClient2.SQL.Add(DeleteLastComma(Valores) + ';');

  // BLOBs
  fFBClient2.Params.Clear;
  BlobArray:= Split(Blobs, ',');
  for I:= Low(BlobArray) to High(BlobArray) do begin
    if BlobArray[i] <> '' then begin
      AStream:= TFileStream.Create(fDataValues[fDataFields.IndexOf(BlobArray[i])], 0);
      fFBClient2.Params.SetStreamByName('blob'+BlobArray[i], AStream);
      //AStream.Free;
    end;
  end;
  fFBClient2.SQLExecute;

  //Query2.Transaction.CommitRetaining;
  fFBClient2.CommitTransaction;

  for I:= 0 to fUKFields.Count - 1 do begin
    //fUKData.Strings[i]:= Trim(Query2.Fields.FieldByName(fUKFields.Strings[i]).AsString);
    fUKData.Strings[i]:= Trim(fFBClient2.Field[fUKFields.Strings[i]]);
    Field[fUKFields.Strings[i]]:= fUKData.Strings[i];
  end;
  fFBClient2.Params.Clear;
end;

procedure TRawFBAC.InsertRecordNoNextValue;
var SQLIns, Valores: String;
    I: Integer;
begin
  SQLIns:= 'insert into ' + fTable + ' (';
  Valores:= ' values (';
  for I:= 0 to fDataFields.Count - 1 do begin
    SQLIns:= SQLIns + fDataFields[i] + ',';
    Valores:= Valores + FormatField4SQL(fDataFields[i], fDataValues[i]) + ',';
  end;
  SQLIns[Length(SQLIns)]:= ')';
  Valores[Length(Valores)]:= ')';

  fFBClient2.SQL.Clear;
  fFBClient2.SQL.Add(SQLIns);
  fFBClient2.SQL.Add(Valores);
  fFBClient2.SQL.Add(' returning ');
  Valores:= '';
  for I:= 0 to fUKFields.Count - 1 do begin
    Valores:= Valores + fUKFields.Strings[i] + ',';
  end;
  fFBClient2.SQL.Add(DeleteLastComma(Valores) + ';');

  if fFBClient2.InTransaction then
    fFBClient2.CommitTransaction;

  fFBClient2.StartTransaction;

  fFBClient2.SQLExecute;
  //Query2.Transaction.CommitRetaining;
  fFBClient2.CommitTransaction;

  for I:= 0 to fUKFields.Count - 1 do begin
    fUKData.Strings[i]:= Trim(fFBClient2.Field[fUKFields.Strings[i]]);
  end;
end;

procedure TRawFBAC.LastRecord;
begin
  fFBClient.LastRecord;
  PutDataInArray;
end;

function TRawFBAC.LinkedStr(AStr, AValue: String): String;
var AStrArr: StringArray;
    I: Integer;
begin
  Result:= '';
  AStrArr:= Split(AStr, '|');
  I:= 0;
  while I < High(AStrArr) do begin
    if AValue = AStrArr[I] then begin
      Result:= AStrArr[I + 1];
      Exit;
    end;
    Inc(I, 2);
  end;
end;

function TRawFBAC.LSItemIndexFromData(Value: String; Combo: TComboBox): Integer;
var I: Integer;
begin
  Result:= -1;
  for I:= 0 to Combo.Items.Count - 1 do begin
    try
      //if Value = TString(Combo.Items.Objects[I]).Str then begin
      if Value = Combo.Items.StoredStr(I) then begin
        Result:= I;
        Exit;
      end;
    except

    end;
  end;
end;

function TRawFBAC.LSValueFromComboBox(FieldName: String; Combo: TComboBox): String;
begin
  if Combo.ItemIndex > -1 then begin
    Result:= Combo.Items.StoredStr(Combo.ItemIndex);
  end
  else begin
    Result:= '';
  end;
end;

procedure TRawFBAC.MakeWhereFromSortField(SortField, Criterias: String; out Where, OrderBy: String);
var SortFieldSQL, OrderBySQL, SplitDelim: String;
    SortArray, DummyArray, SplitStr, CriteriasArray: StringArray;
    I, J, Idx, Count: Integer;
    FieldRep, BoolSep: String;
begin
  SortArray:= Split(SortField, ',');
  for I:= Low(SortArray) to High(SortArray) do begin
    if SortArray[I].StartsWith('(') and SortArray[I].EndsWith(')') then begin
      if StrHasAnyOfArray(SortArray[I], Idx, CriteriasConst) then begin
        FieldRep:= Copy(SortArray[I], 2, Pos(CriteriasConst[Idx], SortArray[I]) - 2);
        DummyArray:= Split(Copy(SortArray[I], Pos(CriteriasConst[Idx], SortArray[I]) + Length(CriteriasConst[Idx])), '|');
        BoolSep:= Copy(DummyArray[0], 1, Pos(':', DummyArray[0]) - 1);
        DummyArray[0]:= Copy(DummyArray[0], Pos(':', DummyArray[0]) + 1);
        DummyArray[High(DummyArray)]:= Copy(DummyArray[High(DummyArray)], 1, Length(DummyArray[High(DummyArray)]) - 1);

        for J:= Low(DummyArray) to High(DummyArray) do begin
          DummyArray[J]:= 'A.' + FieldRep + CriteriasConst[Idx] + QuotedStr(DummyArray[J]);
          if SortArray[I].StartsWith('(') then begin
            DummyArray[J]:= '(' + DummyArray[J];
          end;
          if SortArray[I].EndsWith(')') then begin
            DummyArray[J]:= DummyArray[J] + ')';
          end;
        end;
        SortArray[I]:= ArrayToString(DummyArray, BoolSep, False);
      end;
    end;
  end;

  if Criterias = '' then begin
    Criterias:= GenerateCriterias(SortField);
  end;
  CriteriasArray:= Split(Criterias, ',');

  SortFieldSQL:= '';
  OrderBySQL:= '';
  //SortArray:= Split(SortField, ',');
  SetLength(CriteriasArray, Length(SortArray));

  for I:= 0 to High(SortArray) do begin
    SortField:= SortArray[I];
    if ((SortField.StartsWith('(')) and (SortField.EndsWith(')'))) then begin
      if SortFieldSQL = '' then begin
        SortFieldSQL:= ' where (' + SortField + ')';
      end
      else begin
        SortFieldSQL:= SortFieldSQL + ' and (' + SortField + ')';
      end;
    end
    else begin
      if (CriteriasArray[I] <> '') then begin
        SetLength(SplitStr, 2);

        if CriteriasArray[I] <> '' then begin
          SplitStr[0]:= Copy(SortField, 1, Pos(CriteriasArray[I], SortField) - 1);
          SplitStr[1]:= Copy(SortField, Pos(CriteriasArray[I], SortField) + Length(CriteriasArray[I]), Length(SortField));
        end
        else begin
          SplitStr[0]:= SortField;
        end;
        SplitDelim:= CriteriasArray[I];
        if SplitDelim = '!' then begin
          SplitDelim:= '<>';
        end;

        if Trim(SplitStr[1]) <> '' then begin
          SplitStr[1]:= FormatField4SQL(SplitStr[0], DeQuotedStr(SplitStr[1]));

          if SplitStr[1] = QuotedStr('') then
            SplitStr[1]:= '';

          if SortFieldSQL = '' then
            SortFieldSQL:= ' where A.' + SplitStr[0] + ' ' + SplitDelim + ' ' + SplitStr[1]
          else
            SortFieldSQL:= SortFieldSQL + ' and A.' + SplitStr[0] + ' ' + SplitDelim + ' ' + SplitStr[1]

        end
        else begin
          OrderBySQL:= OrderBySQL + ' A.' + SplitStr[0] + ',';
        end;
      end
      else begin
        if Length(SortField) > 0 then begin
          OrderBySQL:= OrderBySQL + 'A.' + SortField + ',';
        end;
      end;
    end;
  end;

  Where:= SortFieldSQL;
  OrderBy:= DeleteLastComma(OrderBySQL);
end;

procedure TRawFBAC.NextRecord;
begin
  fFBClient.NextRecord;
  PutDataInArray;
end;

function TRawFBAC.NextValueForGenerator(GeneratorName: String): Integer;
begin
  try
    fFBClient2.SQL.Text:= 'SELECT GEN_ID(' + GeneratorName + ', ' + IntToStr(fGeneratorIncrement) + ') AS GEN FROM RDB$DATABASE';
    fFBClient2.SQLExecute;
    Result:= StrToInt(fFBClient2.Field['GEN']);
  except
    SetGeneratorValue(GeneratorName, 1);
    Result:= 1;
  end;
end;

function TRawFBAC.PrepareEditText4Save(FieldName, Value: String): String;
var DataType: String;
begin
  DataType:= FieldType[FieldName];
  if ((DataType = 'UK') or (DataType = 'IN') or (DataType = 'NU') {or (DataType = 'CU')}) then begin
    Result:= StringReplace(Value, '.', '', [rfReplaceAll]);
    Result:= StringReplace(Result, ',', '.', [rfReplaceAll]);
  end
  else
    Result:= Value;
end;

procedure TRawFBAC.PrevRecord;
begin
  fFBClient.PriorRecord;
  PutDataInArray;
end;

procedure TRawFBAC.PutDataInArray;
var I: Integer;
begin
  if (fFBClient.LastExecutedSQLType = stSelect) or ((fFBClient.LastExecutedSQLType = stUpdate) and (Pos(' returning ', SQL.Text) > 0)) then begin
    for I:= 0 to fDataFields.Count - 1 do begin
      if (GetFieldIndexInQuery(fFBClient, fDataFields[I]) > -1) and (GetFieldType(fDataFields[I]) <> 'BL') then begin
        if (GetFieldType(fDataFields[I]) = 'TS') and (fFBClient.Field[fDataFields[I]] <> '') then begin
          fDataValues[I]:= fFBClient.Field[fDataFields[I]]; //FormatDateTime('dd/mm/yyyy, HH:mm:ss.zzz', fFBClient.Field[fDataFields[I]]);
        end
        else begin
          if (GetFieldType(fDataFields[I]) = 'CU') then begin
            fDataValues[I]:= IncludeCurrencyValueEx(fFBClient.Field[fDataFields[I]]);
          end
          else begin
            fDataValues[I]:= fFBClient.Field[fDataFields[I]];
          end;
        end;
      end
      else begin
        if fFBClient.FieldNumberByName[fDataFields[I]] > -1 then begin
          fDataValues[I]:= fFBClient.Field[fDataFields[I]];
        end
        else begin
          fDataValues[I]:= '';
        end;
      end;
    end;
    for I:= 0 to fUKFields.Count - 1 do begin
      if GetFieldIndexInQuery(fFBClient, fUKFields.Strings[i]) > -1 then begin
        fUKData.Strings[i]:= fFBClient.Field[fUKFields.Strings[i]];
      end;
    end;
  end;
  fFieldsChanged.Clear;
end;

function TRawFBAC.ReadStringAndResolve(const Section, Ident: String; Default: String = ''): String;
var AData: String;
    AHostData: StringArray;
    AINI: TINIFile;
begin
  AData:= fINI.ReadString(Section, Ident, Default);
  AData:= ResolveString(AData);

  if (StringStartWith(AData, '{')) and (AData <> '{}') then begin
    AData:= Copy(AData, 2, Length(AData) - 2);
    AHostData:= Split(AData, ':');

    AINI:= TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(fINI.FileName)) + AHostData[0]);
    Result:= AINI.ReadString(AHostData[1], AHostData[2], Default);
    AINI.Free;
  end
  else begin
    if AData = '{}' then begin
      Result:= Default;
    end
    else begin
      Result:= AData;
    end;
  end;
  Result:= ResolveString(Result);
end;

function TRawFBAC.RecordAffected: Integer;
begin
  Result:= fFBClient.RecordSetCount;
end;

function TRawFBAC.RecordCount: Integer;
var SelectedRows: Cardinal;
begin
  if fFBClient.InTransaction then begin
    if (fRecordCount = -1) and (fFBClient.InTransaction) then begin
      fFBClient.LastRecord;
      SelectedRows:= fFBClient.RecordSetCount;

      fRecordCount:= SelectedRows;
      fFBClient.FirstRecord;
      PutDataInArray;
    end;
  end
  else begin
    fRecordCount:= 0;
  end;
  Result:= fRecordCount;
end;

function TRawFBAC.RecordSet2Str(IncludeFieldNames: Boolean; AProgressBar: TProgressBar = nil): AnsiString;
var I: Integer;
    St, ARecord, QueTabla: String;
begin
  St:= '';
  fFBClient.FirstRecord;
  if IncludeFieldNames then begin
    if (fTableInINI <> fTable) then begin
      QueTabla:= fTable + ' as ' + fTableInINI;
    end
    else begin
      QueTabla:= fTable;
    end;

    St:= '[' + QueTabla + ']' + #13#10;
    for I:= 0 to fFBClient.FieldCount - 1 do begin
      St:= St + fFBClient.FieldNameByNumber[i] + #9;
    end;
    St:= DeleteLastString(St, #9) + #13#10;
  end;
  while Not(fFBClient.Eof) do begin
    ARecord:= '';
    for I:= 0 to fFBClient.FieldCount - 1 do begin
      ARecord:= ARecord + ReplaceCharForBackup(fFBClient.Field[fFBClient.FieldNameByNumber[I]]) + #9;
    end;
    if AProgressBar <> nil then begin
      AProgressBar.Position:= AProgressBar.Position + 1;
    end;
    fFBClient.NextRecord;
    St:= St + DeleteLastString(ARecord, #9) + #13#10;
  end;
  if fFBClient.RecordSetCount > 0 then begin
    Result:= St;
  end
  else begin
    Result:= '';
  end;
end;

function TRawFBAC.ReplaceCharForBackup(AStr: String): String;
begin
  AStr:= StringReplace(AStr, #9, '{Tab}', [rfReplaceAll]);
  AStr:= StringReplace(AStr, #10, '{Lf}', [rfReplaceAll]);
  AStr:= StringReplace(AStr, #13, '{Cr}', [rfReplaceAll]);
  Result:= AStr;
end;

function TRawFBAC.ReplaceCharOfBackup(AStr: String): String;
begin
  AStr:= StringReplace(AStr, '{Tab}', #9, [rfReplaceAll]);
  AStr:= StringReplace(AStr, '{Lf}', #10, [rfReplaceAll]);
  AStr:= StringReplace(AStr, '{Cr}', #13, [rfReplaceAll]);
  Result:= AStr;
end;

function TRawFBAC.RestoreFromFile(AFilename: String; DeleteTable: Boolean): Boolean;
var Errores, I: Integer;
    F: TextFile;
    TableName, ALine: String;
    FieldNames, FieldValues: StringArray;
    ATable: TRawFBAC;
begin
  ATable:= TRawFBAC.CreateMemINI(Self.Parent, '', fINI);
  Errores:= 0;
  AssignFile(F, AFilename);
  Reset(F);
  while Not(System.Eof(F)) do begin
    ReadLn(F, ALine);
    ALine:= Trim(ALine);
    if StringStartWith(ALine, '[') and StringEndWith(ALine, ']') then begin
      if ATable.Table <> '' then begin
        UpdateGeneratorWithLastTableValue(ATable);
      end;
      TableName:= Copy(ALine, 2, Length(ALine) - 2);
      FieldNames:= Split('', ',');
      if TableName = '' then begin
        Break;
      end;
      ATable.Table:= TableName;
    end
    else begin
      if Length(FieldNames) = 0 then begin
        FieldNames:= Split(ALine, #9);
      end
      else begin
        if ALine <> '' then begin
          try
            FieldValues:= Split(ALine, #9);
            ATable.InitRecord;
            for I:= Low(FieldValues) to High(FieldValues) do begin
              ATable.Field[FieldNames[I]]:= FieldValues[I];
            end;
            ATable.UpDateOrInsertRecord;
          except
            Inc(Errores);
          end;
        end;
      end;
    end;
  end;
  if ATable.Table <> '' then begin
    UpdateGeneratorWithLastTableValue(ATable);
  end;

  CloseFile(F);
  MsgBox('Importando datos: Errores: ' + IntToStr(Errores), Application.Title, MB_OK + StrToInt(IIf(Errores > 0, '16', '64')));

  ATable.Free;
end;

function TRawFBAC.ServerVersion: String;
begin
  Result:= 'n/a';//DBArray[fDBIndex].DatabaseInfo.Version;
end;

procedure TRawFBAC.SetConnected(const Value: Boolean);
begin
  fFBClient.Connected:= Value;
  fFBClient2.Connected:= Value;
end;

procedure TRawFBAC.SetDefault4Browse(AValue: String);
begin
  WriteStringAndResolve(fTableInINI, 'Default4Browse', AValue);
end;

procedure TRawFBAC.SetDisableModifyFields(const Value: String);
begin
  if (fDisableModifyFields = '') and (Value <> '') then begin
    fDisableModifyFields:= ',';
  end;
  if Value = '' then
    fDisableModifyFields:= ''
  else
    fDisableModifyFields:= fDisableModifyFields + UpperCase(Value) + ',';
end;

//procedure TRawFBAC.SetEvents4Browser(AEdit: TEdit; AButton: TButton; APanel: TPanel);
//begin
//  AddEventIfIsAssigned(AEdit, 'OnKeyPress', nil, nil, AEdit.OnKeyPress, fControlsEvents);
//  AEdit.OnKeyPress:= NumericEditKeyPress;
//
//  AddEventIfIsAssigned(AEdit, 'OnKeyDown', nil, AEdit.OnKeyDown, nil, fControlsEvents);
//  AEdit.OnKeyDown:= EditKeyDown;
//
//  AddEventIfIsAssigned(AEdit, 'OnChange', AEdit.OnChange, nil, nil, fControlsEvents);
//  //AEdit.OnChange:= EdtLinkChange;
//end;

procedure TRawFBAC.SetEvents4Edit(FieldType: String; Edit: TEdit);
var I: Integer;
begin
  if FieldType = '' then begin
    for I:= Low(fControlsEvents) to High(fControlsEvents) do begin
      if fControlsEvents[i].ControlName = Edit.Name then begin
        fControlsEvents[i].ControlName:= '';
        fControlsEvents[i].EventName:= '';
        fControlsEvents[i].ANotifyEvent:= nil;
        fControlsEvents[i].AKeyDownEvent:= nil;
        fControlsEvents[i].AKeyPressEvent:= nil;
      end;
    end;
    Edit.OnKeyPress:= nil;
    Edit.OnEnter:= nil;
    Edit.OnExit:= nil;
    Edit.OnKeyDown:= nil;
    Edit.OnEnter:= nil;
    Edit.OnChange:= nil;
  end;
  if FieldType = 'CU' then begin
    Edit.Alignment:= taRightJustify;

    AddEventIfIsAssigned(Edit, 'OnKeyPress', nil, nil, Edit.OnKeyPress, fControlsEvents);
    Edit.OnKeyPress:= FloatEditKeyPress;

    AddEventIfIsAssigned(Edit, 'OnEnter', Edit.OnEnter, nil, nil, fControlsEvents);
    Edit.OnEnter:= edtCurrencyEnter;

    AddEventIfIsAssigned(Edit, 'OnExit', Edit.OnExit, nil, nil, fControlsEvents);
    Edit.OnExit:= edtCurrencyExit;

    AddEventIfIsAssigned(Edit, 'OnKeyDown', nil, Edit.OnKeyDown, nil, fControlsEvents);
    Edit.OnKeyDown:= EditKeyDown;
    edtCurrencyExit(Edit);
  end;
  if FieldType = 'TI' then begin
    AddEventIfIsAssigned(Edit, 'OnKeyDown', nil, Edit.OnKeyDown, nil, fControlsEvents);
    Edit.OnKeyDown:= edtHoraKeyDown;

    AddEventIfIsAssigned(Edit, 'OnKeyPress', nil, nil, Edit.OnKeyPress, fControlsEvents);
    Edit.OnKeyPress:= edtHoraKeyPress;

    AddEventIfIsAssigned(Edit, 'OnExit', Edit.OnExit, nil, nil, fControlsEvents);
    Edit.OnExit:= edtHoraExit;
  end;
  if FieldType = 'NU' then begin
    AddEventIfIsAssigned(Edit, 'OnKeyPress', nil, nil, Edit.OnKeyPress, fControlsEvents);
    Edit.OnKeyPress:= FloatEditKeyPress;

    AddEventIfIsAssigned(Edit, 'OnEnter', Edit.OnEnter, nil, nil, fControlsEvents);
    Edit.OnEnter:= edtCurrencyEnter;

    AddEventIfIsAssigned(Edit, 'OnKeyDown', nil, Edit.OnKeyDown, nil, fControlsEvents);
    Edit.OnKeyDown:= EditKeyDown;

    AddEventIfIsAssigned(Edit, 'OnExit', Edit.OnExit, nil, nil, fControlsEvents);
    Edit.OnExit:= edtCurrencyExit;
    edtCurrencyExit(Edit);
  end;
  if FieldType = 'ST' then begin
    AddEventIfIsAssigned(Edit, 'OnKeyDown', nil, Edit.OnKeyDown, nil, fControlsEvents);
    Edit.OnKeyDown:= EditKeyDown;

    AddEventIfIsAssigned(Edit, 'OnKeyPress', nil, nil, Edit.OnKeyPress, fControlsEvents);
    Edit.OnKeyPress:= edtKeyPress;

    AddEventIfIsAssigned(Edit, 'OnChange', Edit.OnChange, nil, nil, fControlsEvents);
    Edit.OnChange:= edtCUITChange;
    edtCUITChange(Edit);
  end;
  if (FieldType = 'IN') or (FieldType = 'UK') or (FieldType = 'LN') then begin
    AddEventIfIsAssigned(Edit, 'OnKeyPress', nil, nil, Edit.OnKeyPress, fControlsEvents);
    Edit.OnKeyPress:= NumericEditKeyPress;

    AddEventIfIsAssigned(Edit, 'OnKeyDown', nil, Edit.OnKeyDown, nil, fControlsEvents);
    Edit.OnKeyDown:= EditKeyDown;
  end;
  if FieldType = 'LN' then begin
    AddEventIfIsAssigned(Edit, 'OnChange', Edit.OnChange, nil, nil, fControlsEvents);
    Edit.OnChange:= EdtLinkChange;
  end;
  if FieldType = 'DA' then begin
    AddEventIfIsAssigned(Edit, 'OnExit', Edit.OnExit, nil, nil, fControlsEvents);
    Edit.OnExit:= edtFechaExit;

    AddEventIfIsAssigned(Edit, 'OnKeyDown', nil, Edit.OnKeyDown, nil, fControlsEvents);
    Edit.OnKeyDown:= edtFechaKeyDown;
  end;
end;

procedure TRawFBAC.SetField(FieldName: String; const Value: String);
var I: Integer;
begin
  i:= fDataFields.IndexOf(FieldName);
  if I > -1 then begin
    if FieldType[FieldName] = 'DA' then begin
      if StrIsDate(Value) then begin
        fDataValues[i]:= FormatDateTime('dd/mm/yyyy', StrToDate4TFirebird(Value));
      end
      else begin
        fDataValues[i]:= '';
      end;
    end
    else begin
      if (FieldType[FieldName] = 'CU') or (FieldType[FieldName] = 'NU') then begin
        fDataValues[i]:= StringReplace(ExtractCurrencyValueEx(Value), ',', '.', [rfReplaceAll]);
      end
      else begin
        if (FieldType[FieldName] = 'TS') then begin
          fDataValues[i]:= StringReplace(StringReplace(Value, ',', ' ', [rfReplaceAll]), '-', '/', [rfReplaceAll]);
        end
        else begin
          if (FieldType[FieldName] = 'ST') then begin
            fDataValues[i]:= Copy(Value, 1, StrToInt(GetFieldWidth(FieldName)));
          end
          else begin
            fDataValues[i]:= Value;
          end;
        end;
      end;
    end;
    if fFieldsChanged.IndexOf(FieldName) = -1 then begin
      fFieldsChanged.Add(FieldName);
    end;
  end;
end;

procedure TRawFBAC.SetFields4Browser(AValue: String);
begin
  WriteStringAndResolve(fTableInINI, 'Fields4Browser', AValue);
end;

procedure TRawFBAC.SetGeneratorValue(GeneratorName: String; const Value: Integer);
begin
  fFBClient2.SQL.Text:= 'select * from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr(GeneratorName);
  fFBClient2.SQLExecute;
  if fFBClient2.RecordSetCount = 0 then begin
    fFBClient2.SQL.Text:= 'create generator ' + GeneratorName;
    fFBClient2.SQLExecute;
    fFBClient2.CommitTransaction;
  end;
  fFBClient2.SQL.Text:= 'SET GENERATOR ' + GeneratorName + ' TO ' + IntToStr(Value);
  fFBClient2.SQLExecute;
  fFBClient2.CommitTransaction;
end;

procedure TRawFBAC.SetLogTableOnfINI;
var SL: TStringList;
begin
  SL:= TStringList.Create;
  SL.Add('[LogTables]');
  SL.Add('Title=Log de tablas');
  SL.Add('Indices=Numero,Tabla,Accion,Usuario');
  SL.Add('Generator=LOGTABLES_NUMERO_GEN');
  SL.Add('Default4Browse=Tabla');
  SL.Add('Fields4Browser=Tabla,UKValue');
  SL.Add('[LogTables-F]');
  SL.Add('NUMERO=Número,UK');
  SL.Add('TABLA=Tabla,ST,50');
  SL.Add('USUARIO=Usuario,IN');

  fINI.SetStrings(SL);
  SL.Free;
end;

procedure TRawFBAC.SetShowDeleted(const Value: Boolean);
begin
  FShowDeleted := Value;
end;

procedure TRawFBAC.SetSQL(const Value: TStrings);
begin
  fFBClient.SQL:= TStringList(Value);
end;

procedure TRawFBAC.SetTable(const Value: String; CreateLinkedTables: Boolean);
var I: Integer;
    St, St2, St3: StringArray;
    Dummy: String;
    TableLinked, FieldShowed, FieldSaved: String;
    BrowseAllFields: Boolean;
    ATable: TRawFBAC;
begin
  if Pos(' as ', LowerCase(Value)) > 0 then begin
    fTable:= Copy(Value, 1, Pos(' as ', LowerCase(Value)) - 1);
    fTableInINI:= Copy(Value, Pos(' as ', LowerCase(Value)) + 4, Value.Length);
  end
  else begin
    fTable:= Value;
    fTableInINI:= Value;
  end;

  if fDataFields.Count > 0 then begin
    fDataFields.Clear;
    fDataValues.Clear;
    fDataValues.Clear;
  end;
  fINI.ReadSection(fTableInINI + '-F', fDataFields);
  for I := 0 to fDataFields.Count - 1 do begin
    fDataValues.Add('');
    if ((CreateLinkedTables) and (FieldType[fDataFields[i]] = 'LN')) then begin
      try
        FieldLinkedInfo(fDataFields[i], TableLinked, FieldShowed, FieldSaved, BrowseAllFields);
        ATable:= TRawFBAC.CreateMemINI(Parent, TableLinked, fINI);
        ATable.Free;
      except
        Application.MessageBox(PChar('Se produjo un error creando la tabla ' + QuotedStr(Value) + #13#10 + 'Field ' + QuotedStr(fDataFields[i]) + #13#10 + 'Tabla relacionada ' + QuotedStr(TableLinked)), PChar(Application.Title), MB_OK + MB_ICONERROR);
      end;
    end;
  end;
  fUKFields.Clear;
  fUKData.Clear;
  St:= Split(fINI.ReadString(fTableInINI, 'Indices', ''), ',');
  St:= Split(St[0], '|');
  for I:= Low(St) to High(St) do begin
    fUKFields.Add(St[I]);
    fUKData.Add('');
  end;

  fDefaultValues.Clear;
  St:= Split(fINI.ReadString(fTableInINI, 'Defaults', ''), ',');
  for I:= Low(St) to High(St) do begin
    St2:= Split(St[I], '=');
    Dummy:= St2[1];
    if (Copy(St2[1], 1, 1) = '{') and (Copy(St2[1], St2[1].Length, 1) = '}') then begin
      St2[1]:= Copy(St2[1], 2, St2[1].Length - 2);
      St3:= Split(St2[1], '|');
      SetLength(St3, 3);
      Dummy:= Leer(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + St3[0], St3[1], St3[2]);
    end;
    if (Copy(St2[1], 1, 1) = '"') and (Copy(St2[1], St2[1].Length, 1) = '"') then begin
      St2[1]:= Copy(St2[1], 2, St2[1].Length - 2);
      Dummy:= St2[1];
    end;
    AddDefaultValue(St2[0], Dummy);
  end;
  fDefault4Browse:= ReadStringAndResolve(fTableInINI, 'Default4Browse' , '');
  if fDefault4Browse = '' then begin
    fDefault4Browse:= CopyToStrPos(Fields4Browser, ',');
  end;
  fShowABMButtons:= (fINI.ReadString(fTableInINI, 'HideABMButtons', '0') <> '1');
  fIsBigTable:= fINI.ReadString(fTableInINI, 'BigTable', '') = '1';
  fGeneratorIncrement:= ValInt(ReadStringAndResolve('General', 'GeneratorIncrement', '1'));
  if ReadStringAndResolve(fTableInINI, 'GeneratorIncrement', '') <> '' then begin
    fGeneratorIncrement:= ValInt(ReadStringAndResolve(fTable, 'GeneratorIncrement', ''));
  end;
  fBrowserSearchStarts:= ReadStringAndResolve(fTableInINI, 'BrowserSearchStarts', '') = '1';

  fFBClient.SQL.Text:= 'select RDB$RELATION_NAME from RDB$RELATIONS where RDB$RELATION_NAME = ' + QuotedStr(UpperCase(fTable)) + ';';
  fFBClient.SQLExecute;

  if fFBClient.Eof then begin
    fTableRecentCreated:= CreateTable;
  end
  else begin
    UpdateTableStructure;
  end;
  fFBClient.CommitTransaction;

  fDisableModifyFields:= '';
  St:= Split(fINI.ReadString(fTableInINI, 'DisableFields', ''), ',');
  for I:= Low(St) to High(St) do begin
    SetDisableModifyFields(St[I]);
  end;
end;
procedure TRawFBAC.SetTable(const Value: String);
begin
  SetTable(Value, False);
end;

procedure TRawFBAC.SetVirtualValue(FieldName: String; const Value: String);
var Idx, i, FieldLength: Integer;
    FldsVals: StringArray;
    FieldUpper: String;
begin
  Idx:= -1;
  if fVirtualValuesIndex > -1 then begin
    FieldUpper:= UpperCase(FieldName) + '=';
    FieldLength:= FieldName.Length;
    FldsVals:= Split(fVirtualValues[fVirtualValuesIndex], '|');
    for I:= Low(FldsVals) to High(FldsVals) do begin
      if SameStr(FieldUpper, UpperCase(Copy(FldsVals[i], 1, FieldLength)) + '=') then begin
        Idx:= i;
        Break;
      end;
    end;
    if Idx = -1 then begin
      fVirtualValues[fVirtualValuesIndex]:= fVirtualValues[fVirtualValuesIndex] + '|' + FieldName + '=' + Value;
    end
    else begin
      FldsVals[Idx]:= FieldName + '=' + Value;
      fVirtualValues[fVirtualValuesIndex]:= ArrayToString(FldsVals, '|', False);
    end;
  end
  else begin
    VirtualValueNewRecord;
    fVirtualValuesIndex:= 0;
    fVirtualValues[fVirtualValuesIndex]:= FieldName + '=' + Value;
  end;
end;

procedure TRawFBAC.SetVirtualValuesIndex(const Value: Integer);
begin
  fVirtualValuesIndex:= Value;
end;

procedure TRawFBAC.SetWaitInterval(const Value: Integer);
begin
  fWaitInterval:= Value;
end;

function TRawFBAC.ShowMasterDetailForm(AField, MasterFieldValue: String; Fields2Show: String; ModifyMasterField: Boolean; OrderField: String): Integer;
var F: TfrmMasterDetail;
begin
  F:= TfrmMasterDetail.Create(Self.Parent);
  F.Field:= AField;
  F.DetailTable:= Self;
  F.Fields2Show:= Fields2Show;
  F.FieldValue:= MasterFieldValue;
  F.ModifyMasterField:= ModifyMasterField;
  F.OrderField:= OrderField;
  Result:= F.ShowModal;
  if Result = mrOk then begin
    Self.CreateRecordSet(Self.UniqueField + '=' + F.Grid.Cell[0, F.Grid.SelectedRow].AsString);
  end;
  F.Free;
end;

function TRawFBAC.ShowModifyForm: Boolean;
begin
  Result:= AMForm(True);
  if Result then
    UpDateRecord;
end;

function TRawFBAC.ShowNewForm: Boolean;
begin
  Result:= AMForm(False);
  if Result then
    InsertRecord;
end;

function TRawFBAC.SQLAddDeleted0(TheSQL: String): String;
const Orden: array[0..5] of string = ('group ', 'having ', 'order ', 'union ', 'rows ', 'returning ');
var I, W, Ins: Integer;
    Deleted, QueLetra: String;
    HasColon: Boolean;
    DeletedPos, WherePos: Integer;
begin
  TheSQL:= TheSQL;
  if (Not(FShowDeleted)) and (Not(StringStartWith(TheSQL, 'UPDATE OR INSERT'))) then begin
    DeletedPos:= Pos('deleted_fld = ', LowerCase(TheSQL));
    WherePos:= Pos('where ', LowerCase(TheSQL));
    Deleted:= 'Deleted_FLD = ' + QuotedStr('0');
    if WherePos > 0 then begin
      Ins:= WherePos + 6;
      Deleted:= Deleted + ' and ';
    end
    else begin
      for I := Low(Orden) to High(Orden) do begin
        Ins:= Pos(Orden[i], LowerCase(TheSQL));
        if Ins <> 0 then begin
          Break;
        end;
      end;
    end;
    if Ins = 0 then begin
      Ins:= Length(TheSQL);
    end;
    if Pos('A.', UpperCase(TheSQL)) > 0 then begin
      Deleted:= 'A.' + Deleted;
    end;
    if WherePos = 0 then
      Deleted:= ' where ' + Deleted;

    Insert(Deleted, TheSQL, Ins);
  end;
  Result:= TheSQL;
  //ShowMessage(Result)

end;

procedure TRawFBAC.UpdateGeneratorWithLastTableValue(ATable: TRawFBAC);
begin
  ATable.fFBClient2.CommitTransaction;

  ATable.SQL.Text:= 'select max(' + ATable.GetUniqueField + ') from ' + ATable.Table;
  ATable.ExecuteSQL;
  ATable.SetGeneratorValue(ATable.GetTableGenerator, StrToIntCero(ATable.Field['Max']));
  ATable.fFBClient2.CommitTransaction;
end;

procedure TRawFBAC.UpDateOrInsertRecord;
var SQLUpd, UK, Campos, Valores: String;
    I: Integer;
begin
  SQLUpd:= 'update or insert into ' + fTable + ' (';
  Campos:= 'PRV_TIMESTAMP,';
  Valores:= '''Now'',';
  for I:= 0 to fDataFields.Count - 1 do begin
    Campos:= Campos + fDataFields[i] + ',';
    if (FieldType[fDataFields[i]] = 'UK') and (fDataValues[i] = '') then begin
      //Valores:= Valores + 'Next Value For ' + TableGenerator + ',';
      Valores:= Valores + 'GEN_ID(' + TableGenerator + ', ' + IntToStr(fGeneratorIncrement) + ')';
    end
    else begin
      Valores:= Valores + FormatField4SQL(fDataFields[i], fDataValues[i]) + ',';
    end;
  end;
  Campos:= DeleteLastComma(Campos);
  Valores:= DeleteLastComma(Valores);

  UK:= '';
  for I:= 0 to fUKFields.Count - 1 do begin
    UK:= UK + fUKFields[I] + ' = ' + QuotedStr(GetField(fUKFields[I])) + ' and ';
  end;
  UK:= DeleteLastString(UK, ' and ');

  SQLUpd:= SQLUpd + Campos + ') values (' + Valores + ') matching (' + UniqueField + ')';
  fFBClient2.SQL.Text:= SQLUpd;
  fFBClient2.SQLExecute;
end;

procedure TRawFBAC.UpDateRecord;
var SQLUpd, Valores, Blobs: String;
    I: Integer;
    BlobArray: StringArray;
    AStream: TFileStream;
begin
  if fFieldsChanged.Count > 0 then begin
    Blobs:= '';
    SQLUpd:= 'update ' + fTable + ' set PRV_TIMESTAMP = ''Now'', ';
    Valores:= '';
    for I:= 0 to fDataFields.Count - 1 do begin
      if fFieldsChanged.IndexOf(fDataFields[i]) > -1 then begin
        if FieldType[fDataFields[i]] = 'BL' then begin
          SQLUpd:= SQLUpd + ' ' + fDataFields[i] + ' = :blob' + fDataFields[i] + ',';
          Blobs:= Blobs + fDataFields[i] + ',';
        end
        else begin
          SQLUpd:= SQLUpd + ' ' + fDataFields[i] + ' = ' + FormatField4SQL(fDataFields[i], fDataValues[i]) + ',';
        end;
      end;
    end;
    SQLUpd:= SQLUpd + ' Deleted_FLD = ' + QuotedStr('0') + ' where ' + GetUKWhere;
    fFBClient2.SQL.Text:= SQLUpd;

    fFBClient2.Params.Clear;
    BlobArray:= Split(Blobs, ',');
    for I:= Low(BlobArray) to High(BlobArray) do begin
      if BlobArray[i] <> '' then begin
        AStream:= TFileStream.Create(fDataValues[fDataFields.IndexOf(BlobArray[i])], 0);
        fFBClient2.Params.SetStreamByName('blob'+BlobArray[i], AStream);
        AStream.Free;
      end;
    end;
    fFBClient2.SQLExecute;
    fFBClient2.CommitTransaction;
  end;
end;

procedure TRawFBAC.UpdateTableStructure;
var I: Integer;
    IntFieldsArray: StringArray;
    Barra, Coma: Char;
    IBScript: TRawFB;
begin
  Barra:= '|';
  Coma:= ',';

  IntFieldsArray:= FieldsArray;
  if (GetDataTypeFromFDB('PRV_TIMESTAMP') <> 'Timestamp') then begin
    fFBClient2.SQL.Text:= 'Alter Table ' + fTable + ' Add PRV_TIMESTAMP Timestamp;';
    fFBClient2.SQLExecute;
    //Query2.Transaction.Commit;
  end;
  if (GetDataTypeFromFDB('DELETED_FLD') <> 'Char(1)') then begin
    fFBClient2.SQL.Text:= 'Alter Table ' + fTable + ' Add Deleted_FLD Char(1) default ''0'';';
    fFBClient2.SQLExecute;
    fFBClient2.SQL.Text:= 'update ' + fTable + ' set Deleted_FLD = ''0'';';
    fFBClient2.SQLExecute;

    //Query2.Transaction.Commit;
  end;

  for I:= Low(IntFieldsArray) to High(IntFieldsArray) do begin
    if GetFieldSQLType(IntFieldsArray[i]) <> GetDataTypeFromFDB(IntFieldsArray[i]) then begin
      if fFBClient2.InTransaction then
        fFBClient2.CommitTransaction;

      fFBClient2.StartTransaction;
      if GetDataTypeFromFDB(IntFieldsArray[i]) = '' then
        fFBClient2.SQL.Text:= 'Alter Table ' + fTable + ' Add ' + IntFieldsArray[i] + ' ' + GetFieldSQLType(IntFieldsArray[i]) + ';'
      else begin
        fFBClient2.SQL.Text:= 'Alter Table ' + fTable + ' alter column ' + IntFieldsArray[i] + ' type ' + DeleteStringAfterString(GetFieldSQLType(IntFieldsArray[i]), ' CHARACTER SET ISO8859_1 COLLATE ES_ES_CI_AI') + ';';
      end;

      fFBClient2.SQLExecute;

      if fFBClient2.InTransaction then
        fFBClient2.CommitTransaction;

    end;
  end;
  // Generador
  fFBClient2.SQL.Text:= 'select * from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr(TableGenerator) + ';';
  fFBClient2.SQLExecute;
  if fFBClient2.RecordSetCount = 0 then begin
    fFBClient2.SQL.Text:= 'CREATE GENERATOR ' + GetTableGenerator + ';';
    fFBClient2.SQLExecute;
    fFBClient2.CommitTransaction;
    fFBClient2.SQL.Text:= 'SET GENERATOR ' + GetTableGenerator + ' TO 0;';
    fFBClient2.SQLExecute;
    fFBClient2.CommitTransaction;
  end;

  // Mirar los índices
  IntFieldsArray:= Split(TableIndices, ',');
  for I:= Low(IntFieldsArray) to High(IntFieldsArray) do begin
    IntFieldsArray[I]:= Trim(IntFieldsArray[I]);
    fFBClient2.SQL.Text:= 'SELECT RDB$INDEX_SEGMENTS.RDB$FIELD_NAME AS FIELD_NAME FROM RDB$INDEX_SEGMENTS ' +
                      'LEFT JOIN RDB$INDICES ON RDB$INDICES.RDB$INDEX_NAME = RDB$INDEX_SEGMENTS.RDB$INDEX_NAME ' +
                      'LEFT JOIN RDB$RELATION_CONSTRAINTS ON RDB$RELATION_CONSTRAINTS.RDB$INDEX_NAME = RDB$INDEX_SEGMENTS.RDB$INDEX_NAME ' +
                      'WHERE UPPER(RDB$INDICES.RDB$RELATION_NAME) = ' + QuotedStr(UpperCase(fTable)) +
                      'AND RDB$INDEX_SEGMENTS.RDB$FIELD_NAME = ' + QuotedStr(UpperCase(CopyToStrPos(IntFieldsArray[i], Barra))) +
                      'ORDER BY RDB$INDEX_SEGMENTS.RDB$FIELD_POSITION';
    fFBClient2.SQLExecute;
    if fFBClient2.RecordSetCount = 0 then begin
      fFBClient2.RollBackTransaction;
      fFBClient2.StartTransaction;
      fFBClient2.SQL.Text:= 'CREATE INDEX ' + UpperCase(fTable) + '_' + UpperCase(CopyToStrPos(IntFieldsArray[i], Barra)) + '_A ON ' + fTable + '(' + UpperCase(ReplaceString(IntFieldsArray[i], Barra, Coma)) + '); ';
      fFBClient2.SQLExecute;
      fFBClient2.CommitTransaction;

      fFBClient2.StartTransaction;
      fFBClient2.SQL.Text:= 'CREATE DESCENDING INDEX ' + UpperCase(fTable) + '_' + UpperCase(CopyToStrPos(IntFieldsArray[i], Barra)) + '_D ON ' + fTable + '(' + UpperCase(ReplaceString(IntFieldsArray[i], Barra, Coma)) + ');';
      fFBClient2.SQLExecute;
      fFBClient2.CommitTransaction;
    end;

    if fFBClient2.InTransaction then
      fFBClient2.CommitTransaction;

  end;
  IBScript.Free;
  //Query2.Transaction.Commit;
end;

function TRawFBAC.UpdateTableWith(Criteria, Fields: String): String;
var FieldsArray, FieldsDetArray, RecordsToUpdate: StringArray;
    I, J: Integer;
begin
  FieldsArray:= Split(Fields, ',');
  if Length(Fields) > 0 then begin
    CreateRecordSet(Criteria);
    SetLength(RecordsToUpdate, RecordCount);
    for I:= Low(RecordsToUpdate) to High(RecordsToUpdate) do begin
      RecordsToUpdate[I]:= Field[UniqueField];
      NextRecord;
    end;
    for I:= Low(RecordsToUpdate) to High(RecordsToUpdate) do begin
      if CreateRecordSetAndCount(UniqueField + '=' + RecordsToUpdate[I]) = 1 then begin
        for J:= Low(FieldsArray) to High(FieldsArray) do begin
          FieldsDetArray:= Split(FieldsArray[J], '=');
          Field[FieldsDetArray[0]]:= FieldsDetArray[1];
        end;
        UpDateRecord;
      end;
    end;
  end;
end;

procedure TRawFBAC.VirtualValueDeleteRecord;
begin
  fVirtualValues.Delete(fVirtualValuesIndex);
  if VirtualValueEof then
    VirtualValuePrev;

end;

function TRawFBAC.VirtualValueEof: Boolean;
begin
  Result:= (fVirtualValuesIndex >= (fVirtualValues.Count));
end;

procedure TRawFBAC.VirtualValueFirst;
begin
  if fVirtualValues.Count > 0 then
    fVirtualValuesIndex:= 0;
end;

procedure TRawFBAC.VirtualValueLast;
begin
  fVirtualValuesIndex:= fVirtualValues.Count - 1;
end;

procedure TRawFBAC.VirtualValueNewRecord;
begin
  fVirtualValues.Add('');
  fVirtualValuesIndex:= fVirtualValues.Count - 1;
end;

procedure TRawFBAC.VirtualValueNext;
begin
  Inc(fVirtualValuesIndex);
end;

procedure TRawFBAC.VirtualValuePrev;
begin
  if (fVirtualValuesIndex > 0) then
    Dec(fVirtualValuesIndex);
end;

procedure TRawFBAC.WriteStringAndResolve(const Section, Ident, Value: String);
var AData, Default: String;
    AHostData: StringArray;
    AINI: TINIFile;
begin
  Default:= '';
  AData:= fINI.ReadString(Section, Ident, Default);
  AData:= ResolveString(AData);

  if (StringStartWith(AData, '{')) and (AData <> '{}') then begin
    AData:= Copy(AData, 2, Length(AData) - 2);
    AHostData:= Split(AData, ':');

    AINI:= TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(fINI.FileName)) + AHostData[0]);
    AINI.WriteString(AHostData[1], AHostData[2], Value);
    AINI.Free;
  end
  else begin
    if AData <> '{}' then begin
      fINI.WriteString(Section, Ident, Value);
    end;
  end;
end;

procedure TRawFBAC.Edit4BrowserChange(Sender: TObject);
var I: TBrowserCtrlsRedirector;
    J: Integer;
    ShowFieldArr: StringArray;
begin
  for I in fBrowserCtrlsRedirectorList do begin
    if (I.AEdit = Sender as TEdit) then begin
      if (I.AEdit.Text <> '')and ((I.AFirebirdTable as TRawFBAC).CreateRecordSetAndCount(I.BrowseField + '=' + I.AEdit.Text, '*') = 1) then begin
      ShowFieldArr:= Split(I.ShowField, '.');
      I.APanel.Caption:= ' ';
      for J:= Low(ShowFieldArr) to High(ShowFieldArr) do begin
        I.APanel.Caption:= I.APanel.Caption + (I.AFirebirdTable as TRawFBAC).FieldLinked[ShowFieldArr[J]] + ' ';
      end;
      end
      else begin
        I.APanel.Caption:= '';
      end;

      for J:= 0 to High(fControlsEvents) do begin
        if (fControlsEvents[J].ControlName = (Sender as TComponent).Name) and (fControlsEvents[J].EventName = 'OnChange') then begin
          fControlsEvents[J].ANotifyEvent(Sender);
        end;
      end;
      (I.AFirebirdTable as TRawFBAC).CommitTransaction;
    end;
  end;
end;

procedure TRawFBAC.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var i: Integer;
begin
  if Key = 38 then begin // Arriba
    ((Sender as TControl).Parent).Perform(WM_NEXTDLGCTL, 1, 0);
  end;
  if Key = 40 then begin // Abajo
    ((Sender as TControl).Parent).Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnKeyDown') then begin
      fControlsEvents[i].AKeyDownEvent(Sender, Key, Shift);
    end;
  end;
end;

procedure TRawFBAC.edtHoraKeyPress(Sender: TObject; var Key: Char);
var I: Integer;
begin
  if not (Key in ['0'..'9', ':', #8, #38, #40]) then
    Key:=#0;
  if (Pos(':', (Sender as TEdit).Text) > 0) and (Key in [':']) then
    Key:=#0;

  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnKeyPress') then begin
      fControlsEvents[i].AKeyPressEvent(Sender, Key);
    end;
  end;
end;

procedure TRawFBAC.edtHoraExit(Sender: TObject);
var AKey: Word;
    I: Integer;
begin
  AKey:= 0;
  edtHoraKeyDown(Sender, AKey, []);

  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnExit') then begin
      fControlsEvents[i].ANotifyEvent(Sender);
    end;
  end;
end;

procedure TRawFBAC.edtHoraKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var I, Hora, Minutos: Integer;
begin
  if Pos(':', (Sender as TEdit).Text) > 0 then begin
    Hora:= StrToIntCero(Copy((Sender as TEdit).Text, 1, Pos(':', (Sender as TEdit).Text)-1));
    Minutos:= StrToIntCero(Copy((Sender as TEdit).Text, Pos(':', (Sender as TEdit).Text) + 1, 255));
  end
  else begin
    Hora:= StrToIntCero((Sender as TEdit).Text);
    Minutos:= 0;
  end;

  if Key = 33 then begin // Repág
    Dec(Hora);
    if Hora < 0 then
      Hora:= 23;
  end;

  if Key = 34 then begin // Avpág
    Inc(Hora);
    if Hora > 23 then
      Hora:= 0;
  end;

  if Key = 38 then begin // Arriba
    Dec(Minutos);
    if Minutos < 0 then begin
      Minutos:= 59;
      Dec(Hora);
      if Hora < 0 then
        Hora:= 23;
    end;
  end;
  if Key = 40 then begin // Abajo
    Inc(Minutos);
    if Minutos > 59 then begin
      Minutos:= 0;
      Inc(Hora);
      if Hora > 23 then
        Hora:= 0;
    end;
  end;
  if (Key = 38) or (Key = 40) or (Key = 33) or (Key = 34) or (Key = 0) then begin
    if Minutos > 59 then
      Minutos:= 59;
    if Hora > 23 then
      Hora:= 0;

    Key:= 0;
    (Sender as TEdit).Text:= Format('%.2d:%.2d', [Hora, Minutos]);
    (Sender as TEdit).SelStart:= 0;
    (Sender as TEdit).SelLength:= Length((Sender as TEdit).Text);
  end;

  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnKeyDown') then begin
      fControlsEvents[i].ANotifyEvent(Sender);
    end;
  end;
end;

procedure TRawFBAC.NumericEditKeyPress(Sender: TObject; var Key: Char);
var I: Integer;
begin
  if not (Key in ['0'..'9',#8, #13]) then
    Key:=#0;

  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnKeyPress') then begin
      fControlsEvents[i].AKeyPressEvent(Sender, Key);
    end;
  end;
end;

procedure TRawFBAC.FloatEditKeyPress(Sender: TObject; var Key: Char);
var I: Integer;
    AKey: Char;
begin
  AKey:= Key;
  if Key = FormatSettings.ThousandSeparator then
    Key:= FormatSettings.DecimalSeparator;

  if Key in ['-',FormatSettings.DecimalSeparator] then begin
    if Key = '-' then begin
      if (Length((Sender as TEdit).Text) > 0) then
        if ((Pos('-',(Sender as TEdit).Text) <> 0) or ((Sender as TEdit).SelStart > 0)) and ((Sender as TEdit).SelLength <> Length((Sender as TEdit).Text)) then
          Key:= #0;
    end
    else begin
      if Key = FormatSettings.DecimalSeparator then begin
        if ((Pos(FormatSettings.DecimalSeparator,(Sender as TEdit).Text) <> 0) and (Pos(FormatSettings.DecimalSeparator,(Sender as TEdit).SelText)<>0)) xor (Pos(FormatSettings.DecimalSeparator,(Sender as TEdit).Text)<>0) or ((Length((Sender as TEdit).Text)>0) and ((Sender as TEdit).Text[Length((Sender as TEdit).Text)] = '-')) or ((Sender as TEdit).SelLength = Length((Sender as TEdit).Text)) or ((Sender as TEdit).SelStart = 0) then
          Key:= #0;
      end;
    end;
  end
  else begin
    if not (Key in ['0'..'9',#8]) then
      Key:= #0;
  end;

  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnKeyPress') then begin
      fControlsEvents[i].AKeyPressEvent(Sender, AKey);
    end;
  end;
end;

function TRawFBAC.FormatField4SQL(FieldName, Value: String): String;
begin
  Result:= FormatFieldType4SQL(FieldType[FieldName], Value);
end;

function TRawFBAC.FormatFieldType4SQL(FieldType, Value: String): String;
var DT: TDateTime;
begin
{
TI = Time
ST = String
BO = Boolean
LS = List
TS = TimeStamp

Numeric:
'UK'
'CU'
'NU'
'IN'
}
  if (FieldType = 'LN') or (FieldType = 'IN') or (FieldType = 'CU') or (FieldType = 'NU') then
    Value:= Iif(Value = '', '0', Value);

  if FieldTypeIsNumeric(FieldType) then begin
    Value:= StringReplace(Value, ',', '.', [rfReplaceAll]);
  end
  else begin
    if (FieldType = 'DA') or (FieldType = 'TS') then begin
      if Value = '' then begin
        Value:= 'null';
      end
      else begin
        if LowerCase(Value) <> 'now' then begin
          DT:= StrToDateTimeMillisecond(Value);
          //Value:= QuotedStr(Copy(Value, 7, 4) + '/' + Copy(Value, 4, 2) + '/' + Copy(Value, 1, 2));
          if (FieldType = 'TS') then begin
            Value:= QuotedStr(FormatDateTime('dd.mm.yyyy, HH:mm:ss.zzz', DT));
          end
          else begin
            Value:= QuotedStr(FormatDateTime('dd.mm.yyyy', DT));
          end;
        end
        else begin
          Value:= QuotedStr(Value);
        end;
      end;
    end
    else begin
      Value:= QuotedStr(Value);
    end;
  end;
  Result:= Value;
end;

function TRawFBAC.FormatText4Print(AText: String): String;
var I, F: Integer;
    AField: String;
begin
  Result:= AText;
  i:= 1;
  while Pos('&', Result, I) > 0 do begin
    I:= Pos('&', Result, I);
    F:= Pos('&', Result, I+1);
    if F = 0 then begin
      F:= Length(Result);
    end;
    if F > I then begin
      AField:= Copy(Result, I + 1, F - I - 1);
      ReplacePartOfString(Result, GetField(Trim(OnlyLetters(AField, ' '))), I, F, False);
    end;
    I:= F + 1;
  end;
end;

procedure TRawFBAC.FreeTStringsFromComboBox(Combo: TComboBox);
begin
  FreeTStringsFromStringList(Combo.Items);
end;

procedure TRawFBAC.FreeTStringsFromStringList(StrLst: TStrings);
var i: Integer;
begin
  for i := StrLst.Count - 1 downto 0 do begin
    if Assigned(StrLst.Objects[0]) then begin
      StrLst.DeleteAItemAndFreeStored(0);
    end;
  end;
end;

procedure TRawFBAC.edtKeyPress(Sender: TObject; var Key: Char);
var i: Integer;
    FieldName: String;
begin
  FieldName:= Copy((Sender as TEdit).Name, 4, Length((Sender as TEdit).Name));
  if FieldIsCUIT(FieldName) then begin
    if not (Key in ['0'..'9','-',#8]) then begin
      Key:=#0;
    end;
  end;

  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnKeyPress') then begin
      fControlsEvents[i].ANotifyEvent(Sender);
    end;
  end;
end;

procedure TRawFBAC.edtCUITChange(Sender: TObject);
var FieldName, ResString, AHint: String;
    i: Integer;
begin
  FieldName:= Copy((Sender as TEdit).Name, 4, Length((Sender as TEdit).Name));
  if FieldIsCUIT(FieldName) then begin
    if EsCUITValido((Sender as TEdit).Text) then begin
      ResString:= 'VALID';
      AHint:= 'La CUIT/CUIL es válida';
    end
    else begin
      ResString:= 'INVALID';
      AHint:= 'La CUIT/CUIL NO es válida';
    end;

    ((Sender as TEdit).Parent.FindComponent('Img' + FieldName + '_Edt') as TImage).Picture.Bitmap.LoadFromResourceName(HInstance, ResString);
    ((Sender as TEdit).Parent.FindComponent('Img' + FieldName + '_Edt') as TImage).Hint:= AHint;
    ((Sender as TEdit).Parent.FindComponent('Img' + FieldName + '_Edt') as TImage).ShowHint:= True;
    (Sender as TEdit).Hint:= AHint;
    (Sender as TEdit).ShowHint:= True;
  end;
  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnChange') then begin
      fControlsEvents[i].ANotifyEvent(Sender);
    end;
  end;
end;

procedure TRawFBAC.edtCurrencyEnter(Sender: TObject);
var i: Integer;
begin
  (Sender as TEdit).Text:= ExtractCurrencyValueEx((Sender as TEdit).Text);
  (Sender as TEdit).SelStart:= 0;
  (Sender as TEdit).SelLength:= Length((Sender as TEdit).Text);

  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnEnter') then begin
      fControlsEvents[i].ANotifyEvent(Sender);
    end;
  end;
end;

procedure TRawFBAC.edtCurrencyExit(Sender: TObject);
var i: Integer;
begin
  (Sender as TEdit).Text:= IncludeCurrencyValueEx((Sender as TEdit).Text);

  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnExit') then begin
      fControlsEvents[i].ANotifyEvent(Sender);
    end;
  end;
end;

procedure TRawFBAC.edtFechaExit(Sender: TObject);
var I: Integer;
    St: String;
begin
  if (Sender is TEdit) then
    (Sender as TEdit).Text:= ProcessEditWithDate((Sender as TEdit).Text);

  St:= Copy((Sender as TComponent).Name, 4, 255);
  if FieldIsEdad(St) then begin
    ((Sender as TEdit).Parent.FindComponent('lbl' + St + '_Edt') as TLabel).Caption:= PersonAge((Sender as TEdit).Text, FormatDateTime('dd/mm/yyyy', Date));
  end;

  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnExit') then begin
      fControlsEvents[i].ANotifyEvent(Sender);
    end;
  end;
end;

procedure TRawFBAC.edtFechaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var St: String;
    i: Integer;
begin
  St:= (Sender as TEdit).Text;
  if St <> '' then begin
    if CharInSet(Chr(Key), [#38, #40, #33, #34, #35, #36]) then begin
      edtFechaExit(Sender);

      case Key of
        38: St:= FormatDateTime('dd/mm/yyyy', IncDay(StrToDate(St), -1));
        40: St:= FormatDateTime('dd/mm/yyyy', IncDay(StrToDate(St), 1));

        33: St:= FormatDateTime('dd/mm/yyyy', IncMonth(StrToDate(St), -1));
        34: St:= FormatDateTime('dd/mm/yyyy', IncMonth(StrToDate(St), 1));

        35: St:= FormatDateTime('dd/mm/yyyy', IncYear(StrToDate(St), 1));
        36: St:= FormatDateTime('dd/mm/yyyy', IncYear(StrToDate(St), -1));
      end;
    end;
    (Sender as TEdit).Text:= St;
  end;
  for I:= 0 to High(fControlsEvents) do begin
    if (fControlsEvents[i].ControlName = (Sender as TComponent).Name) and (fControlsEvents[i].EventName = 'OnKeyDown') then begin
      fControlsEvents[i].AKeyDownEvent(Sender, Key, Shift);
    end;
  end;
end;

end.

