unit uWebJob_SyncDic_Area;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebJob_SyncDic,superobject,uArea,
  SysUtils,uDBArea;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TWebJob_SyncDic_Area
  /// ����:ͬ���ֵ�����_�����
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_SyncDic_Area = class(TWebJob_SyncDic)
  public
    constructor Create(strJobName:string);override;
    destructor Destroy();override;
  public
    {����:��������}
    procedure SaveData(strData:String);override;
  private
    {����:�������}
    procedure FromJsonStr(strData:string);
    {����:��������}
    procedure ToDB();
  private
    //��������
    m_AreaAry:TAreaArray;
    //�������ݿ����
    m_DBArea:TRsDBArea;
  end;

implementation

{ TWebJob_SyncDic_Area }

constructor TWebJob_SyncDic_Area.Create(strJobName: string);
begin
  inherited Create(strJobName);
  strDicName := 'TABOrgArea';
  m_DBArea:=TRsDBArea.Create();
end;

destructor TWebJob_SyncDic_Area.Destroy;
begin
  m_DBArea.Free;
  inherited;
end;

procedure TWebJob_SyncDic_Area.FromJsonStr(strData: string);
var
  jsData:ISuperObject;
  i:Integer;
begin
  jsData := SO(strData);
  SetLength(m_AreaAry,jsData.AsArray.Length);
  for i:= 0 to jsData.AsArray.Length -1 do
  begin
    m_AreaAry[i].strAreaGUID  := jsData.AsArray[i].S['strGUID'];
    m_AreaAry[i].strAreaName  := jsData.AsArray[i].S['strAreaName'];
    m_AreaAry[i].strJWDNumber := jsData.AsArray[i].S['strJWDNumber'];
    m_AreaAry[i].strJWDName := jsData.AsArray[i].S['strAreaName'];
  end;
  self.InsertLogs(Format('������%d������',[jsData.AsArray.Length]));
end;

procedure TWebJob_SyncDic_Area.SaveData(strData: String);
begin
  inherited;
  try
    FromJsonStr(strData);
    ToDB;
  except on e:Exception do
    InsertLogs('��������ʧ��!');
  end;
end;

procedure TWebJob_SyncDic_Area.ToDB;
begin
  m_DBArea.Sync(m_UpdateMgr.LocalDB,m_AreaAry);
end;

end.

