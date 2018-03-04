unit uRoomCall;

interface
uses
  Classes,SysUtils,uTFSystem,Graphics,uSaftyEnum,superobject,uPubFun,Contnrs,
  DateUtils;
type

  {��ѯ����}
  RCallQryParams = record
  public
    //����
    strTrainNo:string;
    //����
    strRoomNum:string;
    //�а࿪ʼʱ��
    dtStartCallTime:TDateTime;
    //�а����ʱ��
    dtEndCallTime:TDateTime;
  end;

  //////////////////////////////////////////////////////////////////////////////
  //����:TCallManPlan
  //����:��Ա�а�ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TCallManPlan = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //��Ա�а�ƻ�GUID
    strGUID:string;
    //���ƻ�guid
    strWaitPlanGUID:string;
    //�а�֪ͨGUID
    strCallNotifyGUID:string;
    //��Աguid
    strTrainmanGUID:string;
    //��Ա����
    strTrainmanNumber:string;
    //��Ա����
    strTrainmanName:string;
    //�г��ƻ�guid
    strTrainPlanGUID:string;
    //�г�����
    strTrainNo:string;
    //�а�ʱ��
    dtCallTime:TDateTime;
    //����ʱ��
    dtChuQinTime:TDateTime;
    //��ס����
    strRoomNum:string;
    //�׽�ʱ��
    dtFirstCallTime:TDateTime;
    //�߽�ʱ��
    dtReCallTime:TDateTime;
    //�ƻ�״̬
    ePlanState:TRoomCallState;
    //�а�����
    strCallContent:string;
    //�׽д���
    nFirstCallTimes:Integer;
    //�߽д���
    nReCallTimes:Integer;
    //�׽н��
    eFirstCallResult:TRoomCallResult;
    //�߽н��
    eReCallResult:TRoomCallResult;


    //�����Һ���
    strServerRoomNum:string;
    //�������豸���
    nServerDeviceID:Integer;
    //���з�����ʱ��
    dtServerRoomCallTime:TDateTime;
    //���з����ҵĴ���
    nServerRoomCallTryTimes:Integer;
    //���з����ҵĽ��
    eServerRoomCallResult:TRoomCallResult;

    //��������
    JoinRoomList:TStringList;
  public
    //�������캯��
    procedure clone(callManPlan:TCallManPlan);
  end;

  //��Ա�а�ƻ�����
  TCallManPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallManPlan;
    procedure SetItem(Index: Integer; AObject: TCallManPlan);
  public
    function Add(AObject: TCallManPlan): Integer;
    property Items[Index: Integer]: TCallManPlan read GetItem write SetItem; default;
    {����:������Աguid����}
    function Find(strTrainmanGUID:string):TCallManPlan;

  end;


  //////////////////////////////////////////////////////////////////////////////
  /// ����:TCallRoomPlan
  /// ����:����а�ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TCallRoomPlan = class
  public
    constructor Create();
    destructor Destroy();override;
    //�������캯��
    procedure Clone(callRoomPlan:TCallRoomPlan);
  public
    //��Ա�а�ƻ�����
    manList:TCallManPlanList;
    //����id
    nID:Integer;
    //����
    strRoomNum:string;
    //���ƻ�
    strWaitPlanGUID:string;
    //�г��ƻ�
    strTrainPlanGUID:string;
    //����
    strTrainNo:string;
    //����ʱ��
    dtCreateTime:TDateTime;
    //�豸���
    nDeviceID:Integer;
    //�а�ʱ��
    dtStartCallTime:TDateTime;
    //����ʱ��
    dtChuQinTime:TDateTime;
    //�׽�ʱ��
    dtFirstCallTime:TDateTime;
    //�߽�ʱ��
    dtReCallTime:TDateTime;

    //�ƻ�״̬
    ePlanState:TRoomCallState;
    //�׽д���
    nFirstCallTimes:Integer;
    //�߽д���
    nReCallTimes:Integer;

    //�׽н��
    eFirstCallResult:TRoomCallResult;
    //�߽н��
    eReCallResult:TRoomCallResult;

    //�����Һ���
    strServerRoomNum:string;
    //�������豸���
    nServerDeviceID:Integer;
    //���з�����ʱ��
    dtServerRoomCallTime:TDateTime;
    //���з����ҵĴ���
    nServerRoomCallTryTimes:Integer;
    //���з����ҵĽ��
    eServerRoomCallResult:TRoomCallResult;
  public
    {����:������Ա�а�ƻ���ʼ��}
    procedure Init(manPlan:TCallManPlan);
    {����:�ж��Ƿ�ʼ�׽�}
    function bNeedFirstCall(dtNow:TDateTime):Boolean;
    {����:�ж��Ƿ�ʼ�߽�}
    function bNeedReCall(dtNow:TDateTime;nRecallInterval:Integer):Boolean;
    {����:�ж��Ƿ�ʼ�����Һ���}
    function bNeedServerRoomCall(dtNow:TDateTime;nRecallInterval:Integer):Boolean;
    {����:ת��Ϊjson����}
    function ToJsonStr():string;
    {����:����json����}
    procedure FromJson(strJson:string);
  end;

  //����а�ƻ�����
  TCallRoomPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallRoomPlan;
    procedure SetItem(Index: Integer; AObject: TCallRoomPlan);
  public
    function Add(AObject: TCallRoomPlan): Integer;
    property Items[Index: Integer]: TCallRoomPlan read GetItem write SetItem; default;
    {����:���շ��䳵�β���}
    function FindByRoomTrainNo(strRoomNum,strTrainNo:string):TCallRoomPlan;
    
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///�ṹ������:TCallManRecord
  ///����:��Ա�а��¼
  //////////////////////////////////////////////////////////////////////////////
  TCallManRecord = class
  public
    //��¼GUID
    strGUID:string;
    //�а�ƻ�GUID
    strCallManPlanGUID:string;
    //���ƻ�GUID
    strWaitPlanGUID:string;
    //��Աguid
    strTrainmanGUID:string;
    //��Ա����
    strTrainmanNumber:string;
    //��Ա����
    strTrainmanName:string;
    //��¼����ʱ��
    dtCreateTime:TDateTime;
    //����
    strTrainNo:string;
    //����
    strRoomNum:string;
    //�豸ID
    nDeviceID:Integer;
    //�а���
    eCallResult:TRoomCallResult;
    //���Դ���
    nConTryTimes:Integer;
    //�ƻ�����ʱ��
    dtChuQinTime:TDateTime;
    //�а�ʱ��
    dtCallTime:TDateTime;
    //�а�����
    eCallState :TRoomCallState;
    //�а෽ʽ
    eCallType:TRoomCallType;
    //ֵ��Ա
    strDutyUser:string;
    //������Ϣ
    strMsg:string;
    //�а෢������
    strVoiceTxt:string;
    //������¼GUID
    strCallVoiceGUID:string;

  public
    {����:����}
    procedure Clone(SCallManRecord:TCallManRecord);
    {����:���ݽа�ƻ����г�ʼ��}
    procedure Init(RoomPlan:TCallRoomPlan; ManPlan:TCallManPlan;dtNow:TDateTime);
  end;

  {��Ա�а��¼����}
  TCallManRecordList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallManRecord;
    procedure SetItem(Index: Integer; AObject: TCallManRecord);
  public
    function Add(AObject: TCallManRecord): Integer;
    property Items[Index: Integer]: TCallManRecord read GetItem write SetItem; default;
        {����:����}
    procedure Clone(CallManRecordList :TCallManRecordList);
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///�ṹ������:TCallVoice
  ///����:����а�����
  //////////////////////////////////////////////////////////////////////////////
  TCallVoice = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //������¼GUID
    strCallVoiceGUID:string;
    //�����ļ�
    vms:TMemoryStream;
    //����ʱ��
    dtCreateTime:TDateTime;
    //�����ļ��洢·��
    strFilePathName:string;
  end;




  //////////////////////////////////////////////////////////////////////////////
  ///�ṹ������:TCallRoomRecord
  ///����:����а��¼
  //////////////////////////////////////////////////////////////////////////////
  TCallRoomRecord = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //��Ա�а��¼�б�
    CallManRecordList :TCallManRecordList;
    //�а�����
    CallVoice:TCallVoice;
  private
    //����а�ƻ�
    m_strCallPlanGUID:string;
    //��Ԣ����
    m_strRoomNum:string;
    //�豸ID
    m_nDeviceID :Integer;
    //�а�ʱ��
    m_dtCallTime:TDateTime;
    //���Դ���
    m_nConTryTimes:Integer;
    //��Ϣ
    m_strMsg:string;
    //�а���
    m_eCallResult:TRoomCallResult;
    //����
    m_strTrainNo :string;
    //�а�����
    m_eCallState :TRoomCallState;
    //�а෽ʽ
    m_eCallType:TRoomCallType;
    //�������ݷ����
    m_strExternalRoomNumber:string;
    //���з���
    m_lstJoinRooms : TStringList;
  private
    procedure SetRoomNum(strRoomNum:string);
    procedure SetDeviceID(nDeviceID:Integer);
    procedure SetCallTime(dtCallTime:TDateTime);
    procedure SetConTryTimes(nConTryTimes:Integer);
    procedure SetStrMsg(strMsg:string);
    procedure SetCallResult(callResult:TRoomCallResult);
    procedure SetTrainNo(strTrainNo:string);
    procedure SetCallState(eCallState:TRoomCallState);
    procedure SetCallType(eCallType:TRoomCallType);
    procedure SetExternalRoomNumber(ExternalRoomNumber:string);
    procedure SetJoinRooms(Rooms: TStringList);
  public
    {����:��¡}
    procedure Clone(s_CallRoomRecord:TCallRoomRecord);
    {����:���ݷ���а�ƻ����г�ʼ��}
    procedure Init(RoomPlan:TCallRoomPlan;dtNow:TDateTime);
    {����:����¼���ļ�����}
    function CreateVoiceFileName():string;
    {����:�������з���}
    function CreateDeviceIDs():string;
    {���ܣ���ȡ��������}
    procedure GetJoinRooms(Rooms:TStringList);
  public
    //�а�ƻ�
    property strCallPlanGUID :string read m_strCallPlanGUID write m_strCallPlanGUID;

    //�����
    property strRoomNum:string read m_strRoomNum write SetRoomNum;
    //�豸ID
    property nDeviceID:Integer read m_nDeviceID write SetDeviceID;
    //�а�ʱ��
    property dtCallTime:TDateTime read m_dtCallTime write SetCallTime;
    //���ӳ��Դ���
    property nConTryTimes:Integer read m_nConTryTimes write SetConTryTimes;
    //��Ϣ
    property strMsg:string read m_strMsg write SetStrMsg;
    //�а���
    property eCallResult:TRoomCallResult read m_eCallResult write SetCallResult;
    //����
    property strTrainNo :string read m_strTrainNo write SetTrainNo;
    //�а�����
    property eCallState :TRoomCallState read m_eCallState write SetCallState;
    //�а෽ʽ
    property eCallType:TRoomCallType read m_eCallType write SetCallType;
    //�������ݷ����
    property  strExternalRoomNumber:string read m_strExternalRoomNumber write m_strExternalRoomNumber;
    //���з���
    property  JoinRooms:TStringList read m_lstJoinRooms write SetJoinRooms;
  end;
  
  {�а�����ص�����}
  TCallDevCallBackData= class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //����а�ƻ�
    callRoomRecord:TCallRoomRecord;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///�ṹ������:RCallDev
  ///����:�����豸������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  RCallDev= record
  public
    //guid
    strGUID:string;
    //������
    strRoomNum:string;
    //�豸���
    nDevNum:Integer;
  public
    {����:�½���ʼ��}
    procedure New();
  end;
  PCallDev =  ^RCallDev;
  {�����豸������Ϣ����}
  TCallDevAry = array of RCallDev;


  //////////////////////////////////////////////////////////////////////////////
  ///�ṹ������:TServerRoomRelation
  ///����:���񷿼�ͷ���Ĺ�ϵ
  //////////////////////////////////////////////////////////////////////////////
  RServerRoomRelation= record
  public
    //guid
    strGUID:string;
    //������
    strNumber:string;
    //�豸���
    strRoomNum:string;
  public
    {����:�½���ʼ��}
    procedure New();
  end;

  PServerRoomRelation =  ^RServerRoomRelation ;
    {�����豸������Ϣ����}
  TServerRoomRelationAry = array of RServerRoomRelation;


implementation

uses
  StrUtils;

{ RRoomCall }
function TCallRoomPlan.bNeedReCall(dtNow:TDateTime;nRecallInterval:Integer):Boolean;
begin
  result := False;
  if self.nFirstCallTimes <=0 then Exit ;
  if Self.eReCallResult = TR_SUCESS then Exit;
  if self.nReCallTimes > 1 then Exit;

  if DateUtils.IncMinute(dtStartCallTime,nRecallInterval) <= dtNow  then
  begin
    result := True;
    Exit;
  end;

  {
  //δ�׽�,�˳�
  if Self.dtFirstCallTime <1 then Exit;

  if DateUtils.IncMinute(dtStartCallTime,nRecallInterval) <= dtNow  then
  begin
    result := True;
  end;   }
end;
function TCallRoomPlan.bNeedServerRoomCall(dtNow: TDateTime;
  nRecallInterval: Integer): Boolean;
begin
  result := False;
  if self.nReCallTimes <=0 then Exit ;
  if Self.eServerRoomCallResult = TR_SUCESS then Exit;
  if self.nServerRoomCallTryTimes > 1 then Exit;

  if DateUtils.IncMinute(dtReCallTime,1) <= dtNow  then
  begin
    result := True;
    Exit;
  end;

end;

procedure TCallRoomPlan.Clone(callRoomPlan: TCallRoomPlan);
var
  i:integer;
  callManPlan:TCallManPlan;
begin
  
  Self.manList.Clear;
  //��Ա�а�ƻ�����
  for i := 0 to callRoomPlan.manList.Count - 1 do
  begin
    callManPlan := TCallManPlan.Create;
    self.manList.Add(callManPlan);
    callManPlan.clone(callRoomPlan.manList.Items[i]);
  end;
  
  Self.nID:=Self.nID;
  Self.strRoomNum:= callRoomPlan.strRoomNum;
  Self.strWaitPlanGUID:= callRoomPlan.strWaitPlanGUID;
  Self.strTrainPlanGUID:= callRoomPlan.strTrainPlanGUID;
  Self.strTrainNo:= callRoomPlan.strTrainNo;
  Self.dtCreateTime:= callRoomPlan.dtCreateTime;
  Self.nDeviceID:= callRoomPlan.nDeviceID;
  Self.dtStartCallTime:= callRoomPlan.dtStartCallTime;
  Self.dtChuQinTime:= callRoomPlan.dtChuQinTime;
  Self.dtFirstCallTime:= callRoomPlan.dtFirstCallTime;
  Self.dtReCallTime:= callRoomPlan.dtReCallTime;
  Self.ePlanState:=callRoomPlan.ePlanState;
  Self.nFirstCallTimes:= callRoomPlan.nFirstCallTimes ;
  Self.nReCallTimes:= callRoomPlan.nReCallTimes ;
  Self.eFirstCallResult:= callRoomPlan.eFirstCallResult ;
  Self.eReCallResult:= callRoomPlan.eReCallResult ;


  self.strServerRoomNum  := callRoomPlan.strServerRoomNum ;
  Self.nServerDeviceID := callRoomPlan.nServerDeviceID ;
  Self.dtServerRoomCallTime:= callRoomPlan.dtServerRoomCallTime ;
  Self.nServerRoomCallTryTimes:= callRoomPlan.nServerRoomCallTryTimes ;
  Self.eServerRoomCallResult:= callRoomPlan.eServerRoomCallResult ;

end;

constructor TCallRoomPlan.Create;
begin
  manList:=TCallManPlanList.Create;
end;

destructor TCallRoomPlan.Destroy;
begin
  manList.Free;
  inherited;
end;

procedure TCallRoomPlan.FromJson(strJson: string);
begin

end;



procedure TCallRoomPlan.Init(manPlan: TCallManPlan);
begin
  Self.strTrainPlanGUID := manPlan.strTrainPlanGUID;
  self.strWaitPlanGUID := manPlan.strWaitPlanGUID;
  self.strRoomNum := manPlan.strRoomNum;
  self.strTrainNo := manPlan.strTrainNo;
  self.dtStartCallTime := manPlan.dtCallTime;
  self.dtChuQinTime := manPlan.dtChuQinTime;
  self.dtFirstCallTime:= manPlan.dtFirstCallTime;
  self.dtReCallTime:=manPlan.dtReCallTime;
  self.ePlanState := manPlan.ePlanState;
  self.nFirstCallTimes := manPlan.nFirstCallTimes;
  Self.nReCallTimes := manPlan.nReCallTimes;
  self.eFirstCallResult := manPlan.eFirstCallResult;
  self.eReCallResult := manPlan.eReCallResult;

  Self.strServerRoomNum := manPlan.strServerRoomNum;
  self.nServerDeviceID :=  manPlan.nServerDeviceID ;
  Self.dtServerRoomCallTime := manPlan.dtServerRoomCallTime ;
  Self.nServerRoomCallTryTimes := manPlan.nServerRoomCallTryTimes;
  self.eServerRoomCallResult := manPlan.eServerRoomCallResult;
end;


function TCallRoomPlan.bNeedFirstCall(dtNow:TDateTime): Boolean;
begin
  //result := True ;Exit;
  result := False;
  if Self.eFirstCallResult = TR_SUCESS then Exit;
  if self.nFirstCallTimes > 0 then Exit;

  if dtStartCallTime <= dtNow  then
  begin
    result := True;
    Exit;
  end;
  {
  
  //���׽�
  if Self.dtFirstCallTime > 1 then Exit;

  if dtStartCallTime <= dtNow  then
  begin
    result := True;
  end;}

end;


function TCallRoomPlan.ToJsonStr: string;
var
  iJson:ISuperObject;
begin
  iJson := so();
    //�����
  iJson.S['strRoomNum'] := strRoomNum;
    //����id
  iJson.I['nID'] := nID;
    //�豸���
  iJson.I['nDeviceID'] := nDeviceID;
end;

{ RRoomDev }

procedure RCallDev.New;
begin
  strGUID := NewGUID();
end;



{ TCallDevCallBackData }

constructor TCallDevCallBackData.Create;
begin
  callRoomRecord:=TCallRoomRecord.Create;
end;

destructor TCallDevCallBackData.Destroy;
begin
  callRoomRecord.Free;
  inherited;
end;

{ TCallManPlanList }

function TCallManPlanList.Add(AObject: TCallManPlan): Integer;
begin
  result := inherited Add(AObject);
end;

procedure TCallManRecordList.Clone(CallManRecordList: TCallManRecordList);
var
  i:Integer;
  callManRecord:TCallManRecord;
begin
  self.clear;
  for i := 0 to CallManRecordList.Count - 1 do
  begin
    callManRecord:=TCallManRecord.Create;
    callManRecord.Clone(CallManRecordList.Items[i]);
    self.Add(callManRecord) ;
  end;
end;

function TCallManPlanList.Find(strTrainmanGUID: string): TCallManPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if self.Items[i].strTrainmanGUID = strTrainmanGUID then
    begin
      result := self.Items[i];
      Exit;
    end;
  end;
end;

function TCallManPlanList.GetItem(Index: Integer): TCallManPlan;
begin
  Result := TCallManPlan(inherited GetItem(Index));
end;

procedure TCallManPlanList.SetItem(Index: Integer; AObject: TCallManPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TCallRoomPlanList }

function TCallRoomPlanList.Add(AObject: TCallRoomPlan): Integer;
begin
  Result := inherited Add(AObject);
end;



function TCallRoomPlanList.FindByRoomTrainNo(strRoomNum,strTrainNo:string): TCallRoomPlan;
var
  i:Integer;
begin
  result := nil;
  for I := 0 to Self.Count - 1 do
  begin
    if self.Items[i].strRoomNum = strRoomNum then
    begin
      if self.Items[i].strTrainNo = strTrainNo then
      begin
        result := self.Items[i];
        Exit;
      end;
    end;
  end;
    
end;

function TCallRoomPlanList.GetItem(Index: Integer): TCallRoomPlan;
begin
  result := TCallRoomPlan(inherited GetItem(Index));
end;

procedure TCallRoomPlanList.SetItem(Index: Integer; AObject: TCallRoomPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TCallVoice }

constructor TCallVoice.Create;
begin
  //vms:=TMemoryStream.Create;
end;

destructor TCallVoice.Destroy;
begin
  FreeAndNil(vms);
  inherited;
end;


{ TRoomCallRecord }

procedure TCallRoomRecord.Clone(s_CallRoomRecord: TCallRoomRecord);
begin
      //����
    Self.strRoomNum:=s_CallRoomRecord.strRoomNum;
    //�а��豸ID
    self.nDeviceID:=s_CallRoomRecord.nDeviceID;
    //�а�ʱ��
    self.dtCallTime:=s_CallRoomRecord.dtCallTime;
    //
    self.nConTryTimes := s_CallRoomRecord.nConTryTimes;
    self.eCallResult := s_CallRoomRecord.eCallResult;
    self.strMsg := s_CallRoomRecord.strMsg;
    self.strCallPlanGUID := s_CallRoomRecord.strCallPlanGUID;
    self.strRoomNum := s_CallRoomRecord. strRoomNum;
    self.strMsg := s_CallRoomRecord.strMsg;
    self.strTrainNo := s_CallRoomRecord.strTrainNo;
    self.eCallState := s_CallRoomRecord.eCallState;
    self.eCallType := s_CallRoomRecord.eCallType;

    Self.strExternalRoomNumber :=s_CallRoomRecord.strExternalRoomNumber ;

    Self.m_lstJoinRooms.Assign( s_CallRoomRecord.m_lstJoinRooms );

//    Self.dtServerRoomCallTime:= s_CallRoomRecord.dtServerRoomCallTime ;
//    Self.nServerRoomCallTryTimes:= s_CallRoomRecord.nServerRoomCallTryTimes ;
//    Self.eServerRoomCallResult:= s_CallRoomRecord.eServerRoomCallResult ;


    //��Ա�а��¼�б�
    CallManRecordList.clone(s_CallRoomRecord.CallManRecordList);
end;

constructor TCallRoomRecord.Create;
begin
  m_lstJoinRooms := TStringList.Create;
   CallManRecordList :=TCallManRecordList.Create;
end;

function TCallRoomRecord.CreateDeviceIDs: string;
var
  i : Integer ;
  strTemp,strText:string ;
  strRoom:string;
  nPos,nDeviceID:Integer;
begin
  //���з����
  strText := IntToStr( m_nDeviceID );
  for I := 0 to m_lstJoinRooms.Count - 1 do
  begin
    strTemp := m_lstJoinRooms.Strings[i];
    nPos := Pos('=',strTemp);
    strRoom  := LeftStr(strTemp,nPos-1);
    nDeviceID := StrToInt( RightStr(strTemp,Length(strTemp) - nPos ) );
    strText := strText + IntToStr(nDeviceID);
  end;
  Result := strText ;
end;

function TCallRoomRecord.CreateVoiceFileName: string;
var
  strTMInfo:string;
  i:Integer;
begin
  for I := 0 to Self.CallManRecordList.Count - 1 do
  begin
    strTMInfo := strTMInfo + Format('%s[%s]',[CallManRecordList.Items[i].strTrainmanName,
      CallManRecordList.Items[i].strTrainmanNumber]);
  end;
  result := Self.m_strRoomNum + FormatDateTime('yy-MM-dd_HH_nn',Self.dtCallTime) + '_' + strTMInfo + '.wav';
end;

destructor TCallRoomRecord.Destroy;
begin
  m_lstJoinRooms.Free ;
  CallManRecordList.Free;
  if CallVoice <> nil then
    CallVoice.Free;
  inherited;
end;


procedure TCallRoomRecord.GetJoinRooms(Rooms: TStringList);
var
  i : Integer ;
  strTemp:string ;
  strRoom:string;
  nPos:Integer;
begin
//  //���з����
//  Rooms.Add(m_strRoomNum);
  //�����������
  for I := 0 to m_lstJoinRooms.Count - 1 do
  begin
    strTemp := m_lstJoinRooms.Strings[i];
    nPos := Pos('=',strTemp);
    strRoom  := LeftStr(strTemp,nPos-1);
    Rooms.Add(strRoom);
  end;
end;

procedure TCallRoomRecord.Init(RoomPlan: TCallRoomPlan;dtNow:TDateTime);
var
  i:Integer;
  manRecord:TCallManRecord;
begin
  for i := 0 to RoomPlan.manList.Count - 1 do
  begin
    manRecord := TCallManRecord.Create;
    manRecord.Init(RoomPlan,RoomPlan.manList.Items[i],dtNow);
    Self.CallManRecordList.Add(manRecord)
  end;
//  //����Ա�ƻ�
//  if roomPlan.manList.Count = 0 then
//  begin
//    manRecord := TCallManRecord.Create;
//    manRecord.strTrainNo := RoomPlan.strTrainNo;
//    manRecord.strRoomNum := RoomPlan.strRoomNum;
//    Self.CallManRecordList.Add(manRecord)
//  end;
  self.m_strRoomNum := RoomPlan.strRoomNum;
  self.m_strTrainNo := RoomPlan.strTrainNo;
  self.m_dtCallTime := dtNow;
    
end;

procedure TCallRoomRecord.SetCallResult(callResult: TRoomCallResult);
var
  i:Integer;
begin
  Self.m_eCallResult := callResult;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].eCallResult := callResult;
  end;
end;

procedure TCallRoomRecord.SetCallTime(dtCallTime: TDateTime);
var
  i:Integer;
begin
  Self.m_dtCallTime := dtCallTime;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].dtCallTime := dtCallTime;
  end;
end;

procedure TCallRoomRecord.SetConTryTimes(nConTryTimes: Integer);
var
  i:Integer;
begin
  Self.m_nConTryTimes := nConTryTimes;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].nConTryTimes := nConTryTimes;
  end;
end;

procedure TCallRoomRecord.SetDeviceID(nDeviceID: Integer);
var
  i:Integer;
begin
  Self.m_nDeviceID := nDeviceID;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].nDeviceID := nDeviceID;
  end;
end;

procedure TCallRoomRecord.SetExternalRoomNumber(ExternalRoomNumber: string);
var
  i:Integer;
begin
  Self.m_strExternalRoomNumber := ExternalRoomNumber;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strRoomNum := ExternalRoomNumber;
  end;
end;

procedure TCallRoomRecord.SetJoinRooms(Rooms: TStringList);
begin
  m_lstJoinRooms.Assign( Rooms );
end;

procedure TCallRoomRecord.SetRoomNum(strRoomNum: string);
var
  i:Integer;
begin
  Self.m_strRoomNum := strRoomNum;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strRoomNum := strRoomNum;
  end;
end;

procedure TCallRoomRecord.SetStrMsg(strMsg: string);
var
  i:Integer;
begin
  Self.m_strMsg := strMsg;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strMsg := strMsg;
  end;
end;

procedure TCallRoomRecord.SetTrainNo(strTrainNo: string);
var
  i:Integer;
begin
  self.m_strTrainNo := strTrainNo;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strTrainNo := strTrainNo;
  end;
end;
procedure TCallRoomRecord.SetCallState(eCallState:TRoomCallState);
var
  i:Integer;
begin
  self.m_eCallState := eCallState;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].eCallState := eCallState;
  end;
end;

procedure TCallRoomRecord.SetCallType(eCallType:TRoomCallType);
var
  i:Integer;
begin
  self.m_eCallType := eCallType;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].eCallType := eCallType;
  end;
end;
{ TCallManRecordList }

function TCallManRecordList.Add(AObject: TCallManRecord): Integer;
begin
  result := inherited Add(AObject);
end;

function TCallManRecordList.GetItem(Index: Integer): TCallManRecord;
begin
  result := TCallManRecord(inherited GetItem(Index));
end;

procedure TCallManRecordList.SetItem(Index: Integer; AObject: TCallManRecord);
begin
  inherited SetItem(Index,AObject);
end;

procedure TCallManRecord.Clone(SCallManRecord: TCallManRecord);
begin
   //��¼GUID
    strGUID:=SCallManRecord.strGUID;
    //�а�ƻ�GUID
    strCallManPlanGUID:=SCallManRecord.strCallManPlanGUID;
    //���ƻ�GUID
    strWaitPlanGUID := SCallManRecord.strWaitPlanGUID;
    //��ԱGUID
    strTrainmanGUID:=SCallManRecord.strTrainmanGUID;
    //��Ա����
    strTrainmanNumber:=SCallManRecord.strTrainmanNumber;
    //��Ա����
    strTrainmanName:=SCallManRecord.strTrainmanName;
    //��¼����ʱ��
    dtCreateTime:=SCallManRecord.dtCreateTime;
    //����
    strTrainNo:=SCallManRecord.strTrainNo;
    //����
    strRoomNum:=SCallManRecord.strRoomNum;
    //�豸ID
    nDeviceID:=SCallManRecord.nDeviceID;
    //�а���
    eCallResult:=SCallManRecord.eCallResult;
    //���Դ���
    nConTryTimes:=SCallManRecord.nConTryTimes;
    //�ƻ�����ʱ��
    dtChuQinTime:=SCallManRecord.dtChuQinTime;
    //�а�ʱ��
    dtCallTime:=SCallManRecord.dtCallTime;
    //�а�����
    eCallState :=SCallManRecord.eCallState;
    //�а෽ʽ
    eCallType:=SCallManRecord.eCallType;
    //ֵ��Ա
    strDutyUser:=SCallManRecord.strDutyUser;
    //������Ϣ
    strMsg:=SCallManRecord.strMsg;
    //�а෢������
    strVoiceTxt:=SCallManRecord.strVoiceTxt;
end;

procedure TCallManRecord.Init(RoomPlan:TCallRoomPlan; ManPlan:TCallManPlan;dtNow:TDateTime);
begin
  //��¼GUID
    strGUID:= NewGUID;;

    //�а�ƻ�GUID 
    strCallManPlanGUID:= ManPlan.strGUID;
    //���ƻ�GUID
    strWaitPlanGUID:= ManPlan.strWaitPlanGUID;
    //��Աguid
    strTrainmanGUID:=ManPlan.strTrainmanGUID;
    //��Ա����
    strTrainmanNumber:= ManPlan.strTrainmanNumber;
    //��Ա����
    strTrainmanName:= ManPlan.strTrainmanName;
    //��¼����ʱ��
    dtCreateTime:= dtNow;
    //����
    strTrainNo:= ManPlan.strTrainNo;
    //����
    strRoomNum:= ManPlan.strRoomNum;
    //�豸ID
    nDeviceID:=RoomPlan.nDeviceID;
    //�ƻ�����ʱ��
    dtChuQinTime:= ManPlan.dtChuQinTime;
    //�а�ʱ��
    dtCallTime:= ManPlan.dtCallTime;
    //�а�����
    strVoiceTxt:= ManPlan.strCallContent;

    if ManPlan.ePlanState >= TCS_FIRSTCALL then
      eCallState := TCS_RECALL;
    if ManPlan.ePlanState = TCS_Publish then
      eCallState := TCS_FIRSTCALL;
end;

{ TCallManPlan }

procedure TCallManPlan.clone(callManPlan: TCallManPlan);
begin
  self.strGUID:= callManPlan.strGUID;
  self.strWaitPlanGUID:= callManPlan.strWaitPlanGUID;
  self.strCallNotifyGUID:= callManPlan.strCallNotifyGUID;
  self.strTrainmanGUID:= callManPlan.strTrainmanGUID ;
  self.strTrainmanNumber:= callManPlan.strTrainmanNumber;
  self.strTrainmanName:= callManPlan.strTrainmanName  ;
  self.strTrainPlanGUID:= callManPlan.strTrainPlanGUID ;
  self.strTrainNo:= callManPlan.strTrainNo     ;
  self.dtCallTime:= callManPlan.dtCallTime     ;
  self.dtChuQinTime:= callManPlan.dtChuQinTime  ;
  self.strRoomNum:= callManPlan.strRoomNum        ;
  self.dtFirstCallTime:= callManPlan.dtFirstCallTime   ;
  self.dtReCallTime:= callManPlan.dtReCallTime   ;
  self.ePlanState:=callManPlan.ePlanState       ;
  self.strCallContent:= callManPlan.strCallContent  ;
  
  Self.nFirstCallTimes:= callManPlan.nFirstCallTimes ;
  Self.nReCallTimes:= callManPlan.nReCallTimes ;
  Self.eFirstCallResult:= callManPlan.eFirstCallResult ;
  Self.eReCallResult:= callManPlan.eReCallResult ;

  Self.strServerRoomNum := callManPlan.strServerRoomNum;
  //�������豸���
  Self.nServerDeviceID:= callManPlan.nServerDeviceID;
  //���з�����ʱ��
  Self.dtServerRoomCallTime:= callManPlan.dtServerRoomCallTime;
  //���з����ҵĴ���
  Self.nServerRoomCallTryTimes:= callManPlan.nServerRoomCallTryTimes;
  //���з����ҵĽ��
  Self.eServerRoomCallResult:= callManPlan.eServerRoomCallResult;

  //����
  self.JoinRoomList.Assign( callManPlan.JoinRoomList );
end;

constructor TCallManPlan.Create;
begin
  JoinRoomList:=TStringList.Create;
end;

destructor TCallManPlan.Destroy;
begin
  JoinRoomList.Free ;
  inherited;
end;

{ RServerRoomRelation }

procedure RServerRoomRelation.New;
begin
  strGUID := NewGUID();
end;

end.
