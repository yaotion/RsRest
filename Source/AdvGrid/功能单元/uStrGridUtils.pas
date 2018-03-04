unit uStrGridUtils;

interface
uses
  Classes,AdvGrid,IniFiles;
type
  RGridColVisible = record
    //�����
    ColumnIndex : integer;
    //������
    ColumnName : string;
    //���Ƿ����
    ColumnVisible : boolean;
  end;
  TRGridColVisibleArray = array of RGridColVisible;

  ///advStringGrid������
  TStrGridUtils = class
  public
    //��ConfigFile�ж�ȡ�е���ʾ��Ϣ��������StrGrid��.FormColVisibles
    class procedure LoadColumnVisible(StrGrid : TAdvStringGrid;ConfigFile : string;SectionName : string);
    //��StrGrid������Ϣ������Config�ļ���
    class procedure SaveColumnVisible(StrGrid : TAdvStringGrid;ConfigFile : string;SectionName : string);
    //��ȡ���Ƿ���ӵ���Ϣ
    class procedure  GetColumnVisible(StrGrid : TAdvStringGrid;out ColVisibleArray : TRGridColVisibleArray);
    //�������Ƿ���ӵ���Ϣ
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
