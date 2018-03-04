unit uDBGuideGroup;

interface
uses
  ADODB,uTFSystem,uGuideGroup;
type
  //ָ�������ݿ������
  TRsDBGuideGroup = class(TDBOperate)
  private
    procedure ADOQueryToData(ADOQuery : TADOQuery;out GuideGroup : RRsGuideGroup);
  public
    //��ȡ����������ָ����
    procedure GetGuideGroupOfWorkShop(WorkShopGUID : string;out GuideGroupArray : TRsGuideGroupArray);
    //����ָ�������ƻ�ȡ��Ӧ��GUID
    function GetGuideGroupGUIDByName(GuideGroupName : string) : string;
  end;
implementation
uses
  SysUtils;
{ TDBWorkShop }

procedure TRsDBGuideGroup.ADOQueryToData(ADOQuery: TADOQuery;
  out GuideGroup: RRsGuideGroup);
begin
  with ADOQuery do
  begin
    GuideGroup.strGuideGroupGUID := FieldByName('strGuideGroupGUID').AsString;
    GuideGroup.strWorkShopGUID := FieldByName('strWorkShopGUID').AsString;
    GuideGroup.strGuideGroupName := FieldByName('strGuideGroupName').AsString;
  end;
end;

function TRsDBGuideGroup.GetGuideGroupGUIDByName(GuideGroupName: string): string;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := '';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select strGuideGroupGUID from TAB_Org_GuideGroup where  strGuideGroupName = %s ';
      strSql := Format(strSql,[QuotedStr(GuideGroupName)]);
      SQL.Text := strSql;
      Open;
      if RecordCount  > 0 then
        Result := FieldByName('strGuideGroupGUID').AsString;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBGuideGroup.GetGuideGroupOfWorkShop(WorkShopGUID : string;
  out GuideGroupArray : TRsGuideGroupArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  guideGroup: RRsGuideGroup;
begin
  SetLength(GuideGroupArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Org_GuideGroup where strWorkShopGUID = %s order by strGuideGroupName';
      strSql := Format(strSql,[QuotedStr(WorkShopGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,guideGroup);
        SetLength(GuideGroupArray,length(GuideGroupArray) + 1);
        GuideGroupArray[length(GuideGroupArray) - 1] := guideGroup;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
