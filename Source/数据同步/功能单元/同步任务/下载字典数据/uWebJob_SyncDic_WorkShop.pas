unit uWebJob_SyncDic_WorkShop;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uWorkShop,
  SysUtils,uDBWorkShop;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TWebJob_SyncDic_WorkShop
  /// 描述:同步字典数据_车间
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_WorkShop = class(TWebJob_SyncDic)
  public
    constructor Create(strJobName:string);override;
    destructor Destroy();override;
  public
    {功能:保存数据}
    procedure SaveData(strData:String);override;
  private
    {功能:构造对象}
    procedure FromJsonStr(strData:string);
    {功能:保存数据}
    procedure ToDB();
  private
    //车间数组
    m_WorkShopAry:TRsWorkShopArray;
    //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;
  end;

implementation

{ TWebJob_SyncDic_WorkShop }

constructor TWebJob_SyncDic_WorkShop.Create(strJobName: string);
begin
  inherited Create(strJobName);
  strDicName := 'TABOrgWorkShop';
  m_DBWorkShop := nil;

end;

destructor TWebJob_SyncDic_WorkShop.Destroy;
begin
  m_DBWorkShop.Free;
  inherited;
end;

procedure TWebJob_SyncDic_WorkShop.FromJsonStr(strData: string);
var
  jsData:ISuperObject;
  i:Integer;
begin
  jsData := SO(strData);
  SetLength(m_WorkShopAry,jsData.AsArray.Length);
  for i:= 0 to jsData.AsArray.Length -1 do
  begin
    m_WorkShopAry[i].strWorkShopGUID  := jsData.AsArray[i].S['strWorkShopGUID'];
    m_WorkShopAry[i].strAreaGUID := jsData.AsArray[i].S['strAreaGUID'];
    m_WorkShopAry[i].strWorkShopName := jsData.AsArray[i].S['strWorkShopName'];
    m_WorkShopAry[i].strWorkShopNumber := jsData.AsArray[i].S['strWorkShopNumber'];
  end;
  self.InsertLogs(Format('解析出%d条数据',[jsData.AsArray.Length]));
end;

procedure TWebJob_SyncDic_WorkShop.SaveData(strData: String);
begin
  inherited;
  try
    FromJsonStr(strData);
    ToDB;
  except on e:Exception do
    InsertLogs('保存数据失败!');
  end;
end;

procedure TWebJob_SyncDic_WorkShop.ToDB;
begin
  if m_DBWorkShop = nil then
    m_DBWorkShop:=TRsDBWorkShop.Create(m_UpdateMgr.LocalDB);
  m_DBWorkShop.Sync(m_WorkShopAry);
end;

end.

