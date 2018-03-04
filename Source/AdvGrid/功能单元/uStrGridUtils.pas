unit uStrGridUtils;

interface
uses
  Classes,AdvGrid,IniFiles;
type
  RGridColVisible = record
    //列序号
    ColumnIndex : integer;
    //列名称
    ColumnName : string;
    //列是否可视
    ColumnVisible : boolean;
  end;
  TRGridColVisibleArray = array of RGridColVisible;

  ///advStringGrid操作类
  TStrGridUtils = class
  public
    //从ConfigFile中读取列的显示信息并作用在StrGrid中.FormColVisibles
    class procedure LoadColumnVisible(StrGrid : TAdvStringGrid;ConfigFile : string;SectionName : string);
    //将StrGrid的列信息保存在Config文件中
    class procedure SaveColumnVisible(StrGrid : TAdvStringGrid;ConfigFile : string;SectionName : string);
    //获取列是否可视的信息
    class procedure  GetColumnVisible(StrGrid : TAdvStringGrid;out ColVisibleArray : TRGridColVisibleArray);
    //设置列是否可视的信息
    class procedure SetColumnVisible(StrGrid : TAdvStringGrid;ColVisibleArray : TRGridColVisibleArray);
  end;
implementation
uses
  SysUtils;
{ TStrGridUtils }

class procedure TStrGridUtils.GetColumnVisible(StrGrid: TAdvStringGrid;
  out ColVisibleArray: TRGridColVisibleArray);
var
  i: Integer;
begin
  SetLength(ColVisibleArray,StrGrid.ColumnHeaders.Count - StrGrid.FixedCols);
  for i := 1 to StrGrid.ColumnHeaders.Count - 1 do
  begin
    ColVisibleArray[i-1].ColumnIndex := i;
    ColVisibleArray[i-1].ColumnName := StrGrid.ColumnHeaders[i];
    ColVisibleArray[i-1].ColumnVisible := true;
    if StrGrid.IsHiddenColumn(i) then
      ColVisibleArray[i-1].ColumnVisible := false;
  end;
end;

class procedure TStrGridUtils.LoadColumnVisible(StrGrid: TAdvStringGrid;
  ConfigFile: string;SectionName : string);
var
  iniFile : TIniFile;
  visibleStrings : TStrings;
  i: Integer;
begin
  iniFile := TIniFile.Create(ConfigFile);
  visibleStrings := TStringList.Create;
  StrGrid.BeginUpdate;
  try
    iniFile.ReadSection(SectionName,visibleStrings);
    for i := 0 to visibleStrings.Count - 1 do
    begin
      if iniFile.ReadBool(SectionName,visibleStrings[i],true) then
        StrGrid.UnHideColumn(i + 1)
      else
        StrGrid.HideColumn(i + 1);
    end;
  finally
    StrGrid.EndUpdate;
    visibleStrings.Free;
    iniFile.Free;
  end;
end;

class procedure TStrGridUtils.SaveColumnVisible(StrGrid: TAdvStringGrid;
  ConfigFile: string;SectionName : string);
var
  iniFile : TIniFile;
  i: Integer;
begin
  iniFile := TIniFile.Create(ConfigFile);
  try
    for i := 1 to StrGrid.ColumnHeaders.Count - 1 do
    begin
      iniFile.WriteBool(SectionName,'Col' + IntToStr(i) ,not StrGrid.IsHiddenColumn(i));
    end;
  finally
    iniFile.Free;
  end;
end;

class procedure TStrGridUtils.SetColumnVisible(StrGrid: TAdvStringGrid;
  ColVisibleArray: TRGridColVisibleArray);
var
  i: Integer;
begin
  StrGrid.BeginUpdate;
  try
    for i := 0 to length(ColVisibleArray) - 1 do
    begin
      if ColVisibleArray[i].ColumnVisible then
      begin
        strGrid.UnHideColumn(i + 1);
      end
      else
        StrGrid.HideColumn(i + 1);
    end;
  finally
    StrGrid.EndUpdate;
  end;
end;

end.
