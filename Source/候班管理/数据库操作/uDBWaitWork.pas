unit uDBWaitWork;

interface
uses
  Classes,SysUtils,uTFSystem,ADODB,uWaitWork,uSaftyEnum,Variants;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBSyncPlanID
  /// ����:��ͬ���ƻ�ID���ݿ����
  //////////////////////////////////////////////////////////////////////////////
  TDBSyncPlanID = class(TDBOperate)
    {����:����}
    procedure Add(planIDInfo:TSyncPlanIDInfo);
    {����:ɾ��}
    procedure Del(strPlanGUID:string);
    {����:��ȡ����δͬ���ƻ�}
    procedure GetAllUnDone(planIDList:TSyncPlanIDInfoList);
  end;
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBWaitTime
  /// ����:���ʱ��
  //////////////////////////////////////////////////////////////////////////////
  TDBWaitTime = class(TDBOperate)
  public
    {����:����}
    procedure Add(waitTime:RWaitTime);
    {����:�޸�}
    procedure Modify(waitTime:RWaitTime);
    {����:ɾ��}
    procedure Delete(strGUID:string);
    {����:ɾ������}
    procedure DelAll();
    {����:��ȡ����}
    procedure GetAll(out waitTimeAry:TWaitTimeAry);
    {����:����}
    function Find(strTrainNo:string;dtWaitTime,dtCallTime:TDateTime; out waitTime:RWaitTime):Boolean;
    {����:���ݳ��β���}
    function FindByTrainNo(strTrainNo:string ;out waitTime:RWaitTime):Boolean;
  private
    {����:���󵽼�¼��}
    procedure obj2Query(waitTime:RWaitTime;query:TADOQuery);
    {����:��¼��������}
    procedure Query2Obj(query:TADOQuery;out waitTime:RWaitTime);
  end;

  
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TRSDBInOutRoom
  /// ����:���������빫Ԣ
  //////////////////////////////////////////////////////////////////////////////
  TRSDBInOutRoom = class(TDBOperate)
  public
    {����:���ļƻ�ID}
    function ModifyWaitPlanGUID(OldPlanGUID,NewPlanGUID:string):boolean;
    {����:��ȡ��Ա�ƻ���Ԣ��¼}
    function GetTMInRoomInfo_TrainPlan(strTrainPlanGUID,strTrainmanGUID:string;out info:RRSInOutRoomInfo):Boolean;
    {����:��ȡ��Ա�ƻ���Ԣ��¼}
    function GetTMOutRoomInfo_TrainPlan(strTrainPlanGUID,strTrainmanGUID:string;out info:RRSInOutRoomInfo):Boolean;
     {����:��ȡ˾�����һ����Ԣ��¼}
    function SetTMLastInRoomTrainPlan(strTrainmanGUID,strTrainPlanGUID:string;
                dtSearchStart,dtSearchEnd:TDateTime):Boolean;
    {����:��ȡ˾�����һ�γ�Ԣ��¼}
    function SetTMLastOutRoomTrainPlan(strTrainmanGUID,strTrainPlanGUID:string;
                dtSearchStart,dtSearchEnd:TDateTime):Boolean;

    {����:��ȡ˾�����һ�ε���Ԣ����}
    function GetTMLastWaitRoom(strTrainmanGUID:string):string;

    {����:�޸���Ԣ��¼}
    function UpdateInRoom(InRoomInfo:RRsInOutRoomInfo):Boolean;
    {����:�޸���Ԣ��¼}
    function UpdateOutRoom(OutRoomInfo:RRSInOutRoomInfo):Boolean;
    {����:������Ԣ}
    procedure AddInRoom(InRoominfo:RRSInOutRoomInfo);
        {����:������Ԣ}
    procedure AddInRoom1(InRoominfo:RRSInOutRoomInfo);
    {����:���ӳ�Ԣ}
    procedure AddOutRoom(OutRoominfo:RRSInOutRoomInfo);
    {����:�޸���Ԣ}
    procedure ModifyInRoom(InRoominfo:RRSInOutRoomInfo);
    {����:�޸ĳ�Ԣ}
    procedure ModifyOutRoom(OutRoomInfo:RRSInOutRoomInfo);
    {����:��ȡ˾����Ԣ��Ϣ,���պ��ƻ�}
    function GetTMInRoomInfo_WaitPlan(strWaitPlanGUID, strTrainmanGUID:string;
          out inRoomInfo:RRSInOutRoomInfo) :Boolean;
    {����:��ȡ˾����Ԣ��Ϣ,���պ��ƻ�}
    function GetTMOutRoomInfo_WaitPlan(strWaitPlanGUID, strTrainmanGUID: string;
          out OutRoomInfo: RRSInOutRoomInfo):Boolean;

            {����:�ж��Ƿ��к��ƻ���Ԣ��¼}
    function bHaveInRoomInfo_WaitPlan(strWaitPlanGUID:string):Boolean;
    {����:�ж��Ƿ��к��ƻ���Ԣ��¼}
    function bHaveOutRoomInfo_WaitPlan(strWaitPlanGUID:string):Boolean;

    {����:��ȡδ�ϴ��빫Ԣ��Ϣ}
    function GetUnUploadInRoomInfo( out inRoomInfoArray:RRsInOutRoomInfoArray):Boolean;
    {����:��ȡδ�ϴ���Ԣ��Ϣ}
    function GetUnUplaodOutRoomInfo(out OutRoomInfoArray:RRsInOutRoomInfoArray):Boolean;
    //{����:�ж��Ƿ��г�Ԣ��Ԣ��¼}
    //function bGetInfo(strPlanGUID:string):Boolean;
  private
    {����:��Ԣ��Ϣ��query}
    procedure InRoom2Query(inRoomInfo:RRSInOutRoomInfo;query:TADOQuery);
    {����:����Ԣ��Ϣ��query}
    procedure OutRoom2Query(OutRoomInfo:RRSInOutRoomInfo;query:TADOQuery);
    {����:query ��ֵ����Ԣ��Ϣ}
    procedure Query2InRoom(query:TADOQuery;out inRoomInfo:RRSInOutRoomInfo);
    {����:query ��ֵ����Ԣ��Ϣ}
    procedure Query2OutRoom(Query:TADOQuery;out outRoomInfo:RRSInOutRoomInfo);

  end;


  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TDBWaitWorkTrainman
  ///  ˵��:���ƻ���Ա��Ϣ���ݿ����,�����׳��쳣
  //////////////////////////////////////////////////////////////////////////////
  TDBWaitWorkTrainman = class(TDBOperate)
  public
    {����:��ȡ��Ա��Ϣ}
    procedure GetTrainmanS(strPlanGUID:string;var tmList:TWaitWorkTrainmanInfoList);
    {����:������Ա��Ϣ}
    procedure Add(tmInfo:TWaitWorkTrainmanInfo);
    {����:�޸���Ա��Ϣ}
    procedure Modify(tmInfo:TWaitWorkTrainmanInfo);
    {����:�޸���Աλ����Ϣ}
    procedure ModityTMPos(tmInfo:TWaitWorkTrainmanInfo);
    {����:ɾ����Ա��Ϣ}
    procedure Del(strGUID: string);
    {����:ɾ���ƻ��е�������Ա��Ϣ}
    procedure DelByPlanID(strPlanGUID:string);
    {����:��ȡ�������Ա��ס��Ϣ}
    procedure GetRoomWaitMan(waitRoomList:TWaitRoomList);
    {����:��ȡ�������Ա��ס��Ϣ}
    procedure GetRoomWaitManWithJoin(waitRoomList:TWaitRoomList);
    {����:��ȡ�����û�еǼ���Ա��ס��Ϣ}
    procedure GetRoomNoSign(waitRoomList:TWaitRoomList);
    {����:���½а�״̬}
    procedure ModifyPlanState(planGUID,tmGUID:string;ePlanState:TRsPlanState;dtFirstCallTime:TDatetime;bCallSucess:Boolean);
  public
    {����:��Ա�ƻ�����ֵ��query}
    procedure Trainman2Query(trainman:TWaitWorkTrainmanInfo;query:TADOQuery);
    {����:query��ֵ����Ա�ƻ�����}
    procedure Query2Trainman(query:TADOQuery; Trainman:TWaitWorkTrainmanInfo;strIndex:string = '');

    {����:query��ֵ����Ա�ƻ�����}
    procedure Query2TrainmanJoinRoom(query:TADOQuery; Trainman:TWaitWorkTrainmanInfo;strIndex:string = '');
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TDBWaitWorkPlan
  ///  ˵��:���ƻ����ݿ����,�����׳��쳣
  //////////////////////////////////////////////////////////////////////////////
  TDBWaitWorkPlan = class(TDBOperate)
  public
    {����:����}
    procedure Add(plan:TWaitWorkPlan);
    {����:�޸�}
    procedure Modify(plan:TWaitWorkPlan);
    {����:�޸ļƻ�״̬}
    procedure ModifyPlanState(planGUID:string;ePlanState:TRsPlanState);
    {����:ɾ��}
    procedure Del(strPlanGUID:string);
    {����:���Ҽƻ�}
    function Find(strPlanGUID:string;plan:TWaitWorkPlan):Boolean;
    {����:��ȡ���мƻ�}
    //procedure GetAll(dtStart,dtEnd:TDateTime;var planList:TWaitWorkPlanList);
    {����:��ȡ������Ҫ��ʾ���˼ƻ�}
    procedure GetAllNeedShowPlan(var planList:TWaitWorkPlanList;dtStart,dtEnd:TDateTime;OrderByRoom:Boolean = True);
    {����:��ȡʱ�䷶Χ�ڵ����д��Ƽƻ�}
    procedure GetPlanS(var planList:TWaitWorkPlanList;dtStart,dtEnd:TDateTime);
    {����:��ȡ��Ҫ֪ͨ�а�ļƻ�}
    procedure GetNeedNotifyCallPlan(var PlanList:TWaitWorkPlanList);
    {����:���ýа���֪ͨ��־}
    procedure FinishNotifyCall(strPlanGUID:string);
    {����:��ȡ�ƻ�-��Ա-���빫Ԣ��Ϣ}
    procedure GetPlanManInOutRoom(dtStart,dtEnd:TDateTime;strWorkShopGUID,
      strTrainNo,strTrainManNumber:string;var PlanList:TWaitWorkPlanList;bOrderByCallTime:Boolean);
    {����:����δ��Ԣ����ʱ��}
    procedure UpdateNotifyUnLeaveTime(strPlanGUID: string;dtTime: TDateTime);
    {����:�鳭�˸������ε���һ�����ƻ�,���ýа��}
    function GetLastWaitPlan_ByTrainNo(strTrainNo:string;waitplan:TWaitWorkPlan):Boolean;
  private
    {����:�ƻ�����ֵ��query}
    procedure Plan2Query(plan:TWaitWorkPlan;query:TADOQuery);

    {����:query��ֵ���ƻ�����}
    procedure Query2Plan(query:TADOQuery;var Plan:TWaitWorkPlan);
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TDBRoomTrainmanRelation
  ///  ˵��:��Ա�����ϵ���ݿ����,�����׳��쳣
  //////////////////////////////////////////////////////////////////////////////
  TDBRoomTrainmanRelation = class(TDBOperate)
  public
    //��ѯĳ��
    function  QueryTrainmanRoomRelation(TrainmanNumber,TrainmanName:string;var RoomNumber:string):Boolean;
    //����Ƿ��Ѿ��з������Ա�Ĺ�ϵ
    function  IsHaveTrainmanRoomRelation(TrainmanGUID:string;out RoomNumber:string):Boolean;
    //����ָ����Ա�ķ�����Ϣ
    function  InsertTrainmanRoomRelation(RoomNumber:string;BedInfo:RRsBedInfo):Boolean;
    //ɾ��ָ����Ա�ķ�����Ϣ
    function  RemoveTrainmanRoomRelation(RoomNumber:string;BedInfo:RRsBedInfo):Boolean;
    //��ȡ���еķ������Ա�Ĺ���
    function  GetAllTrainmanRoomRelation(RoomNumber:string;var BedInfoArray:TRsBedInfoArray):Boolean;
   
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TDBInOutRoomRecord
  ///  ˵��:���빫Ԣ��¼���ݿ����,�����׳��쳣
  //////////////////////////////////////////////////////////////////////////////
 (* TDBInOutRoomEvent = class(TDBOperate)
  public
    {����:����}
    procedure Add(info:TInOutRoomInfo);
    {����:�޸�}
    procedure Modify(info:TInOutRoomInfo);
    {����:��ȡ���빫Ԣ��Ϣ,���ռƻ�}
    procedure GetInfo(strPlanGUID:string;var inOutRoomInfoList:TInOutRoomInfoList);overload ;
    {����:��ȡ���빫Ԣ��Ϣ,���ռƻ�����Ա}
    procedure GetInfo(strPlanGUID, strTrainmanGUID: string;
              eType:TInOutRoomType; var inOutRoomInfo: TInOutRoomInfo); overload ;
    {����:��ȡδ���빫Ԣ��Ϣ}
    procedure GetUnUploadInfo( var inOutRoomInfoList:TInOutRoomInfoList);
    {����:�ж��Ƿ��мƻ���¼}
    function bGetInfo(strPlanGUID:string):Boolean;
    {����:��¼��query}
    procedure obj2Query(info:TInOutRoomInfo;query:TADOQuery);
    {����:query����¼}
    procedure query2Obj(query:TADOQuery;info:TInOutRoomInfo);
  end;
  *)
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBWaitWorkRoom
  /// ����:���˷������ݿ����
  //////////////////////////////////////////////////////////////////////////////
  TDBWaitWorkRoom = class(TDBOperate)
  public
    {����:���ӷ���}
    procedure Add(Room:TWaitRoom);
    {����:ɾ������}
    procedure Del(strRoomNumber:string);
    {����:��ȡ���з���}
    procedure GetAll(RoomList:TWaitRoomList);
    {����:�жϷ����Ƿ����}
    function bExist(strRoomNum:string):Boolean;
  private
    {����:query��ֵ������}
    procedure Query2Obj(qry:TADOQuery;room:TWaitRoom);
    {����:����ֵ��query}
    procedure Obj2Qry(room:TWaitRoom;qry:TADOQuery);
  end;

implementation


procedure TRSDBInOutRoom.AddInRoom(InRoominfo: RRSInOutRoomInfo);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_InRoom where strInRoomGUID =:strInRoomGUID';
    qry.Parameters.ParamByName('strInRoomGUID').Value := InRoominfo.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;
    self.InRoom2Query(InRoominfo,qry);
    qry.Post;
  finally
    qry.Free;
  end;

end;

procedure TRSDBInOutRoom.AddInRoom1(InRoominfo: RRSInOutRoomInfo);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_InRoom where 1= 2';//where strInRoomGUID =:strInRoomGUID';
    //qry.Parameters.ParamByName('strInRoomGUID').Value := InRoominfo.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      ;
    self.InRoom2Query(InRoominfo,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TRSDBInOutRoom.AddOutRoom(OutRoominfo: RRSInOutRoomInfo);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_OutRoom where strOutRoomGUID =:strOutRoomGUID';
    qry.Parameters.ParamByName('strOutRoomGUID').Value := OutRoominfo.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then
      qry.Append
    else
      qry.Edit;
    self.OutRoom2Query(OutRoominfo,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.bHaveInRoomInfo_WaitPlan(
  strWaitPlanGUID: string): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select strInRoomGUID from tab_Plan_InRoom where '
      + 'strWaitPlanGUID =:strWaitPlanGUID';
    qry.Parameters.ParamByName('strWaitPlanGUID').Value := strWaitPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 Then Exit;
    result := True;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.bHaveOutRoomInfo_WaitPlan(
  strWaitPlanGUID: string): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select strOutRoomGUID from tab_Plan_OutRoom where '
      + 'strWaitPlanGUID =:strWaitPlanGUID';
    qry.Parameters.ParamByName('strWaitPlanGUID').Value := strWaitPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 Then Exit;
    result := True;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.GetTMInRoomInfo_TrainPlan(strTrainPlanGUID, strTrainmanGUID: string;
  out info: RRSInOutRoomInfo): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_InRoom where strTrainPlanGUID =:strTrainPlanGUID and '
      + ' strTrainmanGUID =:strTrainmanGUID';
    qry.Parameters.ParamByName('strTrainPlanGUID').Value := strTrainPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value :=strTrainmanGUID;
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    self.Query2InRoom(qry,info);
    result := True;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.GetTMInRoomInfo_WaitPlan(strWaitPlanGUID,
  strTrainmanGUID: string; out inRoomInfo: RRSInOutRoomInfo): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_InRoom where strWaitPlanGUID =:strWaitPlanGUID and '
      + ' strTrainmanGUID =:strTrainmanGUID';
    qry.Parameters.ParamByName('strWaitPlanGUID').Value := strWaitPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value :=strTrainmanGUID;
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    self.Query2InRoom(qry,inRoomInfo);
    result := True;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.GetTMLastWaitRoom(strTrainmanGUID: string): string;
var
  qry:TADOQuery;
begin
  result := '';
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select top 1 strRoomNumber from tab_plan_Inroom where strTrainmanGUID = :strTrainmanGUID'
      + ' order by  dtInRoomTime desc';
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID ;
    qry.Open;
    if qry.Eof then Exit;
    result := qry.FieldByName('strRoomNumber').Value;
  finally
    qry.Free;
  end;
  
end;

function TRSDBInOutRoom.SetTMLastInRoomTrainPlan(strTrainmanGUID,strTrainPlanGUID:string;
                dtSearchStart,dtSearchEnd:TDateTime): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select Top 1* from tab_plan_InRoom where strTrainmanGUID =:strTrainmanGUID'
      + ' and dtArriveTime >= :dtStart and dtArriveTime < :dtEnd order by dtInRoomTime desc';
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.Parameters.ParamByName('dtStart').Value :=dtSearchStart;
    qry.Parameters.ParamByName('dtEnd').Value :=dtSearchEnd;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    qry.FieldByName('strTrainPlan').Value := strTrainPlanGUID;
    qry.Post;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.SetTMLastOutRoomTrainPlan(strTrainmanGUID,strTrainPlanGUID:string;
                dtSearchStart,dtSearchEnd:TDateTime):Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select Top 1* from tab_plan_OutRoom where strTrainmanGUID =:strTrainmanGUID'
      + ' and dtArriveTime >= :dtStart and dtArriveTime < :dtEnd  order by dtOutRoomTime desc';
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.Parameters.ParamByName('dtStart').Value :=dtSearchStart;
    qry.Parameters.ParamByName('dtEnd').Value :=dtSearchEnd;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    qry.FieldByName('strTrainPlan').Value := strTrainPlanGUID;
    qry.Post;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.GetTMOutRoomInfo_TrainPlan(strTrainPlanGUID, strTrainmanGUID: string;
  out info: RRSInOutRoomInfo): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_OutRoom where strTrainPlanGUID =:strTrainPlanGUID and '
      + ' strTrainmanGUID =:strTrainmanGUID';
    qry.Parameters.ParamByName('strTrainPlanGUID').Value := strTrainPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value :=strTrainmanGUID;
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    self.Query2OutRoom(qry,info);
    result := True;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.GetTMOutRoomInfo_WaitPlan(strWaitPlanGUID,
  strTrainmanGUID: string; out OutRoomInfo: RRSInOutRoomInfo): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_OutRoom where strWaitPlanGUID =:strWaitPlanGUID and '
      + ' strTrainmanGUID =:strTrainmanGUID';
    qry.Parameters.ParamByName('strWaitPlanGUID').Value := strWaitPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value :=strTrainmanGUID;
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    self.Query2OutRoom(qry,OutRoomInfo);
    result := True;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.GetUnUplaodOutRoomInfo(
  out OutRoomInfoArray: RRsInOutRoomInfoArray): Boolean;
var
  qry:TADOQuery;
  i:Integer;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_OutRoom where bOutUploaded =0';
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    SetLength(OutRoomInfoArray,qry.RecordCount);
    for i := 0 to qry.RecordCount- 1 do
    begin
      self.Query2OutRoom(qry,OutRoomInfoArray[i]);
      qry.Next;
    end;
    result := True;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.GetUnUploadInRoomInfo(
  out inRoomInfoArray: RRsInOutRoomInfoArray): Boolean;
var
  qry:TADOQuery;
  i:Integer;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_InRoom where bInUploaded =0';
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    SetLength(inRoomInfoArray,qry.RecordCount);
    for i := 0 to qry.RecordCount- 1 do
    begin
      self.Query2InRoom(qry,inRoomInfoArray[i]);
      qry.Next;
    end;
    result := True;
  finally
    qry.Free;
  end;
end;

procedure TRSDBInOutRoom.InRoom2Query(inRoomInfo: RRSInOutRoomInfo;
  query: TADOQuery);
begin
  query.FieldByName('strInRoomGUID').Value := inRoomInfo.strGUID;
  query.FieldByName('strWaitPlanGUID').Value := inRoomInfo.strWaitPlanGUID  ;
  query.FieldByName('strTrainPlanGUID').Value := inRoomInfo.strTrainPlanGUID;
  query.FieldByName('strTrainmanGUID').Value := inRoomInfo.strTrainmanGUID ;
  query.FieldByName('strTrainmanNumber').value := inRoomInfo.strTrainmanNumber;
  query.FieldByName('strTrainmanName').value := inRoomInfo.strTrainmanName;
  query.FieldByName('dtInRoomTime').Value := inRoomInfo.dtInOutRoomTime   ;
  query.FieldByName('nInRoomVerifyID').Value := Ord(inRoomInfo.eVerifyType)   ;
  query.FieldByName('strInDutyUserGUID').Value := inRoomInfo.strDutyUserGUID   ;
  query.FieldByName('strSiteGUID').Value := inRoomInfo.strSiteGUID  ;
  query.FieldByName('strRoomNumber').Value := inRoomInfo.strRoomNumber  ;
  query.FieldByName('nBedNumber').Value := inRoomInfo.nBedNumber  ;
  query.FieldByName('dtInCreateTime').Value := inRoomInfo.dtCreatetTime  ;

  query.FieldByName('eInPlanType').Value := Ord(inRoomInfo.eWaitPlanType)  ;
  query.FieldByName('dtArriveTime').Value := inRoomInfo.dtArriveTime  ;
  if Assigned(query.FindField('bInUploaded')) then
    query.FieldByName('bInUploaded').Value := inRoomInfo.bUploaded  ;

end;

procedure TRSDBInOutRoom.ModifyInRoom(InRoominfo: RRSInOutRoomInfo);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_InRoom where strInRoomGUID =:strInRoomGUID';
    qry.Parameters.ParamByName('strInRoomGUID').Value := InRoominfo.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    self.InRoom2Query(InRoominfo,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TRSDBInOutRoom.ModifyOutRoom(OutRoomInfo: RRSInOutRoomInfo);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_OutRoom where strOutRoomGUID =:strOutRoomGUID';
    qry.Parameters.ParamByName('strOutRoomGUID').Value := OutRoomInfo.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    self.OutRoom2Query(OutRoomInfo,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.ModifyWaitPlanGUID(OldPlanGUID,
  NewPlanGUID: string): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Plan_InRoom set strWaitPlanGUID = %s where strWaitPlanGUID = %s';
      strSql := Format(strSql,[QuotedStr(NewPlanGUID),QuotedStr(OldPlanGUID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRSDBInOutRoom.OutRoom2Query(OutRoomInfo: RRSInOutRoomInfo;
  query: TADOQuery);
begin
  query.FieldByName('strOutRoomGUID').Value := OutRoomInfo.strGUID;
  query.FieldByName('strWaitPlanGUID').Value := OutRoomInfo.strWaitPlanGUID  ;
  query.FieldByName('strTrainPlanGUID').Value := OutRoomInfo.strTrainPlanGUID;
  query.FieldByName('strTrainmanGUID').Value := OutRoomInfo.strTrainmanGUID ;
  query.FieldByName('strTrainmanNumber').value := OutRoomInfo.strTrainmanNumber;
  query.FieldByName('strTrainmanName').value := OutRoomInfo.strTrainmanName;
  query.FieldByName('dtOutRoomTime').Value := OutRoomInfo.dtInOutRoomTime   ;
  query.FieldByName('nOutRoomVerifyID').Value := Ord(OutRoomInfo.eVerifyType)   ;
  query.FieldByName('strOutDutyUserGUID').Value := OutRoomInfo.strDutyUserGUID   ;
  query.FieldByName('strSiteGUID').Value := OutRoomInfo.strSiteGUID  ;
  query.FieldByName('strRoomNumber').Value := OutRoomInfo.strRoomNumber  ;
  query.FieldByName('nBedNumber').Value := OutRoomInfo.nBedNumber  ;
  query.FieldByName('dtOutCreateTime').Value := OutRoomInfo.dtCreatetTime  ;

  query.FieldByName('eOutPlanType').Value := Ord(OutRoomInfo.eWaitPlanType)  ;
  query.FieldByName('dtArriveTime').Value := OutRoomInfo.dtArriveTime  ;
  if Assigned(query.FindField('bOutUpLoaded')) then
    query.FieldByName('bOutUpLoaded').Value := OutRoomInfo.bUploaded  ;
  query.FieldByName('strInRoomGUID').Value := OutRoomInfo.strInRoomGUID;
end;

procedure TRSDBInOutRoom.Query2InRoom(query: TADOQuery;
  out inRoomInfo: RRSInOutRoomInfo);
begin
  inRoomInfo.eInOutType := TInRoom;
  inRoomInfo.strGUID := query.FieldByName('strInRoomGUID').Value;
  inRoomInfo.strWaitPlanGUID := query.FieldByName('strWaitPlanGUID').Value  ;
  inRoomInfo.strTrainPlanGUID := query.FieldByName('strTrainPlanGUID').Value;
  inRoomInfo.strTrainmanGUID := query.FieldByName('strTrainmanGUID').Value ;
  inRoomInfo.strTrainmanNumber := query.FieldByName('strTrainmanNumber').value;
  inRoomInfo.strTrainmanName := query.FieldByName('strTrainmanName').value;
  inRoomInfo.dtInOutRoomTime := query.FieldByName('dtInRoomTime').Value   ;
  inRoomInfo.eVerifyType := TRsRegisterFlag(query.FieldByName('nInRoomVerifyID').Value)   ;
  inRoomInfo.strDutyUserGUID := query.FieldByName('strInDutyUserGUID').Value   ;
  inRoomInfo.strSiteGUID := query.FieldByName('strSiteGUID').Value  ;
  inRoomInfo.strRoomNumber := query.FieldByName('strRoomNumber').Value  ;
  inRoomInfo.nBedNumber := query.FieldByName('nBedNumber').Value  ;
  inRoomInfo.dtCreatetTime := query.FieldByName('dtInCreateTime').Value  ;

  inRoomInfo.eWaitPlanType := TWaitWorkPlanType(query.FieldByName('eInPlanType').Value ) ;
  inRoomInfo.dtArriveTime := query.FieldByName('dtArriveTime').Value  ;
  if Assigned(query.FindField('bInUploaded')) then
    inRoomInfo.bUploaded := query.FieldByName('bInUploaded').Value  ;
end;

procedure TRSDBInOutRoom.Query2OutRoom(Query: TADOQuery;
  out outRoomInfo: RRSInOutRoomInfo);
begin
  outRoomInfo.eInOutType := TOutRoom;
  OutRoomInfo.strGUID := query.FieldByName('strOutRoomGUID').Value;
  outRoomInfo.strInRoomGUID := query.FieldByName('strInRoomGUID').value;
  OutRoomInfo.strWaitPlanGUID := query.FieldByName('strWaitPlanGUID').Value  ;
  OutRoomInfo.strTrainPlanGUID := query.FieldByName('strTrainPlanGUID').Value;
  OutRoomInfo.strTrainmanGUID := query.FieldByName('strTrainmanGUID').Value ;
  OutRoomInfo.strTrainmanNumber := query.FieldByName('strTrainmanNumber').value;
  OutRoomInfo.strTrainmanName := query.FieldByName('strTrainmanName').value;
  OutRoomInfo.dtInOutRoomTime := query.FieldByName('dtOutRoomTime').Value   ;
  OutRoomInfo.eVerifyType := TRsRegisterFlag(query.FieldByName('nOutRoomVerifyID').Value)   ;
  OutRoomInfo.strDutyUserGUID := query.FieldByName('strOutDutyUserGUID').Value   ;
  OutRoomInfo.strSiteGUID := query.FieldByName('strSiteGUID').Value  ;
  OutRoomInfo.strRoomNumber := query.FieldByName('strRoomNumber').Value  ;
  OutRoomInfo.nBedNumber := query.FieldByName('nBedNumber').Value  ;
  OutRoomInfo.dtCreatetTime := query.FieldByName('dtOutCreateTime').Value  ;

  OutRoomInfo.eWaitPlanType := TWaitWorkPlanType(query.FieldByName('eOutPlanType').Value)  ;
  OutRoomInfo.dtArriveTime := query.FieldByName('dtArriveTime').Value  ;
  if Assigned(query.FindField('bOutUpLoaded')) then
    OutRoomInfo.bUploaded := query.FieldByName('bOutUpLoaded').Value  ;
end;

function TRSDBInOutRoom.UpdateInRoom(InRoomInfo: RRsInOutRoomInfo): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_InRoom where strInRoomGUID =:strInRoomGUID' ;
    qry.Parameters.ParamByName('strInRoomGUID').Value := InRoomInfo.strGUID;
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    qry.Edit;
    self.InRoom2Query(InRoomInfo,qry);
    qry.Post ;
    result := True;
  finally
    qry.Free;
  end;
end;

function TRSDBInOutRoom.UpdateOutRoom(OutRoomInfo: RRSInOutRoomInfo): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_OutRoom where strOutRoomGUID =:strOutRoomGUID' ;
    qry.Parameters.ParamByName('strOutRoomGUID').Value := OutRoomInfo.strGUID;
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    qry.Edit;
    self.InRoom2Query(OutRoomInfo,qry);
    qry.Post ;
    result := True;
  finally
    qry.Free;
  end;
end;

{ TDBWaitWorkPlan }

procedure TDBWaitWorkPlan.Add(plan: TWaitWorkPlan);
var
  queryMain:TADOQuery;
begin
  queryMain := NewADOQuery;
  try
    queryMain.SQL.Text := 'select * from tab_Plan_waitwork where strPlanGUID=:strPlanGUID';
    queryMain.Parameters.ParamByName('strPlanGUID').Value := plan.strPlanGUID;
    queryMain.Open;
    if queryMain.RecordCount = 0 then
    begin
      queryMain.Append;
    end
    else
    begin
      queryMain.Edit;
    end;
    self.Plan2Query(plan,queryMain);
    queryMain.Post;
  finally
    queryMain.Free;
  end;
end;

procedure TDBWaitWorkPlan.Del(strPlanGUID: string);
var
  queryMain:TADOQuery;
  nResult:Integer;
begin
  queryMain:= NewADOQuery;
  try
      queryMain.SQL.Text := 'delete from tab_Plan_waitwork where strPlanGUID=:strPlanGUID';
      queryMain.Parameters.ParamByName('strPlanGUID').Value := strPlanGUID;
      nResult := queryMain.ExecSQL;
  finally
    queryMain.Free;
  end;
end;
 {
procedure TDBWaitWorkPlan.GetAll(dtStart, dtEnd: TDateTime;
  var planList: TWaitWorkPlanList);
var
  queryMain:TADOQuery;
  plan:TWaitWorkPlan;
begin
  queryMain:= NewADOQuery;
  try
    queryMain.SQL.Text := 'select * from tab_Plan_waitwork where '
      + 'dtWaitWorkTime >=:dtStart and dtWaitWorkTime <:dtEnd';
    queryMain.Parameters.ParamByName('dtStart').Value := dtStart;
    queryMain.Parameters.ParamByName('dtEnd').Value := dtEnd;
    queryMain.Open;
    while not queryMain.Eof do
    begin
      plan:=TWaitWorkPlan.Create;
      Self.Query2Plan(queryMain,plan);
      planList.Add(plan);
      queryMain.Next;
    end;
  finally
    queryMain.Free;
  end;

end;
 }

procedure TDBWaitWorkPlan.GetAllNeedShowPlan(var planList:TWaitWorkPlanList;dtStart,dtEnd:TDateTime;OrderByRoom:Boolean = True);
var
  query:TADOQuery;
  plan:TWaitWorkPlan;
  waitTM:TWaitWorkTrainmanInfo;
  dbTrainman:TDBWaitWorkTrainman;
  dbInOutRoom : TRSDBInOutRoom;
begin
  query := NewADOQuery;
  dbTrainman := TDBWaitWorkTrainman.Create(GetADOConnection);
  dbInOutRoom := TRSDBInOutRoom.Create(GetADOConnection);
  try
    if OrderByRoom  then
    begin
//      query.SQL.Text := 'select * from view_PlanInOutRoom where '
//        + ' ePlanState <:ePlanState '
//        + ' order by strCheJianGUID, strRoomNum asc,eTrainmanState desc,ID asc';
        query.SQL.Text := 'select * from view_PlanInOutRoom where '
          + ' ePlanState <:ePlanState '
          + ' order by strCheJianGUID, strRoomNum asc,nTrainmanIndex asc';
    end
    else
    begin
   { query.SQL.Text := 'select * from VIEW_PLAN_WAITMAN where '
      + ' dtWaitWorkTime < :dtEnd and ePlanState < :ePlanState '
      + ' order by ePlanType asc, ePlanState asc, eTrainmanState desc, dtWaitWorkTime asc';  }
//    query.SQL.Text := 'select * from view_PlanInOutRoom where '
//      + ' ePlanState < :ePlanState '
//      + ' order by ePlanType asc,dtCallWorkTime asc, ePlanState asc, eTrainmanState desc ';
    query.SQL.Text := 'select * from view_PlanInOutRoom where '
      + ' ePlanState < :ePlanState '
      + ' order by ePlanType asc,dtCallWorkTime asc, ePlanState asc, nTrainmanIndex asc,ISNULL(dtInRoomTime,''2099-12-31'')  asc ';
      //+ ' order by  dtCallWorkTime asc, dtInRoomTime asc ' ;
      //+ ' order by ePlanType asc,dtCallWorkTime asc, ePlanState asc, dtInRoomTime asc ,nTrainmanIndex asc';
      //+ ' order by ePlanType asc, dtCallWorkTime asc, dtInRoomTime asc,  ePlanState asc, nTrainmanIndex asc '   ;
      //+ ' order by ePlanType asc,dtCallWorkTime asc, ePlanState asc, nTrainmanIndex asc ';
    end;

    

    query.Parameters.ParamByName('ePlanState').Value := psOutRoom;//���뿪��Ԣ
    query.Open;
    while not query.Eof do
    begin
      plan := planList.Find(query.FieldByName('strPlanGUID').Value);
      if plan = nil then
      begin
        plan := TWaitWorkPlan.Create;
        planList.Add(plan);
        self.Query2Plan(query,plan);
      end;
      waitTM := TWaitWorkTrainmanInfo.Create;
      dbTrainman.Query2Trainman(query,waitTM);
      plan.tmPlanList.Add(waitTM);

      if  query.FieldByName('strInRoomGUID').IsNull then
      begin
        query.Next;
        Continue;
      end;
      dbInOutRoom.Query2InRoom(query,waitTM.InRoomInfo);
      if query.FieldByName('strOutRoomGUID').IsNull then
      begin
        query.Next;
        Continue;
      end;
      dbInOutRoom.Query2OutRoom(query,waitTM.OutRoomInfo);
      query.Next;
    end;
  finally
    query.Free;
    dbTrainman.Free;
    dbInOutRoom.Free;
  end;
end;
function TDBWaitWorkPlan.GetLastWaitPlan_ByTrainNo(strTrainNo: string;
  waitplan: TWaitWorkPlan): Boolean;
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select top 1 * from tab_Plan_WaitWork where strCheci = :strCheci '
      + ' and bNeedSyncCall =:bNeedSyncCall and dtCallWorkTime >=:dtCallWorkTime order by dtcallWorkTime desc';
    qry.Parameters.ParamByName('strCheci').Value := strTrainNo;
    qry.Parameters.ParamByName('bNeedSyncCall').Value := true ;
    qry.Parameters.ParamByName('dtCallWorkTime').Value := now - 2 ;
    qry.Open;
    if qry.RecordCount = 0 then Exit;

    self.Query2Plan(qry,waitplan);
    result := true;
  finally
    qry.Free;
  end;
  
end;

(*
procedure TDBWaitWorkPlan.GetAllNeedShowPlan(var planList:TWaitWorkPlanList;dtStart,dtEnd:TDateTime);
var
  query:TADOQuery;
  plan:TWaitWorkPlan;
begin
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_plan_WaitWork as a '
      + ' tab_Plan_WaitWork_Trainman as b '
      + ' where a.strPlanGUID = b.strPlanGUID and '
      + '(( a.dtWaitWorkTime >= :dtStart and a.dtWaitWorkTime < :dtEnd) or a.ePlanState <:ePlanState) '
      + ' order by dtWaitWorkTime asc';


    {query.SQL.Text := 'select * from tab_Plan_WaitWork where '
      +' (bDone = False and dtWaitWorkTime <:dtSplitTime) or '
      +' (dtWaitWorkTime >=:dtSplitTime)';
    }
    query.SQL.Text := 'select * from tab_Plan_WaitWork where '
      +' (ePlanState < :ePlanState and dtWaitWorkTime <:dtSplitTime) order by dtWaitWorkTime asc';
    query.Parameters.ParamByName('ePlanState').Value := psOutRoom;//���뿪��Ԣ
    query.Parameters.ParamByName('dtSplitTime').Value := dtSplitTime;
    query.Open;
    while not query.Eof do
    begin
      plan := TWaitWorkPlan.Create;
      self.Query2Plan(query,plan);
      planList.Add(plan);
      query.Next;
    end;

    query.SQL.Text := 'select * from tab_Plan_WaitWork where '
      +' dtWaitWorkTime >=:dtSplitTime order by dtWaitWorkTime asc';
    query.Parameters.ParamByName('dtSplitTime').Value := dtSplitTime;
    query.Open;
    while not query.Eof do
    begin
      plan := TWaitWorkPlan.Create;
      self.Query2Plan(query,plan);
      planList.Add(plan);
      query.Next;
    end;

  finally
    query.Free;
  end;
end;
     *)


procedure TDBWaitWorkPlan.GetNeedNotifyCallPlan(var PlanList: TWaitWorkPlanList);
var
  qry:TADOQuery;
  plan:TWaitWorkPlan;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_waitwork where bNeedSyncCall = True';
    qry.Open;
    while not qry.Eof do
    begin
      plan:=TWaitWorkPlan.Create;
      self.Query2Plan(qry,plan);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitWorkPlan.GetPlanManInOutRoom(dtStart,dtEnd:TDateTime;strWorkShopGUID,
      strTrainNo,strTrainManNumber:string;var PlanList:TWaitWorkPlanList;bOrderByCallTime:Boolean);
var
  dbWaitMan:TDBWaitWorkTrainman;
  dbInOutRoom:TRSDBInOutRoom;
  qry:TADOQuery;
  plan:TWaitWorkPlan;
  man:TWaitWorkTrainmanInfo;
  strSql:string;
begin
  dbWaitMan := TDBWaitWorkTrainman.Create(GetADOConnection);
  dbInOutRoom := TRSDBInOutRoom.Create(GetADOConnection);
  qry := NewADOQuery;
  try
    strSql:= 'select * from view_PlanInOutRoom where ';
    if bOrderByCallTime = False then
      strSql := strSql + ' dtWaitWorkTime >=:dtStart  and dtWaitWorkTime <:dtEnd ';
    if bOrderByCallTime then
      strSql := strSql + ' dtCallWorkTime >=:dtStart  and dtCallWorkTime <:dtEnd ';
    if strWorkShopGUID <> '' then
      strSql := strSql +'and strCheJianGUID =:strCheJianGUID ';
    if strTrainNo <> '' then
      strSql := strSql +'and strCheCi =:strTrainNo ';
    if strTrainManNumber <> '' then
      strSql := strSql +'and strTrainmanNumber =:strTrainmanNumber ';
    if bOrderByCallTime then
      strSql := strSql+ ' order by ePlanType asc,strCheJianGUID asc, dtCallWorkTime asc, strTrainJiaoLuGUID asc'
    else
      strSql := strSql+ ' order by strCheJianGUID asc,strTrainJiaoLuGUID asc, ePlanType asc,  strRoomNum asc';
    qry.SQL.Text := strSql;
    qry.Parameters.ParamByName('dtStart').Value := dtStart;
    qry.Parameters.ParamByName('dtEnd').Value := dtEnd;
    if strWorkShopGUID <> '' then
      qry.Parameters.ParamByName('strCheJianGUID').Value := strWorkShopGUID;
    if strTrainNo <> '' then
      qry.Parameters.ParamByName('strTrainNo').Value := strTrainNo;
    if strTrainManNumber <> '' then
      qry.Parameters.ParamByName('strTrainManNumber').Value := strTrainManNumber;
    qry.Open;
    while not qry.Eof do
    begin
      plan :=PlanList.Find(qry.FieldByName('strPlanGUID').Value);
      if plan = nil then
      begin
        plan := TWaitWorkPlan.Create;
        Self.Query2Plan(qry,plan);
        PlanList.Add(plan);
      end;
      if qry.FieldByName('strTrainmanGUID').Value = '' then
      begin
        qry.Next;
        Continue;
      end;

      man := plan.tmPlanList.findTrainman(qry.FieldByName('strTrainmanGUID').Value);
      if man = nil then
      begin
        man := TWaitWorkTrainmanInfo.Create;
        dbWaitMan.Query2Trainman(qry,man);
        plan.tmPlanList.Add(man);
      end;
      if  qry.FieldByName('strInRoomGUID').IsNull then
      begin
        qry.Next;
        Continue;
      end;
      dbInOutRoom.Query2InRoom(qry,man.InRoomInfo);
      if qry.FieldByName('strOutRoomGUID').IsNull then
      begin
        qry.Next;
        Continue;
      end;
      dbInOutRoom.Query2OutRoom(qry,man.OutRoomInfo);
      qry.Next;
    end;
  finally
    dbWaitMan.Free;
    dbInOutRoom.Free;
    qry.Free;
  end;
end;

procedure TDBWaitWorkPlan.GetPlanS(var planList: TWaitWorkPlanList; dtStart,
  dtEnd: TDateTime);
var
  query:TADOQuery;
  plan:TWaitWorkPlan;
  waitTM:TWaitWorkTrainmanInfo;
  dbTrainman:TDBWaitWorkTrainman;
begin
  query := NewADOQuery;
  dbTrainman := TDBWaitWorkTrainman.Create(GetADOConnection);
  try
    {query.SQL.Text := 'select * from VIEW_PLAN_WAITMAN where '
      + ' (dtWaitWorkTime >=:dtStart  or  ePlanState <:ePlanState) and dtWaitWorkTime < :dtEnd '
      + ' order by strRoomNum asc';
    }
   { query.SQL.Text := 'select * from VIEW_PLAN_WAITMAN where '
      + ' dtWaitWorkTime >=:dtStart and dtWaitWorkTime < :dtEnd '
      + ' order by strRoomNum asc';   }
    query.SQL.Text := 'select * from VIEW_PLAN_WAITMAN where '
        + ' ePlanState <=:ePlanState '
        + ' order by strCheJianGUID, strRoomNum asc';
    query.Parameters.ParamByName('ePlanState').Value := psReCall;//���뿪��Ԣ
    //query.Parameters.ParamByName('dtEnd').Value := dtEnd;
    //query.Parameters.ParamByName('dtStart').Value := dtStart;
    query.Open;
    while not query.Eof do
    begin
      plan := planList.Find(query.FieldByName('strPlanGUID').Value);
      if plan = nil then
      begin
        plan := TWaitWorkPlan.Create;
        planList.Add(plan);
        self.Query2Plan(query,plan);
      end;
      waitTM := TWaitWorkTrainmanInfo.Create;
      dbTrainman.Query2Trainman(query,waitTM);
      plan.tmPlanList.Add(waitTM);
      
      query.Next;
    end;
  finally
    query.Free;
    dbTrainman.Free;
  end;
end;

procedure TDBWaitWorkPlan.modify(plan: TWaitWorkPlan);
var
  queryMain:TADOQuery;
begin
  queryMain := NewADOQuery;
  try
    queryMain.SQL.Text := 'select * from tab_Plan_waitwork where strPlanGUID =:strPlanGUID';
    queryMain.Parameters.ParamByName('strPlanGUID').Value := plan.strPlanGUID;
    queryMain.Open;
    if queryMain.RecordCount =0 then Exit;
    queryMain.Edit;
    self.Plan2Query(plan,queryMain);
    queryMain.Post;
  finally
    queryMain.Free;
  end;
end;


procedure TDBWaitWorkPlan.ModifyPlanState(planGUID: string;
  ePlanState: TRsPlanState);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text   := 'update TAB_Plan_Waitwork set ePlanState = :ePlanState '
      + ' where strPlanGUID = :strPlanGUID';
    qry.Parameters.ParamByName('ePlanState').Value := Ord(ePlanState);
    qry.Parameters.ParamByName('strPlanGUID').Value := planGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitWorkPlan.Plan2Query(plan: TWaitWorkPlan; query: TADOQuery);
begin
  query.FieldByName('strPlanGUID').Value := plan.strPlanGUID;
  query.FieldByName('strCheJianGUID').Value :=plan.strCheJianGUID;
  query.FieldByName('strCheJianName').Value :=plan.strCheJianName;
  query.FieldByName('strTrainJiaoLuGUID').Value :=plan.strTrainJiaoLuGUID;
  query.FieldByName('strTrainJiaoLuName').Value :=plan.strTrainJiaoLuName;
  query.FieldByName('strTrainJiaoLuNickName').Value := plan.strTrainJiaoLuNickName;
  query.FieldByName('strSignPlanGUID').Value := plan.strSignPlanGUID;
  query.FieldByName('strCheCi').Value := plan.strCheCi;
  if query.FieldByName('strRoomNum').IsNull then //���ݿ��¼Ϊ��
    query.FieldByName('strRoomNum').Value := plan.strRoomNum
  else
  begin
    if (plan.strRoomNum <> '') then
      query.FieldByName('strRoomNum').Value := plan.strRoomNum;
  end;

  query.FieldByName('dtWaitWorkTime').Value := plan.dtWaitWorkTime;
  query.FieldByName('dtCallWorkTime').Value := plan.dtCallWorkTime;
  query.FieldByName('ePlanType').Value := Ord(plan.ePlanType);
  query.FieldByName('ePlanState').value := plan.ePlanState;
  query.FieldByName('bNeedSyncCall').value := plan.bNeedSyncCall;
  query.FieldByName('bNeedRest').value := plan.bNeedRest;
  query.FieldByName('dtNotifyUnLeaveTime').value := plan.dtNotifyUnLeaveTime;
  query.FieldByName('strJoinRooms').Value := plan.JoinRoomList.CommaText ;
  //query.FieldByName('eCallState').Value := ord(plan.eCallState);
end;

procedure TDBWaitWorkPlan.Query2Plan(query: TADOQuery; var Plan: TWaitWorkPlan);
begin
  plan.strCheJianGUID :=query.FieldByName('strCheJianGUID').Value;
  plan.strCheJianName :=query.FieldByName('strCheJianName').Value;
  plan.strTrainJiaoLuGUID :=query.FieldByName('strTrainJiaoLuGUID').Value;
  plan.strTrainJiaoLuName :=query.FieldByName('strTrainJiaoLuName').Value;
  plan.strTrainJiaoLuNickName := query.FieldByName('strTrainJiaoLuNickName').Value;

  plan.strPlanGUID:= query.FieldByName('strPlanGUID').Value;
  plan.strSignPlanGUID := query.FieldByName('strSignPlanGUID').Value;
  Plan.strCheCi := query.FieldByName('strCheCi').Value;
  plan.strRoomNum:= query.FieldByName('strRoomNum').Value;
  plan.dtWaitWorkTime :=query.FieldByName('dtWaitWorkTime').Value ;
  plan.dtCallWorkTime :=query.FieldByName('dtCallWorkTime').Value ;


  if VarIsNull(query.FieldByName('ePlanType').value)  then
    plan.ePlanType := TWWPT_LOCAL
  else
    plan.ePlanType := TWaitWorkPlanType(query.FieldByName('ePlanType').Value);

  if VarIsNull(query.FieldByName('ePlanState').value)  then
    Plan.ePlanState :=  psPublish
  else
    Plan.ePlanState :=TRsPlanState(query.FieldByName('ePlanState').Value);

  if VarIsNull(query.FieldByName('bNeedSyncCall').value)  then
    plan.bNeedSyncCall := False
  else
    plan.bNeedSyncCall :=query.FieldByName('bNeedSyncCall').Value ;


  if VarIsNull(query.FieldByName('bNeedRest').value)  then
    plan.bNeedRest := True
  else
    plan.bNeedRest := query.FieldByName('bNeedRest').value;

  plan.dtNotifyUnLeaveTime := query.FieldByName('dtNotifyUnLeaveTime').value ;
  //plan.eCallState:= TRoomCallState(query.FieldByName('eCallState').Value)  ;

  if not VarIsNull(query.FieldByName('strJoinRooms').value)  then
    plan.JoinRoomList.CommaText := query.FieldByName('strJoinRooms').Value ;
end;

procedure TDBWaitWorkPlan.UpdateNotifyUnLeaveTime(strPlanGUID: string;
  dtTime: TDateTime);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'update   tab_Plan_WaitWork set dtNotifyUnLeaveTime = :dtNotifyUnLeaveTime where strPlanGUID = :strPlanGUID';
    qry.Parameters.ParamByName('strPlanGUID').Value :=  strPlanGUID;
    qry.Parameters.ParamByName('dtNotifyUnLeaveTime').Value :=  dtTime;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

function TDBWaitWorkPlan.Find(strPlanGUID: string;
  plan: TWaitWorkPlan): Boolean;
var
  query:TADOQuery;
  waitTM:TWaitWorkTrainmanInfo;
  dbTrainman:TDBWaitWorkTrainman;
begin
  Result := False;
  query := NewADOQuery;
  dbTrainman := TDBWaitWorkTrainman.Create(GetADOConnection);
  try
    query.SQL.Text := 'select * from VIEW_PLAN_WAITMAN where '
      + ' strPlanGUID = :strPlanGUID ';

    query.Parameters.ParamByName('strPlanGUID').Value := strPlanGUID;//���뿪��Ԣ
    query.Open;
    if query.RecordCount = 0 then Exit;
    while not query.Eof do
    begin
      if plan.tmPlanList.Count = 0 then
        self.Query2Plan(query,plan);
      waitTM := TWaitWorkTrainmanInfo.Create;
      dbTrainman.Query2Trainman(query,waitTM);
      plan.tmPlanList.Add(waitTM);
      query.Next;
    end;
    Result := true;
  finally
    query.Free;
    dbTrainman.Free;
  end;
end;

procedure TDBWaitWorkPlan.FinishNotifyCall(strPlanGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text:= 'update tab_plan_waitWork_Trainman set bNeedSyncCall = true '
        + ' where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strPlanGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;

end;

procedure TDBWaitWorkTrainman.Modify(tmInfo: TWaitWorkTrainmanInfo);
var
  query:TADOQuery;
begin
  query:= NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_plan_waitWork_Trainman where strGUID =:strGUID';
    query.Parameters.ParamByName('strGUID').Value := tmInfo.strGUID;
    query.Open;
    query.Edit;
    self.Trainman2Query(tmInfo,query);
    query.Post;
  finally
    query.Free;
  end;
end;

procedure TDBWaitWorkTrainman.ModifyPlanState(planGUID, tmGUID: string;
  ePlanState: TRsPlanState;dtFirstCallTime:TDatetime;bCallSucess:Boolean);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  qry.SQL.Text := 'update TAB_Plan_WaitWork_Trainman set eTrainmanState = :eTrainmanState, '
    + ' dtFirstCallTime = :dtFirstCallTime, bCallSucess =:bCallSucess'
    + ' where strTrainmanGUID = :strTrainmanGUID and strPlanGUID = :strPlanGUID';

  try
    qry.Parameters.ParamByName('dtFirstCallTime').Value := dtFirstCallTime;
    qry.Parameters.ParamByName('strTrainmanGUID').Value := tmGUID;
    qry.Parameters.ParamByName('strPlanGUID').Value := planGUID;
    qry.Parameters.ParamByName('eTrainmanState').Value := Ord(ePlanState);
    qry.Parameters.ParamByName('bCallSucess').Value := bCallSucess;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitWorkTrainman.ModityTMPos(tmInfo: TWaitWorkTrainmanInfo);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'update TAB_Plan_WaitWork_Trainman set nTrainmanIndex = :nTrainmanIndex '
       + ' where strGUID =:strGUID';
    qry.Parameters.ParamByName('nTrainmanIndex').Value := tmInfo.nIndex;
    qry.Parameters.ParamByName('strGUID').Value :=tmInfo.strGUID ;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitWorkTrainman.Query2Trainman(query: TADOQuery;
  Trainman: TWaitWorkTrainmanInfo;strIndex:string = '');
begin
  trainman.nIndex := query.FieldByName('nTrainmanIndex'+strIndex).Value;
  trainman.strGUID :=query.FieldByName('strGUID'+ strIndex).Value;
  Trainman.strPlanGUID := query.FieldByName('strPlanGUID'+ strIndex).Value;
  Trainman.strTrainmanGUID := query.FieldByName('strTrainmanGUID'+ strIndex).value;
  trainman.strTrainmanName := query.FieldByName('strTrainmanName'+ strIndex).Value ;
  trainman.strTrainmanNumber := query.FieldByName('strTrainmanNumber'+ strIndex).value;
  Trainman.eTMState := query.FieldByName('eTrainmanState'+ strIndex).value;
  Trainman.strRealRoom := query.FieldByName('strRealRoom'+ strIndex).value;
  Trainman.dtFirstCallTime := query.FieldByName('dtFirstCallTime'+ strIndex).value;
  trainman.bCallSucess := query.FieldByName('bCallSucess'+ strIndex).value;
  //trainman.eCallState := query.fieldByName('eCallState'+ strIndex).value ;
  
end;

procedure TDBWaitWorkTrainman.Query2TrainmanJoinRoom(query: TADOQuery;
  Trainman: TWaitWorkTrainmanInfo; strIndex: string);
begin
  query.FieldByName('nTrainmanIndex').Value := trainman.nIndex;
  query.FieldByName('strGUID').Value := trainman.strGUID;
  query.FieldByName('strPlanGUID').Value :=Trainman.strPlanGUID;
  query.FieldByName('strTrainmanNumber').value := trainman.strTrainmanNumber;
  query.FieldByName('strTrainmanName').Value := trainman.strTrainmanName;
  query.FieldByName('strTrainmanGUID').value :=  Trainman.strTrainmanGUID;
  query.FieldByName('eTrainmanState').value := Ord(Trainman.eTMState);
  query.FieldByName('strRealRoom').Value := trainman.strRealRoom;
end;

procedure TDBWaitWorkTrainman.Trainman2Query(trainman: TWaitWorkTrainmanInfo;
  query: TADOQuery);
begin
  query.FieldByName('nTrainmanIndex').Value := trainman.nIndex;
  query.FieldByName('strGUID').Value := trainman.strGUID;
  query.FieldByName('strPlanGUID').Value :=Trainman.strPlanGUID;
  query.FieldByName('strTrainmanNumber').value := trainman.strTrainmanNumber;
  query.FieldByName('strTrainmanName').Value := trainman.strTrainmanName;
  query.FieldByName('strTrainmanGUID').value :=  Trainman.strTrainmanGUID;
  query.FieldByName('eTrainmanState').value := Ord(Trainman.eTMState);
  query.FieldByName('strRealRoom').Value := trainman.strRealRoom;
  query.FieldByName('dtFirstCallTime').Value := trainman.dtFirstCallTime;
  query.FieldByName('bCallSucess').Value := trainman.bCallSucess;

  //query.fieldByName('eCallState').value := trainman.eCallState;
end;
 (*
{ TDBInOutRoomEvent }

procedure TDBInOutRoomEvent.Add(info: TInOutRoomInfo);
var
  query:TADOQuery;
begin
  query:= NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Event_InOutRoom where 1<>1';
    query.Open;
    query.Append;
    obj2Query(info,query);
    query.Post;
  finally
    query.Free;
  end;

end;

function TDBInOutRoomEvent.bGetInfo(strPlanGUID: string): Boolean;
var
  query:TADOQuery;
begin
  result := False;
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Event_InOutRoom where strPlanGUID =:strPlanGUID';
    query.Parameters.ParamByName('strPlanGUID').Value := strPlanGUID;
    query.Open;
    if query.RecordCount >0 then
      result := True;
  finally
    query.Free;
  end;

end;

procedure TDBInOutRoomEvent.GetInfo(strPlanGUID, strTrainmanGUID: string;
  eType:TInOutRoomType; var inOutRoomInfo: TInOutRoomInfo);
var
  query:TADOQuery;
begin
  query:= NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Event_InOutRoom where strPlanGUID=:strPlanGUID '
      +  ' and strTrainmanGUID =:strTrainmanGUID and eType =:eType ';
    query.Parameters.ParamByName('strPlanGUID').Value := strPlanGUID;
    query.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    query.Parameters.ParamByName('eType').Value := eType;
    query.Open;
    if query.RecordCount = 0 then Exit;
    Self.query2Obj(query,inOutRoomInfo);
  finally
    query.Free;
  end;
end;

procedure TDBInOutRoomEvent.GetUnUploadInfo(
  var inOutRoomInfoList: TInOutRoomInfoList);
var
  query:TADOQuery;
  info:TInOutRoomInfo;
begin
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Event_InOutRoom where bUpload = False';
    query.Open;
    while not query.Eof do
    begin
      info:=TInOutRoomInfo.Create;
      self.query2Obj(query,info);
      inOutRoomInfoList.Add(info);
      query.Next;
    end;
  finally
    query.Free;
  end;
end;

procedure TDBInOutRoomEvent.Modify(info: TInOutRoomInfo);
var
  query:TADOQuery;
begin
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Event_InOutRoom where strGUID =:strGUID';
    query.Parameters.ParamByName('strGUID').Value := info.strGUID;
    query.Open;
    if query.RecordCount =0 then Exit;
    query.Edit;
    self.obj2Query(info,query);
    query.Post;
  finally
    query.Free;
  end;
end;

procedure TDBInOutRoomEvent.GetInfo(strPlanGUID: string;
  var inOutRoomInfoList: TInOutRoomInfoList);
var
  query:TADOQuery;
  info:TInOutRoomInfo;
begin
  query:= NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Event_InOutRoom where strPlanGUID=:strPlanGUID ';
    query.Parameters.ParamByName('strPlanGUID').Value := strPlanGUID;
    query.Open;
    while not query.Eof do
    begin
      info := TInOutRoomInfo.Create;
      self.query2Obj(query,info);
      inOutRoomInfoList.Add(info);
      query.Next;
    end;
  finally
    query.Free;
  end;
end;

procedure TDBInOutRoomEvent.obj2Query(info: TInOutRoomInfo; query: TADOQuery);
begin
  query.FieldByName('strGUID').Value := info.strGUID;
  query.FieldByName('strPlanGUID').Value := info.strPlanGUID;
  query.FieldByName('strTrainmanGUID').Value := info.strTrainmanGUID;
  query.FieldByName('dtTime').Value := info.dtTime;
  query.FieldByName('dtArriveTime').Value := info.dtArriveTime;
  query.FieldByName('eType').Value := Ord(info.eType);
  query.FieldByName('ePlanType').Value := ord(info.ePlanType);
  query.FieldByName('bUpload').value := info.bUpload;
end;

procedure TDBInOutRoomEvent.query2Obj(query: TADOQuery; info: TInOutRoomInfo);
begin
  info.strGUID := query.FieldByName('strGUID').Value;
  info.strPlanGUID := query.FieldByName('strPlanGUID').Value;
  info.strTrainmanGUID := query.FieldByName('strTrainmanGUID').Value;
  info.dtArriveTime :=query.FieldByName('dtArriveTime').Value;
  info.dtTime := query.FieldByName('dtTime').Value;
  info.eType := TInOutRoomType(query.FieldByName('eType').Value) ;
  info.ePlanType := TWaitWorkPlanType(query.FieldByName('ePlanType').Value);
  info.bUpload := query.FieldByName('bUpload').value;
end;
        *)
{ TDBWaitWorkTrainman }

procedure TDBWaitWorkTrainman.Add(tmInfo: TWaitWorkTrainmanInfo);
var
  query:TADOQuery;
begin
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Plan_waitWork_Trainman where 1<>1';
    query.Open;
    query.Append;
    self.Trainman2Query(tmInfo,query);
    query.Post;
  finally
    query.Free;
  end;
end;

procedure TDBWaitWorkTrainman.Del(strGUID: string);
var
  query:TADOQuery;
begin
  query:= NewADOQuery;
  try
    query.SQL.Text := 'delete from tab_plan_waitwork_trainman where strGUID=:strGUID';
    query.Parameters.ParamByName('strGUID').value := strGUID;
    query.ExecSQL;
  finally
    query.Free;
  end;
end;



procedure TDBWaitWorkTrainman.DelByPlanID(strPlanGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery();
  try
    qry.SQL.Text := 'delete from tab_plan_waitwork_Trainman where strPlanGUID =:strPlanGUID';
    qry.Parameters.ParamByName('strPlanGUID').value := strPlanGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;



procedure TDBWaitWorkTrainman.GetRoomNoSign(waitRoomList: TWaitRoomList);
var
  qry:TADOQuery;
  waitRoom:TWaitRoom;
  waitMan:TWaitWorkTrainmanInfo;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from TAB_Plan_CallMan where strTrainmanGUID=''''  ';
    qry.open;
    while not qry.Eof do
    begin
      if qry.FieldByName('strTrainmanGUID').Value = '' then
      begin
        waitRoom :=waitRoomList.Find(qry.FieldByName('strRoomNum').Value);
        if waitRoom <> nil then
        begin
          waitMan := TWaitWorkTrainmanInfo.Create;
          waitMan.strTrainmanGUID := qry.FieldByName('strTrainNo').Value ;
          waitMan.strTrainmanName := qry.FieldByName('strTrainNo').Value ;
          waitMan.strTrainmanNumber := qry.FieldByName('strTrainNo').value;
          waitRoom.waitManList.Add(waitMan);
        end;
      end;
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitWorkTrainman.GetRoomWaitMan(waitRoomList: TWaitRoomList);
var
  qry:TADOQuery;
  waitRoom:TWaitRoom;
  waitMan:TWaitWorkTrainmanInfo;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_waitwork_Trainman where eTrainmanState >=:inRoom'
      + ' and eTrainmanState <:outRoom  ';
    qry.Parameters.ParamByName('inRoom').Value:= Ord(psInRoom);
    qry.Parameters.ParamByName('outRoom').Value:= Ord(psReCall);
    qry.open;
    while not qry.Eof do
    begin
      if qry.FieldByName('strTrainmanGUID').Value <> '' then
      begin
        waitRoom :=waitRoomList.Find(qry.FieldByName('strRealRoom').Value);
        if waitRoom <> nil then
        begin
          waitMan := TWaitWorkTrainmanInfo.Create;
          Self.Query2Trainman(qry,waitMan);
          waitRoom.waitManList.Add(waitMan);
        end;
      end;
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitWorkTrainman.GetRoomWaitManWithJoin(
  waitRoomList: TWaitRoomList);
var
  qry:TADOQuery;
  list:TStringList;
  i : integer ;
  strText:string;
  waitRoom:TWaitRoom;
  waitMan:TWaitWorkTrainmanInfo;
begin
  qry := NewADOQuery;
  list:=TStringList.Create;
  try
    list.Delimiter := ',' ;
    qry.SQL.Text := 'select * from TAB_Plan_Waitwork where ePlanState >=:inRoom'
      + ' and ePlanState <:outRoom  and strJoinRooms <> ''''  ';
    qry.Parameters.ParamByName('inRoom').Value:= Ord(psInRoom);
    qry.Parameters.ParamByName('outRoom').Value:= Ord(psOutRoom);
    qry.open;
    while not qry.Eof do
    begin
      list.Clear ;
      list.CommaText := qry.FieldByName('strJoinRooms').Value;
      strText := format('[%s]������Ա',[ qry.FieldByName('strRoomNum').Value ]);
      for I := 0 to List.Count - 1 do
      begin
        waitRoom := waitRoomList.Find( list.Strings[i] );   //���ҷ���
        if waitRoom <> nil then
        begin
          waitMan := TWaitWorkTrainmanInfo.Create;
          waitMan.strPlanGUID := qry.FieldByName('strPlanGUID').Value ;
          waitMan.strTrainmanGUID := strText ;
          waitMan.strTrainmanName :=   strText ;
          waitMan.strTrainmanNumber :=  strText ;
          waitman.strRealRoom := list.Strings[i] ;
          waitman.nIndex := 0 ;
          waitman.eTMState := psInRoom ;
          waitRoom.waitManList.Add(waitMan);
        end;
      end;
      qry.Next;
    end;
  finally
    list.Free;
    qry.Free;
  end;
end;

procedure TDBWaitWorkTrainman.GetTrainmanS(strPlanGUID: string;
  var tmList: TWaitWorkTrainmanInfoList);
var
  query:TADOQuery;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_plan_waitwork_Trainman where strPlanGUID =:strPlanGUID';
    query.Parameters.ParamByName('strPlanGUID').Value  := strPlanGUID;
    query.Open;
    while not query.Eof do
    begin
      tmInfo := TWaitWorkTrainmanInfo.Create;
      self.Query2Trainman(query,tmInfo);
      tmList.Add(tmInfo);
      query.Next;
    end;
  finally
    query.Free;
  end;
end;

{ TDBSyncPlanID }

procedure TDBSyncPlanID.Add(planIDInfo:TSyncPlanIDInfo);
var
  query:TADOQuery;
begin
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Plan_SyncGUID where strPlanGUID =:strPlanGUID';
    query.Parameters.ParamByName('strPlanGUID').Value :=planIDInfo.strPlanGUID;
    query.Open;
    if query.RecordCount > 0  then Exit;
    query.Append;
    query.FieldByName('strPlanGUID').Value := planIDInfo.strPlanGUID;
    query.FieldByName('ePlanTYpe').Value := Ord(planIDInfo.ePlanType);
    query.Post;
  finally
    query.Free;
  end;
end;

procedure TDBSyncPlanID.GetAllUnDone(planIDList:TSyncPlanIDInfoList);
var
  query:TADOQuery;
  planIDInfo:TSyncPlanIDInfo;
begin
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Plan_SyncGUID ';
    query.Open;
    while not query.Eof do
    begin
      planIDInfo:=TSyncPlanIDInfo.Create;
      planIDInfo.strPlanGUID := query.FieldByName('strPlanGUID').Value;
      planIDInfo.ePlanType := TWaitWorkPlanType(query.FieldByName('ePlanType').Value);
      planIDList.Add(planIDInfo);
      query.Next;
    end;
  finally
    query.Free;
  end;
end;

procedure TDBSyncPlanID.Del(strPlanGUID: string);
var
  query:TADOQuery;
begin
  query := NewADOQuery;
  try
    query.SQL.Text := 'delete  from tab_Plan_SyncGUID where strPlanGUID =:strPlanGUID';
    query.Parameters.ParamByName('strPlanGUID').Value := strPlanGUID;
    query.ExecSQL;
  finally
    query.Free;
  end;
end;

{ TDBWaitWorkRoom }

procedure TDBWaitWorkRoom.Add(Room: TWaitRoom);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_base_Room where 1<>1';
    qry.Open;
    qry.Append;
    Self.Obj2Qry(Room,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

function TDBWaitWorkRoom.bExist(strRoomNum: string): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_base_room where strRoomNumber = :strRoomNumber';
    qry.Parameters.ParamByName('strRoomNumber').Value := strRoomNum;
    qry.Open;
    if qry.RecordCount > 0 then
    begin
      Result := True;
    end;

  finally
    qry.Free;
  end;
end;

procedure TDBWaitWorkRoom.Del(strRoomNumber:string);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery();
  try
    qry.SQL.Text := 'delete from tab_base_room where strRoomNumber = :strRoomNumber';
    qry.Parameters.ParamByName('strRoomNumber').Value := strRoomNumber;
    qry.ExecSQL;
  finally
    qry.Free;
  end;

end;

procedure TDBWaitWorkRoom.GetAll(RoomList: TWaitRoomList);
var
  qry:TADOQuery;
  room:TWaitRoom;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_Room order by strRoomNumber';
    qry.Open;
    while not qry.Eof do
    begin
      room:= TWaitRoom.Create;
      self.Query2Obj(qry,room);
      qry.Next;
      RoomList.Add(room);
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitWorkRoom.Obj2Qry(room: TWaitRoom; qry: TADOQuery);
begin
  qry.FieldByName('strRoomNumber').Value := room.strRoomNum;
end;

procedure TDBWaitWorkRoom.Query2Obj(qry: TADOQuery; room: TWaitRoom);
begin
  room.strRoomNum := qry.FieldByName('strRoomNumber').Value;
end;

{ TDBWaitTable }

procedure TDBWaitTime.Add(waitTime: RWaitTime);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_WaitTime where 1<>1';
    qry.Open;
    qry.Append;
    self.obj2Query(waitTime,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitTime.DelAll;
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete from tab_Base_WaitTime';
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitTime.Delete(strGUID: string);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'delete  from tab_Base_WaitTime where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;
function TDBWaitTime.FindByTrainNo(strTrainNo:string ;out waitTime:RWaitTime):Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_WaitTime where strTrainNo =:strTrainNo ';
    qry.Parameters.ParamByName('strTrainNo').Value := strTrainNo;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    Self.Query2Obj(qry,waitTime);
    result := True;
  finally
    qry.Free;
  end;
end;
function TDBWaitTime.Find(strTrainNo:string;dtWaitTime,dtCallTime:TDateTime; out waitTime:RWaitTime): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_WaitTime where strTrainNo =:strTrainNo '
      + ' and dtWaitTime =:dtWaitTime and dtCallTime =:dtCallTime';
    qry.Parameters.ParamByName('strTrainNo').Value := strTrainNo;
    qry.Parameters.ParamByName('dtWaitTime').Value := dtWaitTime;
    qry.Parameters.ParamByName('dtCallTime').Value := dtCallTime;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    Self.Query2Obj(qry,waitTime);
    result := true;
  finally
    qry.Free;
  end;
end;


procedure TDBWaitTime.GetAll(out waitTimeAry:TWaitTimeAry);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_WaitTime order by strWorkShopName,strRoomNum';
    qry.Open;
    SetLength(waitTimeAry,qry.RecordCount);
    for i := 0 to qry.RecordCount - 1 do
    begin
      self.Query2obj(qry,waitTimeAry[i]);
      qry.next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitTime.Modify(waitTime: RWaitTime);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_WaitTime where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := waitTime.strGUID;
    qry.Open;
    qry.Edit;
    self.obj2Query(waitTime,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBWaitTime.obj2Query(waitTime: RWaitTime; query: TADOQuery);
begin
  query.FieldByName('strGUID').Value := waitTime.strGUID;
  query.FieldByName('strWorkshopGUID').Value := waitTime.strWorkshopGUID;
  query.FieldByName('strWorkShopName').Value := waitTime.strWorkShopName;
  query.FieldByName('strTrainJiaoLuGUID').Value := waitTime.strTrainJiaoLuGUID;
  query.FieldByName('strTrainJiaoLuName').Value := waitTime.strTrainJiaoLuName;
  query.FieldByName('strTrainJiaoLuNickName').Value := waitTime.strTrainJiaoLuNickName;
  query.FieldByName('strTrainNo').Value := waitTime.strTrainNo;
  query.FieldByName('strRoomNum').Value := waitTime.strRoomNum;
  query.FieldByName('dtWaitTime').Value := waitTime.dtWaitTime;
  query.FieldByName('dtCallTime').Value := waitTime.dtCallTime;
  query.FieldByName('dtChuQinTime').Value := waitTime.dtChuQinTime;
  query.FieldByName('dtKaiCheTime').Value := waitTime.dtKaiCheTime;
  query.FieldByName('bMustSleep').Value := waitTime.bMustSleep;
end;

procedure TDBWaitTime.Query2Obj(query: TADOQuery; out waitTime: RWaitTime);
begin
  waitTime.strGUID := query.FieldByName('strGUID').Value;
  waitTime.strWorkshopGUID := query.FieldByName('strWorkshopGUID').Value;
  waitTime.strWorkShopName := query.FieldByName('strWorkShopName').Value;
  waitTime.strTrainJiaoLuGUID := query.FieldByName('strTrainJiaoLuGUID').Value;
  waitTime.strTrainJiaoLuName := query.FieldByName('strTrainJiaoLuName').Value;
  waitTime.strTrainJiaoLuNickName := query.FieldByName('strTrainJiaoLuNickName').Value;
  waitTime.strTrainNo := query.FieldByName('strTrainNo').Value;
  waitTime.strRoomNum := query.FieldByName('strRoomNum').Value;
  waitTime.dtWaitTime := query.FieldByName('dtWaitTime').Value;
  waitTime.dtCallTime := query.FieldByName('dtCallTime').Value;
  waitTime.dtChuQinTime := query.FieldByName('dtChuQinTime').Value;
  waitTime.dtKaiCheTime := query.FieldByName('dtKaiCheTime').Value;
  if VarIsNull(query.FieldByName('bMustSleep').Value) then
    waitTime.bMustSleep := False
  else
    waitTime.bMustSleep := query.FieldByName('bMustSleep').Value;
end;

{ TDBRoomTrainmanRelation }

function TDBRoomTrainmanRelation.GetAllTrainmanRoomRelation(RoomNumber: string;
  var BedInfoArray: TRsBedInfoArray): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
  i :Integer ;
  BedInfo:RRsBedInfo ;
begin
  i := 0 ;
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select *  from Tab_RoomTrainman_Relation where strRoomNumber = %s ';
    strSQL :=  Format(strSQL,[QuotedStr(RoomNumber)]);
    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open;
    if ADOQuery.IsEmpty then
      Exit ;
    SetLength(BedInfoArray,ADOQuery.RecordCount);
    while not ADOQuery.Eof do
    begin
      BedInfo.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID').asstring ;
      BedInfo.strTrainmanName := ADOQuery.FieldByName('strTrainmanName').asstring ;
      BedInfo.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber').asstring ;
      BedInfo.nBedNumber := ADOQuery.FieldByName('nBedNumber').AsInteger ;
      BedInfoArray[i] := BedInfo ;
      ADOQuery.Next ;
      Inc(i);
    end;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TDBRoomTrainmanRelation.InsertTrainmanRoomRelation(RoomNumber: string;
  BedInfo: RRsBedInfo): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    //������λ1
    strSQL := Format('Insert into  Tab_RoomTrainman_Relation  ' +
    '( strRoomNumber , strTrainmanGUID  ,strTrainmanNumber,strTrainmanName,nBedNumber )  '+
      ' values (%s,%s,%s,%s,%d)  ',[QuotedStr(RoomNumber),QuotedStr(BedInfo.strTrainmanGUID),
        QuotedStr(BedInfo.strTrainmanNumber),QuotedStr(BedInfo.strTrainmanName),BedInfo.nBedNumber]);
    ADOQuery.SQL.Text := strSQL;
    if ADOQuery.ExecSQL >= 0 then
      Result := True ;
  finally
    ADOQuery.Free ;
  end;
end;

function TDBRoomTrainmanRelation.IsHaveTrainmanRoomRelation(
  TrainmanGUID: string; out RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select strRoomNumber  from Tab_RoomTrainman_Relation where  strTrainmanGUID = %s ';
    strSQL :=  Format(strSQL,[QuotedStr(TrainmanGUID)]);

    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      RoomNumber := ADOQuery.FieldByName('strRoomNumber').AsString;
      Result := True ;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TDBRoomTrainmanRelation.QueryTrainmanRoomRelation(TrainmanNumber,
  TrainmanName: string; var RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select strRoomNumber  from Tab_RoomTrainman_Relation where 1 = 1 ';
    if Trim(TrainmanNumber) <> '' then
    begin
      strSQL := strSQL + 'and strTrainmanNumber =  ' + QuotedStr(TrainmanNumber) ;
    end;

    if Trim(TrainmanName) <> '' then
    begin
      strSQL := strSQL + 'and strTrainmanName =  ' + QuotedStr(TrainmanName) ;
    end;
    

    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open;
    if ADOQuery.IsEmpty then
      Exit ;
    RoomNumber := ADOQuery.FieldByName('strRoomNumber').asstring ;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TDBRoomTrainmanRelation.RemoveTrainmanRoomRelation(RoomNumber: string;
  BedInfo: RRsBedInfo): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'delete from Tab_RoomTrainman_Relation where strRoomNumber = %s and strTrainmanGUID = %s ';
    strSQL := Format(strSQL,[QuotedStr(RoomNumber),QuotedStr(BedInfo.strTrainmanGUID)]) ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.ExecSQL;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

end.
