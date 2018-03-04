unit uWaitWork;

interface
uses
  Classes,SysUtils,Contnrs,uSaftyEnum,uTFSystem,superobject,uPubFun,uTrainman,
  StrUtils,uDutyUser,uSite,uTrainPlan,uWorkShop,Graphics,uSignPlan;
type

  TWaitWorkPlanType =(TWWPT_ASSIGN{�ɰ�},TWWPT_SIGN{ǩ��},TWWPT_LOCAL{����});

  TInOutRoomType = (TInRoom{�빫Ԣ},TOutRoom{����Ԣ}) ;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TSyncPlanIDInfo
  /// ����:��ͬ�����˼ƻ�ID�Լ��ƻ�������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TSyncPlanIDInfo = class
    //�ƻ�GUID
    strPlanGUID:string;
    //�ƻ����
    ePlanType: TWaitWorkPlanType;
  end;

  {��ͬ�����˼ƻ� id,������Ϣ�б�}
  TSyncPlanIDInfoList  = class(TObjectList)
  protected
    function GetItem(Index: Integer): TSyncPlanIDInfo;
    procedure SetItem(Index: Integer; AObject: TSyncPlanIDInfo);
  public
    function Add(AObject: TSyncPlanIDInfo): Integer;
    property Items[Index: Integer]: TSyncPlanIDInfo read GetItem write SetItem; default;
  end;

  TWaitWorkPlan = class ;

  /////////////////////////////////////////////////////////////////////////////
  ///�ṹ����:RRSInOutRoomInfo
  ///����:����Ա���빫Ԣ��Ϣ
  /////////////////////////////////////////////////////////////////////////////
  RRSInOutRoomInfo= record
  public
    //��¼GUID
    strGUID:string;
    //��Ԣ��¼GUID
    strInRoomGUID:string;
    //�г��ƻ�GUID
    strTrainPlanGUID  :string;
    //���ƻ�GUID
    strWaitPlanGUID:string;
    //���빫Ԣʱ��
    dtInOutRoomTime:TDateTime;
    //�����֤����
    eVerifyType :TRsRegisterFlag;
    //ֵ��ԱGUID
    strDutyUserGUID:string;
    //˾��GUID
    strTrainmanGUID:string;
    //˾������
    strTrainmanNumber:string;
    //˾������
    strTrainmanName:string;
    //��¼����ʱ��
    dtCreatetTime  :TDateTime;
    //�ͻ���guid
    strSiteGUID  :string;
    //�����
    strRoomNumber :string;
    //��λ��
    nBedNumber :Integer;
    //�Ƿ�ͬ��
    bUploaded:Boolean;
    //���ƻ�����
    eWaitPlanType:TWaitWorkPlanType;
    //���ʱ��
    dtArriveTime:TDateTime;
    //�а�ʱ��
    dtCallTime:TDateTime;
    //���빫Ԣ���
    eInOutType:TInOutRoomType;
  public
    {����:ת��Ϊjson����}
    function ToJsonStr(inOutType:TInOutRoomType):string;
    {����:����ֵ}
    procedure SetValue(waitPlan:TWaitWorkPlan;trainman:RRsTrainman;dtNow:TDateTime;
        eVerifyType :TRsRegisterFlag;eInOutType:TInOutRoomType;dutyUser:TRsDutyUser;
        siteInfo:TRsSiteInfo);

  end;
  //���빫Ԣ��Ϣ����
  RRsInOutRoomInfoArray= array of RRSInOutRoomInfo;


  (*
  //////////////////////////////////////////////////////////////////////////////
  ///����:TInOutRoomInfo
  ///����:��Ա���빫Ԣ��Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TInOutRoomInfo = class
  public
    {����:����ֵ}
    procedure SetValues(strGUID,strPlanGUID,strTrainmanGUID:string;
        eType:TInOutRoomType;dtTime:TDateTime;dtArriveTime:TDateTime;ePlanType:TWaitWorkPlanType);
    {����:����}
    procedure Reset();
       {����:ת��ΪJSON����}
    function ToJsonStr():string;

  public
    //��¼GUID
    strGUID:string;
    //���ƻ�GUID
    strPlanGUID:string;
    //��ԱGUID
    strTrainmanGUID:string;
    //���빫Ԣ����
    eType:TInOutRoomType;
    //���빫Ԣʱ��
    dtTime:TDateTime;
    //���ʱ��
    dtArriveTime:TDateTime;
    // �Ƿ��ϴ�
    bUpload :Boolean;
    //�ƻ�����
    ePlanType:TWaitWorkPlanType;
  end;
  *)

  (*
  //////////////////////////////////////////////////////////////////////////////
  ///����:TInOutRoomInfoList
  ///����:��Ա���빫Ԣ��Ϣ�б�
  //////////////////////////////////////////////////////////////////////////////
  TInOutRoomInfoList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TInOutRoomInfo;
    procedure SetItem(Index: Integer; AObject: TInOutRoomInfo);
  public
    function Add(AObject: TInOutRoomInfo): Integer;
    property Items[Index: Integer]: TInOutRoomInfo read GetItem write SetItem; default;
    {����:ת��Ϊjson��}
    function ToJsonStr():string;

  end;
  *)
  //////////////////////////////////////////////////////////////////////////////
  /// ����:RWaitTime
  /// ����:���ʱ�̱��¼
  ///  /////////////////////////////////////////////////////////////////////////
  RWaitTime = record
    //��¼GUID
    strGUID:string;
    //����GUID
    strWorkshopGUID:string;
    //��������
    strWorkShopName:string;
    //��·GUID
    strTrainJiaoLuGUID:string;
    //��·����
    strTrainJiaoLuName:string;
    //��·����
    strTrainJiaoLuNickName:string;
    //����
    strTrainNo:string;
    //�����
    strRoomNum:string;
    //���ʱ��
    dtWaitTime:TDateTime;
    //�а�ʱ��
    dtCallTime:TDateTime;
    //����ʱ��
    dtChuQinTime:TDateTime;
    //����ʱ��
    dtKaiCheTime: TDateTime;
    //ǿ��
    bMustSleep:Boolean;
  public
    {����:��ʼ��}
    procedure New();
  end;

  {��෿��ʱ�̱�}
  TWaitTimeAry = array of RWaitTime;
  //////////////////////////////////////////////////////////////////////////////
  ///����:TWaitWorkTrainmanInfo
  ///����:��Ա���ƻ���Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkTrainmanInfo = class
  public
    constructor Create();
    destructor Destroy();override;
    //�������캯��
    procedure Clone(tmInfo:TWaitWorkTrainmanInfo);
  public
    //���
    nIndex:Integer;
    //��¼guid
    strGUID:string;
    //�ƻ�guid
    strPlanGUID:string;
    //��ԱGUID
    strTrainmanGUID:string;
    //��Ա����
    strTrainmanNumber:string;
    //��Ա����
    strTrainmanName:string;
    //�ƻ�״̬
    eTMState:TRsPlanState;
    //�а�״̬
    //eCallState:TRoomCallState;
    //ʵ�ʷ���
    strRealRoom:string;
    //�׽�ʱ��
    dtFirstCallTime:TDateTime;
    //�Ƿ�ɹ��а�
    bCallSucess:Boolean;
    //��Ԣ��¼
    InRoomInfo:RRSInOutRoomInfo;
    //����Ԣ��¼
    OutRoomInfo:RRSInOutRoomInfo;
  public
    {����:��ȡ״̬}
    function GetStateStr():string;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///����:TWaitWorkTrainmanList
  ///����:��Ա���ƻ���Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkTrainmanInfoList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TWaitWorkTrainmanInfo;
    procedure SetItem(Index: Integer; AObject: TWaitWorkTrainmanInfo);
  public
    {����:������Ա}
    function findTrainman(strTrainmanGUID:string): TWaitWorkTrainmanInfo;
    {����:������Ա���չ���}
    function FindTrainman_GH(strGH:string):TWaitWorkTrainmanInfo;
    {����:������Ա���չ���}
    function FindTrainman_Name(Name:string):TWaitWorkTrainmanInfo;
    {����:�ҵ���һ����ȱ��Ա}
    function FindEmptyTrainman():TWaitWorkTrainmanInfo;
    function Add(AObject: TWaitWorkTrainmanInfo): Integer;
    property Items[Index: Integer]: TWaitWorkTrainmanInfo read GetItem write SetItem; default;
  end;


  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  ///  ������TInRoomWorkPlan
  ///  ��������Ԣ�ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TInRoomWorkPlan = class
  public
    constructor Create();
    destructor Destroy();override;
    //�������캯��
  public
    procedure Clear();
  public
    strPlanGUID:string;
    //����
    strCheCi:string;
    //�����
    strRoomNum:string;
    //���ʱ��
    dtWaitWorkTime:TDateTime;
    //�а�ʱ��
    dtCallWorkTime:TDateTime;
    //����
    ePlanType:TWaitWorkPlanType;
    //��Ҫͬ���а�
    bNeedSyncCall:Boolean;
    bNeedRest:Boolean;
    //��Ա�ƻ��б�
    Trainman : RRsTrainman;
    //��������
    JoinRoomList:TStringList;
  end;

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  ///  ������TWaitWorkPlan
  ///  ���������ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkPlan = class
  public
    constructor Create();
    destructor Destroy();override;
    //�������캯��
    procedure Clone(waitWorkPlan:TWaitWorkPlan);
  public
    //���
    nIndex:Integer;
    //���ƻ�GUID
    strPlanGUID:string;
    //ǩ��ƻ�GUID
    strSignPlanGUID:string;
    //����GUID
    strCheJianGUID:string;
    //��������
    strCheJianName:string;
    //��·GUID
    strTrainJiaoLuGUID:string;
    //��·����
    strTrainJiaoLuName:string;
    //��·���
    strTrainJiaoLuNickName:string;
    //�Ƿ�ǿ��
    bNeedRest:Boolean;
    //�ƻ�״̬
    ePlanState: TRsPlanState;
    //����
    strCheCi:string;
    //���ʱ��
    dtWaitWorkTime:TDateTime;
    //�а�ʱ��
    dtCallWorkTime:TDateTime;
    //����ʱ��
    dtKaiCheTime : TDateTime ;
    //�����
    strRoomNum:string;
    //����
    ePlanType:TWaitWorkPlanType;
    //��Ҫͬ���а�
    bNeedSyncCall:Boolean;
    //��Ա�ƻ��б�
    tmPlanList : TWaitWorkTrainmanInfoList;
    //δ��Ԣ����ʱ��
    dtNotifyUnLeaveTime:TDateTime;
    //����
    JoinRoomList:TStringList;
  public
    {����:��ȡ������ס�����ַ���}
    function GetAllRoomNumStr():string;
    {����:�ж���Ա�Ƿ���ס��ͬ�ķ���}
    function tmInSameRoom():Boolean;
    {����:��ȡʵ����Ա����}
    function GetTrainmanCount():Integer;
    {����:��ȡ����Ԣ��Ա����}
    function GetInRoomTrainmanCount():Integer;
    {����:��ȡδ��Ԣ��Ա����}
    function GetUnOutRoomTrainmanCount():Integer;
    {����:�ж��Ƿ��ѳ���Ԣ}
    function bAllOutRoom():Boolean;
    {����:�ж��Ƿ�����Ԣ}
    function bAllInRoom():Boolean;
    {����:���¼ƻ�״̬}
    procedure UpdatePlanState();
    {����:������Ա��Ԣ�ƻ�}
    function AddTrainman(Trainman:RRsTrainman;var strResult:string):TWaitWorkTrainmanInfo;
    {����:������Ա}
    procedure AddNewTrianman(strGUID,strNumber,strName:string);
    {����:��ȡ״̬����}
    function GetStateStr():string;
    {����:�����г��ƻ�����}
    procedure CreateByTrainmanPlan(trainmanPlan:RRSTrainmanPlan;workShop:RRSWorkShop);
    {����:����ǩ��ƻ�����}
    procedure CreateBySignPlan(signPlan:TSignPlan;workShop:RRsWorkShop);
    {����:����ͼ�������¼����}
    procedure CreateByWaitTime(waitTime:RWaitTime);

    {����:�ж��Ƿ�������Ա��������������һ������}
    function bAllChanged2OtherRoom(waitMan:TWaitWorkTrainmanInfo):Boolean;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ������TWaitWorkPlanList
  ///  ���������ƻ��б�
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkPlanList = class(TObjectList)

  protected
    function GetItem(Index: Integer): TWaitWorkPlan;
    procedure SetItem(Index: Integer; AObject: TWaitWorkPlan);
  public
    {����:���ݼƻ�id���Ҽƻ�}
    function Find(strPlanGUID:string):TWaitWorkPlan;
    {����:���ݷ���Ų��Ҷ���}
    function FindByRoomNum(strRoomNum:string):TWaitWorkPlan;
    {����:���Ҹ��ݳ���}
    function findByCheCi(strCheCi:string):TWaitWorkPlan;
    {����:��ȡ����¼����}
    function GetRecordCount():Integer;

    property Items[Index: Integer]: TWaitWorkPlan read GetItem write SetItem; default;
    function Add(AObject: TWaitWorkPlan): Integer;
    {����:��ȡָ�����ͼƻ�����}
    procedure GetPlanCount_Type(planType:TWaitWorkPlanType;var nPlanCount,nTrainmanCount:Integer);
    {����:ɾ��ָ�����͵ļƻ�}
    procedure DelPlan_ByType(planType:TWaitWorkPlanType);
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TWaitRoom
  ///  ����:���˷�����Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TWaitRoom = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //�����
    strRoomNum:string;
    //������Ա�б�
    waitManList:TWaitWorkTrainmanInfoList;
  private
    function GetFloorNum():string;
  public
    //��ȡ¥���
    property FloorNum:string read GetFloorNum;
  end;

  //��λ��Ϣ
  RRsBedInfo = record
    strRoomNumber:string;
    dtInRoomTime:TDateTime;
    strTrainmanGUID:string;
    strTrainmanName:string;
    strTrainmanNumber:string;
    nBedNumber:Integer;
  end;
  
  RRsBedInfoPointer = ^RRsBedInfo  ;
  TRsBedInfoList = array [0..2]  of  RRsBedInfo ;
    //������Ϣ
  RRsRoomInfo = record
    nID:Integer;
    strRoomNumber:string;           //�����
    listBedInfo: TRsBedInfoList ;   //��λ��Ϣ
  end;
  
  TRsBedInfoArray = array of   RRsBedInfo ;
  TRsRoomInfoArray = array of RRsRoomInfo;


  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TRoomWaitManList
  ///  ����:���˷�����ס��Ϣ�б�
  //////////////////////////////////////////////////////////////////////////////
  TWaitRoomList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TWaitRoom;
    procedure SetItem(Index: Integer; AObject: TWaitRoom);
  public
    {����:���ݷ���Ų���}
    function Find(strRoomNum:string):TWaitRoom;
    {����:������ԱGUID������Ա��ס��Ϣ}
    function FindTrainman(strTrainmanGUID:string):TWaitWorkTrainmanInfo;
    function Add(AObject: TWaitRoom): Integer;
    property Items[Index: Integer]: TWaitRoom read GetItem write SetItem; default;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TRoomFloor
  ///  ����:���˷���¥����Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TRoomFloor = class
  public
    //¥����
    strFloorNum:string;
    //��������
    nTotalRoomNum:Integer;
    //����ס��������
    nInRoomNum:Integer;
  public
    //��ʽ����ʾ¥����Ϣ
    function FmtFloorInfo():string;
  end;

   //////////////////////////////////////////////////////////////////////////////
  ///  ����:TRoomFloorList
  ///  ����:���˷���¥����Ϣ�б�
  //////////////////////////////////////////////////////////////////////////////
  TRoomFloorList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRoomFloor;
    procedure SetItem(Index: Integer; AObject: TRoomFloor);
  public
    //��շ���ͳ����Ϣ
    procedure ResetRoomInfo();
    //����¥��
    function FindFloor(strFloorNum:string):TRoomFloor;
    //���ӷ���
    procedure AddRoom(room:TWaitRoom);
    //���з�����
    function GetTotalRoomNum():Integer;
    //������ס������
    function GetTotalInRoomNum():Integer;
    //��ʽ����ʾ¥����Ϣ
    function FmtTotalFloorInfo():string;
    function Add(AObject: TRoomFloor): Integer;
    property Items[Index: Integer]: TRoomFloor read GetItem write SetItem; default;
  end;

  

const
  TWaitWorkPlanTypeName : array[TWaitWorkPlanType] of string = ('�ɰ�','ǩ��','����');
  TWaitWorkPlanTypeColor : array[TWaitWorkPlanType] of TColor = (clRed,clYellow,clWindow);
implementation

{ TWaitWorkPlanList }

function TWaitWorkPlanList.Add(AObject: TWaitWorkPlan): Integer;
begin
  //if AObject.nIndex = -1 then
  AObject.nIndex := self.Count;
  Result := inherited Add (AObject);
end;

procedure TWaitWorkPlanList.DelPlan_ByType(planType: TWaitWorkPlanType);
var
  i:Integer;
begin
  for i := self.Count -1 Downto 0 do
  begin
    if self.Items[i].ePlanType = planType then
    begin
      self.Delete(i);
    end;
  end;
end;

function TWaitWorkPlanList.Find(strPlanGUID: string): TWaitWorkPlan;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strPlanGUID = strPlanGUID then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

function TWaitWorkPlanList.findByCheCi(strCheCi:string):TWaitWorkPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if UpperCase(Self.Items[i].strCheCi) = UpperCase(strCheCi) then
    begin
      result := Self.Items[i];
      Exit;
    end;
  end;
end;

function TWaitWorkPlanList.FindByRoomNum(strRoomNum: string): TWaitWorkPlan;
var
  i,j:Integer;
  JoinRoomList : TStringList ;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    //����Ƿ���������
    if Self.Items[i].strRoomNum = strRoomNum then
    begin
      result := Self.Items[i];
      Exit;
    end;

    //����Ƿ�����������
    JoinRoomList := Self.Items[i].JoinRoomList ;
    for j := 0 to JoinRoomList.Count - 1 do
    begin
      if JoinRoomList[j] = strRoomNum  then
      begin
        result := Self.Items[i];
        Exit;
      end;
    end;
  end;
end;



function TWaitWorkPlanList.GetItem(Index: Integer): TWaitWorkPlan;
begin
  Result := TWaitWorkPlan( inherited GetItem(Index));
end;

procedure TWaitWorkPlanList.GetPlanCount_Type(
  planType:TWaitWorkPlanType;var nPlanCount,nTrainmanCount:Integer);
var
  i:Integer;
begin
  nPlanCount:= 0;
  nTrainmanCount:= 0;
  for I := 0 to self.Count - 1 do
  begin
    if Items[i].ePlanType = planType then
    begin
      inc(nPlanCount);
      nTrainmanCount := nTrainmanCount + Items[i].GetTrainmanCount;
    end;
  end;
end;

function TWaitWorkPlanList.GetRecordCount: Integer;
var
  i:Integer;
begin
  result := 0;
  for i := 0 to Self.Count - 1 do
  begin
    if self.Items[i].tmPlanList.Count = 0 then
    begin
      result := result + 1;
    end
    else
    begin
      result := result + self.Items[i].tmPlanList.Count;
    end;
  end;
end;

procedure TWaitWorkPlanList.SetItem(Index: Integer; AObject: TWaitWorkPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TWaitWorkPlan }



procedure TWaitWorkPlan.AddNewTrianman(strGUID,strNumber,strName:string);
var
  tmPlan:TWaitWorkTrainmanInfo;
begin
  tmPlan:=TWaitWorkTrainmanInfo.Create;
  tmPlan.strGUID := NewGUID;
  tmPlan.strTrainmanGUID := strGUID;
  tmPlan.strPlanGUID := self.strPlanGUID;
  tmPlan.strTrainmanNumber := strNumber;
  tmPlan.strTrainmanName := strName;
  if tmPlan.strTrainmanGUID <> '' then
    tmPlan.eTMState := psPublish
  else
    tmPlan.eTMState := psEdit;
  self.tmPlanList.Add(tmPlan);
end;

function TWaitWorkPlan.AddTrainman(Trainman:RRsTrainman;var strResult:string): TWaitWorkTrainmanInfo;
var
  tmPlan:TWaitWorkTrainmanInfo;
begin
  Result := nil;
  tmPlan := Self.tmPlanList.findTrainman(Trainman.strTrainmanGUID);
  if Assigned(tmPlan) then //���ҵ�
  begin
    strResult := '�ƻ��ڲ��������ظ��ĳ���Ա!';
    Exit;
  end;

  tmPlan := Self.tmPlanList.FindEmptyTrainman();
  if not Assigned(tmPlan) then
  begin
    strResult := '�ƻ���������������λ����Ա!';
    Exit;
  end;
  tmPlan.strPlanGUID := self.strPlanGUID;
  tmPlan.strTrainmanGUID := Trainman.strTrainmanGUID;
  tmPlan.strTrainmanNumber := Trainman.strTrainmanNumber;
  tmPlan.strTrainmanName := Trainman.strTrainmanName;
  tmPlan.eTMState := psPublish;

  Result := tmPlan;
end;
procedure TWaitWorkPlan.UpdatePlanState();
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
  minState:TRsPlanState;
begin
  if self.GetTrainmanCount = 0 then
  begin
    self.ePlanState := psPublish;
    Exit;
  end;
  minState := psOutRoom;
  for i := 0 to Self.tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.strTrainmanGUID <> '') then
    begin
      if tmInfo.eTMState< minState then
      begin
        minState := tmInfo.eTMState;
      end;
    end;
  end;
  Self.ePlanState := minState;
end;
function TWaitWorkPlan.bAllChanged2OtherRoom(
  waitMan: TWaitWorkTrainmanInfo): Boolean;
var
  i:Integer;
  man:TWaitWorkTrainmanInfo;
begin
  result := False;
  for i := 0 to self.tmPlanList.Count - 1 do
  begin
    man := tmPlanList.Items[i];
    if (man.strTrainmanGUID <> '') and (man.strTrainmanGUID <> waitman.strTrainmanGUID) then
    begin
      if man.strRealRoom <> waitMan.strRealRoom then Exit;
    end;
  end;

  if self.strRoomNum <> waitMan.strRealRoom then 
  begin
    result := true;
  end;
    
end;

function TWaitWorkPlan.bAllInRoom():Boolean;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result:= True;
  if self.GetTrainmanCount = 0 then
  begin
    result := False;
    Exit;
  end;
  for i := 0 to Self.tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.strTrainmanGUID <> '') and (tmInfo.eTMState = psPublish) then
    begin
      result := False;
      Exit;
    end;
  end;
end;

function TWaitWorkPlan.bAllOutRoom: Boolean;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result:= True;
  if Self.GetTrainmanCount = 0 then
  begin
    result := False;
    Exit;
  end;
  
  for i := 0 to Self.tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.strTrainmanGUID <> '') and (tmInfo.eTMState < psOutRoom) then
    begin
      result := False;
      Exit;
    end;
  end;
  
end;

procedure TWaitWorkPlan.Clone(waitWorkPlan: TWaitWorkPlan);
var
  i:Integer;
  waitMan:TWaitWorkTrainmanInfo;
begin
  //���
  nIndex:=waitWorkPlan.nIndex ;
  strPlanGUID:=waitWorkPlan.strPlanGUID;
  strSignPlanGUID:=waitWorkPlan.strSignPlanGUID  ;
  strCheJianGUID:=waitWorkPlan.strCheJianGUID ;
  strCheJianName:= waitWorkPlan.strCheJianName ;
  strTrainJiaoLuGUID:= waitWorkPlan.strTrainJiaoLuGUID ;
  strTrainJiaoLuName:= waitWorkPlan.strTrainJiaoLuName;
  strTrainJiaoLuNickName:=  waitWorkPlan.strTrainJiaoLuNickName;
  bNeedRest:=  waitWorkPlan.bNeedRest;
  ePlanState:= waitWorkPlan.ePlanState ;
  strCheCi:= waitWorkPlan.strCheCi  ;
  dtWaitWorkTime:= waitWorkPlan.dtWaitWorkTime ;
  dtCallWorkTime:= waitWorkPlan.dtCallWorkTime ;
  strRoomNum:= waitWorkPlan.strRoomNum  ;
  ePlanType:= waitWorkPlan.ePlanType  ;
  bNeedSyncCall:= waitWorkPlan.bNeedSyncCall  ;
  tmPlanList.Clear;
  for i := 0 to waitWorkPlan.tmPlanList.Count - 1 do
  begin
    waitMan:=TWaitWorkTrainmanInfo.Create;
    tmPlanList.Add(waitMan);
    waitMan.Clone(waitWorkPlan.tmPlanList.Items[i]);
  end;
  Self.JoinRoomList.Assign(waitWorkPlan.JoinRoomList);
    
end;

constructor TWaitWorkPlan.Create;
begin
  tmPlanList := TWaitWorkTrainmanInfoList.Create;
  JoinRoomList:=TStringList.Create;
end;
procedure TWaitWorkPlan.CreateByWaitTime(waitTime:RWaitTime);
begin
  Self.strPlanGUID := NewGUID;
  self.strCheJianGUID := waitTime.strWorkShopGUID;
  self.strCheJianName := waitTime.strWorkShopName;
  self.strTrainJiaoLuGUID := waitTime.strTrainJiaoluGUID;
  self.strTrainJiaoLuName := waitTime.strTrainJiaoLuName;
  Self.strTrainJiaoLuNickName := waitTime.strTrainJiaoLuName;
  Self.bNeedRest := False;
  self.ePlanState := psPublish;
  Self.strRoomNum := waitTime.strRoomNum;
  self.strCheCi := waitTime.strTrainNo;
  self.dtWaitWorkTime := waitTime.dtWaitTime;
  self.dtCallWorkTime := waitTime.dtCallTime;
  Self.bNeedSyncCall := false;
  if FormatDateTime('HH:nn:ss',waitTime.dtCallTime) <> '00:00:00' then
    Self.bNeedSyncCall := true;

  {if FormatDateTime('HH:nn:ss',waitTime.dtWaitTime) <> '00:00:00' then
    Self.bNeedRest := true;
  }
  Self.bNeedRest := waitTime.bMustSleep;
  self.ePlanType := TWWPT_LOCAL;
end;


procedure TWaitWorkPlan.CreateBySignPlan(signPlan: TSignPlan;
  workShop: RRsWorkShop);
var
  waitman:TWaitWorkTrainmanInfo;
  i:Integer;
begin
  Self.strPlanGUID := signPlan.strGUID;
  self.strCheJianGUID := workShop.strWorkShopGUID;
  self.strCheJianName := workShop.strWorkShopName;
  self.strTrainJiaoLuGUID := signPlan.strTrainJiaoluGUID;
  self.strTrainJiaoLuName := signPlan.strTrainJiaoLuName;
  Self.strTrainJiaoLuNickName := signPlan.strTrainJiaoLuName;
  Self.bNeedRest := TPubFun.Int2Bool(signPlan.nNeedRest);
  self.ePlanState := psPublish;
  self.strCheCi := signPlan.strTrainNo;
  self.dtWaitWorkTime := signPlan.dtArriveTime;
  self.dtCallWorkTime := signPlan.dtCallTime;
  Self.bNeedSyncCall := true;
  self.ePlanType := TWWPT_ASSIGN;

  for i := 0 to 3 do
  begin
    if i >=  self.tmPlanList.Count  then
    begin
      waitman := TWaitWorkTrainmanInfo.Create;
      waitman.strGUID := NewGUID;
      waitman.eTMState := psPublish;
      Self.tmPlanList.Add(waitman)
    end
    else
    begin
      waitMan := self.tmPlanList.Items[i];
    end;
    waitman.strPlanGUID := strPlanGUID;
    case i of
      0:
      begin
        waitman.strTrainmanGUID := signPlan.strTrainmanGUID1;
        waitman.strTrainmanNumber := signPlan.strTrainmanNumber1;
        waitman.strTrainmanName := signPlan.strTrainmanName1;
      end;
      1:
      begin
        waitman.strTrainmanGUID := signPlan.strTrainmanGUID2;
        waitman.strTrainmanNumber := signPlan.strTrainmanNumber2;
        waitman.strTrainmanName := signPlan.strTrainmanName2;
      end;
      2:
      begin
        waitman.strTrainmanGUID := signPlan.strTrainmanGUID3;
        waitman.strTrainmanNumber := signPlan.strTrainmanNumber3;
        waitman.strTrainmanName := signPlan.strTrainmanName3;
      end;
      3:
      begin
        waitman.strTrainmanGUID := signPlan.strTrainmanGUID4;
        waitman.strTrainmanNumber := signPlan.strTrainmanNumber4;
        waitman.strTrainmanName := signPlan.strTrainmanName4;
      end;

    end;
    if waitman.strTrainmanGUID = '' then
    begin
      waitman.eTMState := psEdit;
    end
    else
    begin
      waitman.eTMState := psPublish;
    end;

  end;
end;

procedure TWaitWorkPlan.CreateByTrainmanPlan(trainmanPlan:RRSTrainmanPlan;workShop:RRSWorkShop);
var
  waitman:TWaitWorkTrainmanInfo;
  i:Integer;
begin
  Self.strPlanGUID := trainmanPlan.TrainPlan.strTrainPlanGUID;
  self.strCheJianGUID := workShop.strWorkShopGUID;
  self.strCheJianName := workShop.strWorkShopName;
  self.strTrainJiaoLuGUID := trainmanPlan.TrainPlan.strTrainJiaoluGUID;
  self.strTrainJiaoLuName := trainmanPlan.TrainPlan.strTrainJiaoluName;
  Self.strTrainJiaoLuNickName := trainmanPlan.TrainPlan.strTrainJiaoluName;
  Self.bNeedRest := TPubFun.Int2Bool(trainmanPlan.TrainPlan.nNeedRest);
  self.ePlanState := psPublish;
  self.strCheCi := trainmanPlan.TrainPlan.strTrainNo;
  self.dtWaitWorkTime := trainmanPlan.TrainPlan.dtArriveTime;
  self.dtCallWorkTime := trainmanPlan.TrainPlan.dtCallTime;
  Self.bNeedSyncCall := true;
  self.ePlanType := TWWPT_ASSIGN;

  for i := 0 to 3 do
  begin
    if i >=  self.tmPlanList.Count  then
    begin
      waitman := TWaitWorkTrainmanInfo.Create;
      waitman.strGUID := NewGUID;
      waitman.eTMState := psPublish;
      Self.tmPlanList.Add(waitman)
    end
    else
    begin
      waitMan := self.tmPlanList.Items[i];
    end;
    waitman.strPlanGUID := strPlanGUID;
    case i of
      0:
      begin
        waitman.strTrainmanGUID := trainmanPlan.Group.Trainman1.strTrainmanGUID;
        waitman.strTrainmanNumber := trainmanPlan.Group.Trainman1.strTrainmanNumber;
        waitman.strTrainmanName := trainmanPlan.Group.Trainman1.strTrainmanName;
      end;
      1:
      begin
        waitman.strTrainmanGUID := trainmanPlan.Group.Trainman2.strTrainmanGUID;
        waitman.strTrainmanNumber := trainmanPlan.Group.Trainman2.strTrainmanNumber;
        waitman.strTrainmanName := trainmanPlan.Group.Trainman2.strTrainmanName;
      end;
      2:
      begin
        waitman.strTrainmanGUID := trainmanPlan.Group.Trainman3.strTrainmanGUID;
        waitman.strTrainmanNumber := trainmanPlan.Group.Trainman3.strTrainmanNumber;
        waitman.strTrainmanName := trainmanPlan.Group.Trainman3.strTrainmanName;
      end;
      3:
      begin
        waitman.strTrainmanGUID := trainmanPlan.Group.Trainman4.strTrainmanGUID;
        waitman.strTrainmanNumber := trainmanPlan.Group.Trainman4.strTrainmanNumber;
        waitman.strTrainmanName := trainmanPlan.Group.Trainman4.strTrainmanName;
      end;



    end;
    if waitman.strTrainmanGUID = '' then
    begin
      waitman.eTMState := psEdit;
    end
    else
    begin
      waitman.eTMState := psPublish;
    end;

  end;
end;

destructor TWaitWorkPlan.Destroy;
begin
  tmPlanList.Free;
  JoinRoomList.Free;
  inherited;
end;


function TWaitWorkPlan.GetAllRoomNumStr: string;
var
  i,index:Integer;
  man:TWaitWorkTrainmanInfo;
  strList:TStringList;
begin
  result := '';
  strList:= TStringList.Create;
  if strRoomNum <> '' then
    strList.Add(self.strRoomNum);
  try
    for i := 0 to self.tmPlanList.Count - 1 do
    begin
      man := Self.tmPlanList.Items[i];
      if man.strRealRoom <> '' then
      begin
        if strList.Find(man.strRealRoom,index) = False then
          strList.Add(man.strRealRoom);
      end;
    end;
    //strList.DelimitedText;
    if strList.Count = 0 then Exit;
    
    result := strList.DelimitedText;
  finally
    strList.Free;
  end;
    
end;

function TWaitWorkPlan.GetInRoomTrainmanCount: Integer;
var
  tm:TWaitWorkTrainmanInfo;
  i:Integer;
begin
  result := 0;
  for I := 0 to self.tmPlanList.Count - 1 do
  begin
    tm:= self.tmPlanList.Items[i];
    if tm.eTMState >= psInRoom  then
      Inc(Result);
  end;
end;

function TWaitWorkPlan.GetStateStr: string;
var
  i:Integer;
begin
  result := '�ѷ���';
  if Self.bAllOutRoom then
  begin
    result := '����Ԣ';
  end;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    if tmPlanList.Items[i].InRoomInfo.strGUID <>'' then
    begin
      result := '����Ԣ';
      Exit;
    end;
  end;
end;

function TWaitWorkPlan.GetTrainmanCount: Integer;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result := 0;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if tmInfo.strTrainmanGUID <> '' then
      Inc(result);
  end;
end;
function TWaitWorkPlan.GetUnOutRoomTrainmanCount():Integer;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result := 0;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.eTMState > psPublish) and (tmInfo.eTMState < psOutRoom) then
      Inc(Result);
  end;

end;

function TWaitWorkPlan.tmInSameRoom: Boolean;
var
  i:Integer;
  strRoomNum : string;
  waitMan:TWaitWorkTrainmanInfo;
begin
  strRoomNum := Self.strRoomNum;
  result := True;
  for i := 0 to self.tmPlanList.Count - 1 do
  begin
    waitMan := self.tmPlanList.Items[i];
    if waitMan.eTMState >= psInRoom then
    begin
//      if strRoomNum = '' then
//      begin
//        strRoomNum := waitMan.strRealRoom;
//      end
//      else
      //begin
        if waitMan.strRealRoom <> strRoomNum then
        begin
          result := False;
          Exit;
        end;
        
      //end;
    end;
  end;
 
  

end;

{ TWaitWorkTrainmanList }

function TWaitWorkTrainmanInfoList.Add(AObject: TWaitWorkTrainmanInfo): Integer;
begin
  AObject.nIndex := self.Count ;
  result := inherited Add(AObject);
end;

function TWaitWorkTrainmanInfoList.FindEmptyTrainman(
  ): TWaitWorkTrainmanInfo;
var
  i:Integer;
  info:TWaitWorkTrainmanInfo;
begin
  Result := nil;
  if Self.Count <4 then
  begin
    info := TWaitWorkTrainmanInfo.Create;
    Self.Add(info);
  end;

  for i := 0 to self.Count - 1 do
  begin
    if Items[i].strTrainmanGUID = '' then
    begin
      Result := Items[i];
      Break;
    end;
  end;


end;

function TWaitWorkTrainmanInfoList.findTrainman(
  strTrainmanGUID: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strTrainmanGUID = strTrainmanGUID then
    begin
      Result := items[i];
      Break;
    end;
  end;
end;

function TWaitWorkTrainmanInfoList.FindTrainman_GH(
  strGH: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if Items[i].strTrainmanNumber = strGH then
    begin
      result := Items[i];
    end;
  end;
end;

function TWaitWorkTrainmanInfoList.FindTrainman_Name(
  Name: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if Items[i].strTrainmanName = Name then
    begin
      result := Items[i];
    end;
  end;
end;

function TWaitWorkTrainmanInfoList.GetItem(Index: Integer): TWaitWorkTrainmanInfo;
begin
  result := TWaitWorkTrainmanInfo(inherited GetItem(Index));
end;

procedure TWaitWorkTrainmanInfoList.SetItem(Index: Integer; AObject: TWaitWorkTrainmanInfo);
begin
  SetItem(Index,AObject);
end;
(*
{ TInOutRoomInfoList }

function TInOutRoomInfoList.Add(AObject: TInOutRoomInfo): Integer;
begin
  Result := inherited Add(AObject);
end;

function TInOutRoomInfoList.GetItem(Index: Integer): TInOutRoomInfo;
begin
  result := TInOutRoomInfo(inherited GetItem(Index));
end;

procedure TInOutRoomInfoList.SetItem(Index: Integer; AObject: TInOutRoomInfo);
begin
  inherited SetItem(Index,AObject);
end;

function TInOutRoomInfoList.ToJsonStr: string;
var
  i:Integer;
  iJson: ISuperObject;
  infoJson:ISuperObject;
begin
  for i := 0 to self.Count - 1 do
  begin
    infoJson := so(Self.Items[i].ToJsonStr);
    iJson.AsArray.Add(infoJson);
  end;
  result := iJson.asstring;
  iJson := nil;
end;
 *)
{ TWaitWorkTrainmanInfo }

procedure TWaitWorkTrainmanInfo.Clone(tmInfo:TWaitWorkTrainmanInfo);
begin
  //���
    nIndex:=tmInfo.nIndex  ;
    strGUID:=tmInfo.strGUID ;
    strPlanGUID:=tmInfo.strPlanGUID;
    strTrainmanGUID:=tmInfo.strTrainmanGUID;
    strTrainmanNumber:=tmInfo.strTrainmanNumber;
    strTrainmanName:=tmInfo.strTrainmanName;
    eTMState:=tmInfo.eTMState ;
    dtFirstCallTime := tmInfo.dtFirstCallTime;
    strRealRoom:=tmInfo.strRealRoom;
    InRoomInfo:=tmInfo.InRoomInfo ;
    OutRoomInfo:=tmInfo.OutRoomInfo;
end;

constructor TWaitWorkTrainmanInfo.Create;
begin
  nIndex := -1;
end;

destructor TWaitWorkTrainmanInfo.Destroy;
begin
  inherited;
end;

{ TInOutRoomInfo }

function TWaitWorkTrainmanInfo.GetStateStr: string;
begin
  result := '';
  if Self.strTrainmanGUID <> '' then
    Result := 'δ��Ԣ';

  if Self.eTMState > psPublish then
    result := TRsPlanStateNameAry[Self.eTMState];

  if (Self.eTMState = psFirstCall) and  (Self.bCallSucess = False) then
    Result := '�׽�ʧ��!';
  if (Self.eTMState = psReCall) and  (Self.bCallSucess = False) then
    Result := '�߽�ʧ��!';
  Exit;
end;
 (*
procedure TInOutRoomInfo.Reset;
begin
  Self.strGUID := '';
  Self.strPlanGUID := '';
  Self.strTrainmanGUID := '';
  self.eType := TInRoom;
  Self.dtTime := 0;
  Self.dtArriveTime := 0;
  bUpload := False;
end;

procedure TInOutRoomInfo.SetValues(strGUID, strPlanGUID, strTrainmanGUID: string;
    eType: TInOutRoomType; dtTime: TDateTime;dtArriveTime:TDateTime;ePlanType:TWaitWorkPlanType);
begin
  Self.strGUID := strGUID;
  Self.strPlanGUID := strPlanGUID;
  Self.strTrainmanGUID := strTrainmanGUID;
  self.eType := eType;
  Self.dtTime := dtTime;
  self.dtArriveTime := dtArriveTime;
  Self.ePlanType := ePlanType;
  bUpload := False;
end;


function TInOutRoomInfo.ToJsonStr: string;
var
  jso:ISuperObject;
begin
  jso  := so('{}');
  jso.S['strGUID'] := strGUID;
  jso.s['strWaitPlanGUID'] := strPlanGUID;
  jso.s['strTrainmanGUID'] := strTrainmanGUID;
  jso.I['InOutRoomType'] := Ord(eType);
  jso.s['dtArriveTime']:= FormatDateTime('yyyy-mm-dd HH:mm:ss',dtTime);
  jso.s['dtTime'] := FormatDateTime('yyyy-mm-dd HH:mm:ss',dtTime);
  if ePlanType = TWWPT_ASSIGN then
    jso.S['strTrainPlanGUID'] := strPlanGUID;
  Result := jso.AsString;
  jso := nil;
end;
  *)

{ TSyncPlanIDInfoList }

function TSyncPlanIDInfoList.Add(AObject: TSyncPlanIDInfo): Integer;
begin
  result := inherited Add(AObject);
end;

function TSyncPlanIDInfoList.GetItem(Index: Integer): TSyncPlanIDInfo;
begin
  result := TSyncPlanIDInfo(inherited GetItem(Index));
end;

procedure TSyncPlanIDInfoList.SetItem(Index: Integer; AObject: TSyncPlanIDInfo);
begin
  inherited SetItem(Index,AObject);
end;



{ TWaitRoomList }

function TWaitRoomList.Add(AObject: TWaitRoom): Integer;
begin
  Result:= inherited Add(AObject);
end;

function TWaitRoomList.Find(strRoomNum: string): TWaitRoom;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strRoomNum = strRoomNum then
    begin
      result := Items[i];
      Exit;
    end;
  end;
end;

function TWaitRoomList.FindTrainman(
  strTrainmanGUID: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    result := self.Items[i].waitManList.findTrainman(strTrainmanGUID);
    if Assigned(Result) then Exit;
  end;
end;

function TWaitRoomList.GetItem(Index: Integer): TWaitRoom;
begin
  result := TWaitRoom(inherited GetItem(index) );
end;

procedure TWaitRoomList.SetItem(Index: Integer;
  AObject: TWaitRoom);
begin
  inherited SetItem(index,AObject);
end;

{ TWaitWorkRoomInfo }

constructor TWaitRoom.Create;
begin
  waitManList:=TWaitWorkTrainmanInfoList.Create;
end;

destructor TWaitRoom.Destroy;
begin
  waitManList.Free;
  inherited;
end;



function TWaitRoom.GetFloorNum: string;
begin
  result := LeftStr(strRoomNum,1);
end;

{ RRSInOutRoomInfo }

procedure RRSInOutRoomInfo.SetValue(waitPlan: TWaitWorkPlan;
  trainman: RRsTrainman;dtNow:TDateTime; eVerifyType: TRsRegisterFlag;
  eInOutType: TInOutRoomType;dutyUser:TRsDutyUser;siteInfo:TRsSiteInfo);
begin
  strGUID := NewGUID;
  if waitPlan.ePlanType = TWWPT_ASSIGN then
    strTrainPlanGUID := waitPlan.strPlanGUID;

  strWaitPlanGUID:= waitPlan.strPlanGUID;
  dtInOutRoomTime:= dtNow;
  Self.eVerifyType :=eVerifyType;
  strDutyUserGUID:= dutyUser.strDutyGUID;
  strTrainmanGUID:=trainman.strTrainmanGUID;
  strTrainmanNumber:= trainman.strTrainmanNumber;
  strTrainmanName := trainman.strTrainmanName;
  dtCreatetTime :=dtNow;
  strSiteGUID :=siteInfo.strSiteGUID;
  strRoomNumber :=waitPlan.strRoomNum;
  dtArriveTime := waitPlan.dtWaitWorkTime;
  nBedNumber := 0;
  bUploaded:= False;
  eWaitPlanType:=waitPlan.ePlanType;
  eInOutType:=eInOutType;
end;

function RRSInOutRoomInfo.ToJsonStr(inOutType:TInOutRoomType): string;
var
  jso:ISuperObject;
begin
  jso  := so('{}');
  if inOutType = TInRoom then
  begin
    jso.S['strInRoomGUID'] := strGUID;
    jso.S['dtInRoomTime'] := TPubFun.dateTime2Str(dtInOutRoomTime)   ;
    jso.I['nInRoomVerifyID'] := ord(eVerifyType)   ;
  end;
  if inOutType = TOutRoom then
  begin
    jso.S['strInRoomGUID'] := self.strInRoomGUID;
    jso.S['strOutRoomGUID'] := strGUID;
    jso.S['dtOutRoomTime'] := TPubFun.dateTime2Str(dtInOutRoomTime)   ;
    jso.I['nOutRoomVerifyID'] := ord(eVerifyType)   ;
  end;
  jso.S['strTrainPlanGUID'] := strTrainPlanGUID;
  jso.S['strTrainmanNumber'] := strTrainmanNumber;
  jso.S['strTrainmanGUID'] := strTrainmanGUID ;
  jso.S['strDutyUserGUID'] := strDutyUserGUID   ;
  jso.S['strSiteGUID'] := strSiteGUID  ;
  jso.S['strRoomNumber'] := strRoomNumber  ;
  jso.I['nBedNumber'] := nBedNumber  ;
  jso.S['dtCreateTime'] := TPubFun.dateTime2Str(dtCreatetTime)  ;
  jso.S['strWaitPlanGUID'] := strWaitPlanGUID  ;
  jso.I['ePlanType']  := Ord(eWaitPlanType) ;
  jso.S['dtArriveTime'] := TPubFun.DateTime2Str(dtArriveTime);
  //jso.I['bUpLoaded'] := TPubFun.Bool2Int(bUploaded)  ;
  Result := jso.AsString;
  jso := nil;
end;

{ RWaitTime }

procedure RWaitTime.New;
begin
  strGUID := NewGUID();
  strWorkshopGUID:='';
  strWorkShopName:='';
  strTrainJiaoLuGUID:='';
  strTrainJiaoLuName:='';
  strTrainJiaoLuNickName:='';
  strTrainNo:='';
  strRoomNum:='';
  dtWaitTime:=0;
  dtCallTime:=0;
  dtChuQinTime:=0;
  dtKaiCheTime:=0;
end;

{ TRoomFloorList }

function TRoomFloorList.Add(AObject: TRoomFloor): Integer;
begin
  result := inherited Add(AObject);
end;

procedure TRoomFloorList.AddRoom(room: TWaitRoom);
var
  roomFloor:TRoomFloor;
begin
  roomFloor := self.FindFloor(room.FloorNum);
  if roomFloor <> nil then
  begin
    Inc(roomFloor.nTotalRoomNum);
    if room.waitManList.Count >0 then
    begin
      Inc(roomFloor.nInRoomNum);
    end;
  end;
end;

function TRoomFloorList.FindFloor(strFloorNum: string): TRoomFloor;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if self.Items[i].strFloorNum = strFloorNum then
    begin
      result := Self.Items[i];
      Break;
    end;
  end;
end;

function TRoomFloorList.FmtTotalFloorInfo: string;
begin
  result := Format('%s¥[%d/%d]',['����',self.GetTotalInRoomNum,self.GetTotalRoomNum]);
end;

function TRoomFloorList.GetTotalInRoomNum: Integer;
var
  i:Integer;
begin
  result := 0;
  for i := 0 to self.Count - 1 do
  begin
    result := result + self.Items[i].nInRoomNum;
  end;
end;

function TRoomFloorList.GetItem(Index: Integer): TRoomFloor;
begin
  result := TRoomFloor(inherited GetItem(Index));
end;

function TRoomFloorList.GetTotalRoomNum: Integer;
var
  i:Integer;
begin
  result := 0;
  for i := 0 to self.Count - 1 do
  begin
    result := result + self.Items[i].nTotalRoomNum;
  end;
end;

procedure TRoomFloorList.ResetRoomInfo;
var
  i:integer;
begin
  for i := 0 to self.Count - 1 do
  begin
    self.Items[i].nTotalRoomNum := 0;
    self.Items[i].nInRoomNum := 0;
  end;
end;

procedure TRoomFloorList.SetItem(Index: Integer; AObject: TRoomFloor);
begin
  inherited SetItem(Index,AObject);
end;

{ TRoomFloor }

function TRoomFloor.FmtFloorInfo: string;
begin
  result := Format('%s¥[%d/%d]',[Self.strFloorNum,self.nInRoomNum,self.nTotalRoomNum]);
end;

{ TInRoomWorkPlan }

procedure TInRoomWorkPlan.Clear;
begin
    strPlanGUID:= '';
    //����
    strCheCi:= '' ;
    //�����
    strRoomNum:= '';
    //���ʱ��
    dtWaitWorkTime:= 0;
    //�а�ʱ��
    dtCallWorkTime:= 0 ;
    //����
    ePlanType:=TWWPT_LOCAL;
    //��Ҫͬ���а�
    bNeedSyncCall:= false ;
    bNeedRest:= false ;
    //��Ա�ƻ��б�
    FillChar(Trainman,SizeOf(RRsTrainman),0);
    //��������
    JoinRoomList.Clear;
end;

constructor TInRoomWorkPlan.Create;
begin
  JoinRoomList := TStringList.Create;
end;

destructor TInRoomWorkPlan.Destroy;
begin
  JoinRoomList.Free;
  inherited;
end;

end.
