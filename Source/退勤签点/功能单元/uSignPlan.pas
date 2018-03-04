unit uSignPlan;

interface
uses
  Classes,SysUtils,superobject,uSaftyEnum,Contnrs,uTrainman;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����: TSignPlan
  /// ����: ����ǩ��ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TSignPlan= class
  public
    //GUID
    strGUID:string;
    //�ƻ�״̬
    eState:TRsPlanState;
    //ǩ��ʱ��
    dtSignTime:TDateTime;
    //��·GUID
    strTrainJiaoLuGUID:string;
    //��·����
    strTrainJiaoLuName:string;
    //�Ƿ�ǩ��
    nNeedRest :Integer;
    //����ʱ��
    dtArriveTime:TDateTime;
    //�а�ʱ��
    dtCallTime:TDateTime;
    //����
    strTrainNo:string;
    //  �ƻ�����ʱ��
    dtChuQinTime:TDateTime;
    // �ƻ�����ʱ��
    dtStartTrainTime:TDateTime;
    //ͼ������id
    strTrainNoGUID:String;
    //����GUID
    strWorkGrouGUID:string;
    //˾��1
    strTrainmanGUID1:string;
    strTrainmanName1:string;
    strTrainmanNumber1:string;
    //˾��2
    strTrainmanGUID2:string;
    strTrainmanName2:string;
    strTrainmanNumber2:string;
    //˾��3
    strTrainmanGUID3:string;
    strTrainmanName3:string;
    strTrainmanNumber3:string;
    //˾��4
    strTrainmanGUID4:string;
    strTrainmanName4:string;
    strTrainmanNumber4:string;
    //�ɰ����
    nFinished:Integer;

  public
    {����:����˾������,��Ϊ�յ�˾��}
    function FindTrainmanIndex(strTrainmanGUID:string):Integer;
    {����:��ȡ��Ա����}
    function GetTrainmanCount():Integer;
    {����:��������}
    procedure Clone(var SourceObj:TSignPlan);
    {����:�ж��Ƿ���ǩ��}
    function bSigned():Boolean;
    {����:ת��Ϊjson}
    procedure ToJson(var iJson:ISuperObject);
    {����:json��ֵ������}
    procedure FromJson(iJson:ISuperObject);
     {����:�޸���Ա}
    function ModifyTrainman(nTrainmanIndex:Integer;DestTrainman:RRsTrainman):Boolean;

    {����:ת���ַ���Ϊ����}
    function str2DateTime(strDateTime:string):TDateTime;
    {����:ת������Ϊ�ַ���}
    function DateTime2Str(dt:TDateTime):String;
    {����:����������ȡ��ԱGUID}
    function GetTrianmanID(index:Integer):string;
    
  end;
  {ǩ��ƻ��б�}
  TSignPlanList = class(TObjectList)
  public
    //����
    dtDay :TDateTime;
  protected
    function GetItem(Index: Integer): TSignPlan;
    procedure SetItem(Index: Integer; AObject: TSignPlan);
  public
   function Add(AObject: TSignPlan): Integer;
   property Items[Index: Integer]: TSignPlan read GetItem write SetItem; default;
   {����:����json����}
   procedure FromJson(iJson:ISuperObject);
   {����:���һ�������ǩ��ƻ�����}
   function FindGroup (strGroupGUID:string):Integer;
   {����:������Ա���ڵ�Ƿ��ƻ�}
   function FindPlanByTM(strTrainmanGUID:string;var nTMIndex:Integer):TSignPlan;
   {����:�ҵ���һ��ǩ��ļƻ�}
   function GetFirstSignedPlanIndex():Integer;
   {����:�ҵ���һ����ǩ��ƻ�����}
   function FindNextSignPlanIndex():Integer;
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// ����: TSignPlanJiaoLu
  /// ����: ��·����ǩ��ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TSignPlanJiaoLu = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //��·GUID
    strTrainJiaoLuGUID:string;
    //��ǰǩ��ƻ�
    strCurPlanGUID:string;
    //ǩ��ƻ��б�
    SignPlanList : TSignPlanList;
  
  public
    //����json��
    procedure FromJson(iJson:ISuperObject);
  end;
  
  //////////////////////////////////////////////////////////////////////////////
  /// ����: TDaySignPlanJiaoLu
  /// ����: ��·����ǩ��ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TDaySignPlanJiaoLu = class(TSignPlanJiaoLu)
  public
    //����
    dtDay:TDateTime;
  end;

  
  //////////////////////////////////////////////////////////////////////////////
  /// ����: TDaySignPlanJiaoLu
  /// ����: ��·����ǩ��ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TMutilDaySignPlanJiaoLuList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TDaySignPlanJiaoLu;
    procedure SetItem(Index: Integer; AObject: TDaySignPlanJiaoLu);
  public
    function Add(AObject: TDaySignPlanJiaoLu): Integer;
    property Items[Index: Integer]: TDaySignPlanJiaoLu read GetItem write SetItem; default;
    //����:�������ڲ���
    function FindByDay(dtDay:TDateTime):TDaySignPlanJiaoLu;
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// ����: TSignModifyTrainman
  /// ����: �޸�ǩ����Ա��¼
  //////////////////////////////////////////////////////////////////////////////
  TSignModifyTrainman = class
  public
    //ǩ��ƻ�guid
    strSignPlanGUID:string;
    //ԭ˾��guid
    strSouceTMGUID:string;
    //��˾��guid
    strDestTMGUID:string;
    //����ԭ��
    strReason:string;
    //����ʱ��
    dtModifyTime:TDateTime;
    //����
    nIndex:Integer;
    //����GUID
    strWorkGroupGUID:string;
    //�ƻ�״̬
    ePlanState:TRsPlanState;
  public
    {����:ת��Ϊjson}
    procedure ToJson(var iJson:ISuperObject);


  end;

implementation

{ TSignPlan }


function TSignPlan.bSigned: Boolean;
begin
  Result := False;
  if strTrainmanGUID1 <> '' then
  begin
    result := True;
    Exit;
  end;
  if strTrainmanGUID2 <> '' then
  begin
    result := True;
    Exit;
  end;
  if strTrainmanGUID3 <> '' then
  begin
    result := True;
    Exit;
  end;
  if strTrainmanGUID4 <> '' then
  begin
    result := True;
    Exit;
  end;

end;

procedure TSignPlan.Clone(var SourceObj:TSignPlan);
begin
  //GUID
    self.strGUID:= SourceObj.strGUID;
    //�ƻ�״̬
    self.eState:=SourceObj.eState;
    //ǩ��ʱ��
    self.dtSignTime:=SourceObj.dtSignTime;
    //��·GUID
    self.strTrainJiaoLuGUID:=SourceObj.strTrainJiaoLuGUID;
    //�Ƿ�ǩ��
    self.nNeedRest :=SourceObj.nNeedRest;
    //����ʱ��
    self.dtArriveTime:=SourceObj.dtArriveTime;
    //�а�ʱ��
    self.dtCallTime:=SourceObj.dtCallTime;
    //����
    self.strTrainNo:=SourceObj.strTrainNo;
    //  �ƻ�����ʱ��
    self.dtChuQinTime:=SourceObj.dtChuQinTime;
    // �ƻ�����ʱ��
    self.dtStartTrainTime:=SourceObj.dtStartTrainTime;
    //ͼ������id
    self.strTrainNoGUID:=SourceObj.strTrainNoGUID;
    //����GUID
    self.strWorkGrouGUID:=SourceObj.strWorkGrouGUID;
    //˾��1
    self.strTrainmanGUID1:=SourceObj.strTrainmanGUID1;
    self.strTrainmanName1:=SourceObj.strTrainmanName1;
    self.strTrainmanNumber1:=SourceObj.strTrainmanNumber1;
    //˾��2
    self.strTrainmanGUID2:=SourceObj.strTrainmanGUID2;
    self.strTrainmanName2:=SourceObj.strTrainmanName2;
    self.strTrainmanNumber2:=SourceObj.strTrainmanNumber2;
    //˾��3
    self.strTrainmanGUID3:=SourceObj.strTrainmanGUID3;
    self.strTrainmanName3:=SourceObj.strTrainmanName3;
    self.strTrainmanNumber3:=SourceObj.strTrainmanNumber3;
    //˾��4
    self.strTrainmanGUID4:=SourceObj.strTrainmanGUID4;
    self.strTrainmanName4:=SourceObj.strTrainmanName4;
    self.strTrainmanNumber4:=SourceObj.strTrainmanNumber4;
end;

function TSignPlan.DateTime2Str(dt: TDateTime): String;
begin
  result := FormatDateTime('yyyy-mm-dd HH:mm:ss',dt);
end;

function TSignPlan.FindTrainmanIndex(strTrainmanGUID: string): Integer;
begin
  result := -1;
  if strTrainmanGUID1 <> '' then
  begin
    if strTrainmanGUID1 = strTrainmanGUID then
    begin
      Result := 1;
      Exit;
    end;
  end;
  if strTrainmanGUID2 <> '' then
  begin
    if strTrainmanGUID2 = strTrainmanGUID then
    begin
      Result := 2;
      Exit;
    end;
  end;
  if strTrainmanGUID3 <> '' then
  begin
    if strTrainmanGUID3 = strTrainmanGUID then
    begin
      Result := 3;
      Exit;
    end;
  end;
  if strTrainmanGUID4 <> '' then
  begin
    if strTrainmanGUID4 = strTrainmanGUID then
    begin
      Result := 4;
      Exit;
    end;
  end;
end;

procedure TSignPlan.FromJson(iJson:ISuperObject);
begin
  //GUID
    strGUID:= iJson.S['strGUID'];
    //�ƻ�״̬
    eState := TRsPlanState(iJson.I['ePlanState']);
    if eState = psCancel then
      eState := psReceive;
    //ǩ��ʱ��
    dtSignTime := str2DateTime(iJson.S['dtSignTime']);
    //��·GUID
    strTrainJiaoLuGUID:= iJson.S['strTrainJiaoLuGUID'];
    //�Ƿ����
    nNeedRest := iJson.I['nNeedRest'];
    //����ʱ��
    dtArriveTime:= str2DateTime(iJson.S['dtArriveTime']);
    //�а�ʱ��
    dtCallTime:= str2DateTime(iJson.S['dtCallTime']);
    //����
    strTrainNo:= iJson.S['strTrainNo'];
    //�ƻ�����ʱ��
    dtChuQinTime:=  str2DateTime(iJson.S['dtChuQinTime']);
    //�ƻ�����ʱ��
    dtStartTrainTime:= str2DateTime(iJson.S['dtStartTrainTime']);
    //ͼ������id
    strTrainNoGUID:= iJson.S['strTrainNoGUID'];
    //����GUID
    strWorkGrouGUID:= iJson.S['strWorkGrouGUID'];
    //˾��1
    strTrainmanGUID1:= iJson.S['strTrainmanGUID1'];
    strTrainmanName1:= iJson.S['strTrainmanName1'];
    strTrainmanNumber1:= iJson.S['strTrainmanNumber1'];
    //˾��2
    strTrainmanGUID2:= iJson.S['strTrainmanGUID2'];
    strTrainmanName2:= iJson.S['strTrainmanName2'];
    strTrainmanNumber2:= iJson.S['strTrainmanNumber2'];
    //˾��3
    strTrainmanGUID3:= iJson.S['strTrainmanGUID3'];
    strTrainmanName3:= iJson.S['strTrainmanName3'];
    strTrainmanNumber3:= iJson.S['strTrainmanNumber3'];
    //˾��4
    strTrainmanGUID4:= iJson.S['strTrainmanGUID4'];
    strTrainmanName4:= iJson.S['strTrainmanName4'];
    strTrainmanNumber4:= iJson.S['strTrainmanNumber4'];
    nFinished := iJson.I['nFinished'];
    if nFinished = 1 then
    begin
      nFinished := 1;
    end;
end;


function TSignPlan.GetTrainmanCount: Integer;
begin
  result := 0;
  if strTrainmanGUID1 <> '' then
    Inc(Result);
  if strTrainmanGUID2 <> '' then
    Inc(Result);
  if strTrainmanGUID3 <> '' then
      Inc(Result);
  if strTrainmanGUID4 <> '' then
      Inc(Result);

end;

function TSignPlan.GetTrianmanID(index: Integer): string;
begin
  result := '';
  case index of
  1:Result := strTrainmanGUID1;
  2:Result := strTrainmanGUID2;
  3:Result := strTrainmanGUID3;
  4:Result := strTrainmanGUID4;
  end;
end;

function TSignPlan.ModifyTrainman(nTrainmanIndex:Integer;
  DestTrainman: RRStrainman): Boolean;
begin
  case nTrainmanIndex of
    1:
    begin
      strTrainmanGUID1 := DestTrainman.strTrainmanGUID;
      strTrainmanName1 := DestTrainman.strTrainmanName;
      strTrainmanNumber1 := DestTrainman.strTrainmanNumber;
    end;
    2:
    begin
      strTrainmanGUID2 := DestTrainman.strTrainmanGUID;
      strTrainmanName2 := DestTrainman.strTrainmanName;
      strTrainmanNumber2 := DestTrainman.strTrainmanNumber;
    end;
    3:
    begin
      strTrainmanGUID3 := DestTrainman.strTrainmanGUID;
      strTrainmanName3 := DestTrainman.strTrainmanName;
      strTrainmanNumber3 := DestTrainman.strTrainmanNumber;
    end;
    4:
    begin
      strTrainmanGUID4 := DestTrainman.strTrainmanGUID;
      strTrainmanName4 := DestTrainman.strTrainmanName;
      strTrainmanNumber4 := DestTrainman.strTrainmanNumber;
    end;
  end;

  if bSigned = False  then
  begin
    Self.strWorkGrouGUID := '';
    self.eState := psPublish;
  end;


end;

function TSignPlan.str2DateTime(strDateTime: string): TDateTime;
var
  dt:TDateTime;
begin
  if strDateTime ='' then Exit;
  if TryStrToDateTime(strDateTime,dt )then
    Result := dt
  else
    result := 0;
end;

procedure TSignPlan.ToJson(var iJson:ISuperObject);
begin
  //GUID
    iJson.S['strGUID']:= strGUID;
    //�ƻ�״̬
    iJson.I['ePlanState']:= ord(eState);
    //ǩ��ʱ��
    iJson.S['dtSignTime'] := DateTime2Str(dtSignTime);
    //��·GUID
    iJson.S['strTrainJiaoLuGUID']:= strTrainJiaoLuGUID;
     iJson.I['nNeedRest'] :=  nNeedRest;
    //����ʱ��
    iJson.S['dtArriveTime']:= DateTime2Str( dtArriveTime);
    //�а�ʱ��
    iJson.S['dtCallTime'] := DateTime2Str(dtCallTime);
    //����
    iJson.S['strTrainNo']:= strTrainNo;
    // �ƻ�����ʱ�� 
    iJson.S['dtChuQinTime']:=  DateTime2Str(dtChuQinTime);
    //�ƻ�����ʱ��
    iJson.S['dtStartTrainTime']:= DateTime2Str(dtStartTrainTime);
    //ͼ������id
     iJson.S['strTrainNoGUID']:=strTrainNoGUID;
    //����GUID
    iJson.S['strWorkGrouGUID']:=strWorkGrouGUID ;
    //˾��1
    iJson.S['strTrainmanGUID1']:=strTrainmanGUID1 ;
    //iJson.S['strTrainmanName1']:= strTrainmanName1;
    //iJson.S['strTrainmanNumber1']:= strTrainmanNumber1;
    //˾��2
    iJson.S['strTrainmanGUID2']:=strTrainmanGUID2 ;
    //iJson.S['strTrainmanName2']:= strTrainmanName2;
    //iJson.S['strTrainmanNumber2']:= strTrainmanNumber2;
    //˾��3
    iJson.S['strTrainmanGUID3']:= strTrainmanGUID3;
    //iJson.S['strTrainmanName3']:= strTrainmanName3;
    //iJson.S['strTrainmanNumber3']:= strTrainmanNumber3;
    //˾��4
    iJson.S['strTrainmanGUID4']:= strTrainmanGUID4 ;
    //iJson.S['strTrainmanName4']:= strTrainmanName4;
    //iJson.S['strTrainmanNumber4']:= strTrainmanNumber4;
    iJson.I['nFinished']:= nFinished;
end;

{ TSignPlanJiaoLu }


constructor TSignPlanJiaoLu.Create;
begin
  SignPlanList := TSignPlanList.Create;
end;

destructor TSignPlanJiaoLu.Destroy;
begin
  SignPlanList.Free;
  inherited;
end;

function TSignPlanList.FindGroup(strGroupGUID: string): Integer;
var
  i:Integer;
begin
  result := -1;

  for i := 0 to self.Count -1  do
  begin
    if Items[i].strWorkGrouGUID = strGroupGUID then
    begin
      result := i;
      Break;
    end;
  end;
end;

function TSignPlanList.GetFirstSignedPlanIndex():Integer;
var
  i:Integer;
begin
  result := -1 ;
  for i := 0 to self.Count - 1 do
  begin
    if Items[i].bSigned  = True then
    begin
      Result := i;
      Exit;
    end;
  end;
    
end;
function TSignPlanList.FindNextSignPlanIndex: Integer;
var
  i:Integer;
begin
  result := -1;
  //ȫ���ƻ�δǩ��,��Ҫ�״ζ���ǩ��
  if GetFirstSignedPlanIndex = -1 then
  begin
    result := 0;
    Exit;
  end;

  //�ӵ�һ��ǩ��ƻ�,���ƻ�����,�ҵ�һ��δǩ��ļƻ�
  for i := GetFirstSignedPlanIndex to self.Count- 1 do
  begin
    if Items[i].bSigned = False then
    begin
      result := i;
      Exit;
    end;
  end;
 
end;



function TSignPlanList.FindPlanByTM(strTrainmanGUID: string;
  var nTMIndex: Integer): TSignPlan;
var
  i:Integer;
begin
  Result := nil;
  if strTrainmanGUID = '' then Exit;
  
  for i := 0 to self.Count - 1 do
  begin
    if self.Items[i].strTrainmanGUID1 = strTrainmanGUID then
    begin
      result := self.Items[i];
      nTMIndex := 0;
      Exit;
    end;
    if self.Items[i].strTrainmanGUID2 = strTrainmanGUID then
    begin
      result := self.Items[i];
      nTMIndex := 1;
      Exit;
    end;
    if self.Items[i].strTrainmanGUID3 = strTrainmanGUID then
    begin
      result := self.Items[i];
      nTMIndex := 2;
      Exit;
    end;
    if self.Items[i].strTrainmanGUID4 = strTrainmanGUID then
    begin
      result := self.Items[i];
      nTMIndex := 3;
      Exit;
    end;
  end;
end;

procedure TSignPlanJiaoLu.FromJson(iJson:ISuperObject);
begin
  SignPlanList.Clear;
  Self.strTrainJiaoLuGUID := iJson.S['strTrainJiaoLuGUID'];
  Self.strCurPlanGUID := iJson.S['strCurPlanGUID'];
  SignPlanList.FromJson(iJson.o['planArray']);
end;


{ TSignModifyTrainman }


procedure TSignModifyTrainman.ToJson(var iJson: ISuperObject);
begin
  iJson.S['strPlanGUID'] := strSignPlanGUID;
  iJson.I['nTrainmanIndex'] := nIndex;
  iJson.S['strOldTrainmanGUID'] := strSouceTMGUID;
  iJson.S['strNewTrainmanGUID'] := strDestTMGUID;
  iJson.I['ePlanState'] := ord(self.ePlanState);
  iJson.S['dtModifyTime'] := FormatDateTime('yyyy-mm-dd HH:mm:ss',dtModifyTime);
  iJson.S['strReason'] := strReason;
  iJson.S['strWorkGroupGUID'] := strWorkGroupGUID;
end;

{ TSignPlanList }

function TSignPlanList.Add(AObject: TSignPlan): Integer;
begin
  result := inherited Add(AObject) ;
end;

procedure TSignPlanList.FromJson(iJson: ISuperObject);
var
  i:Integer;
  nCount:Integer;
  signPlan:TSignPlan;
begin
  nCount := iJson.AsArray.Length;
  for i := 0 to nCount - 1 do
  begin
    signPlan := TSignPlan.Create;
    signPlan.FromJson(iJson.AsArray[i]);
    self.Add(signPlan);
  end;
end;

function TSignPlanList.GetItem(Index: Integer): TSignPlan;
begin
  Result := TSignPlan(inherited GetItem(Index));
end;

procedure TSignPlanList.SetItem(Index: Integer; AObject: TSignPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TMutilDaySignPlanJiaoLuList }

function TMutilDaySignPlanJiaoLuList.Add(AObject: TDaySignPlanJiaoLu): Integer;
begin
  result := inherited Add(AObject);
end;

function TMutilDaySignPlanJiaoLuList.FindByDay(dtDay: TDateTime): TDaySignPlanJiaoLu;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if Self.Items[i].dtDay = dtDay then
    begin
      result := self.Items[i];
      Exit;
    end;
  end;
end;

function TMutilDaySignPlanJiaoLuList.GetItem(Index: Integer): TDaySignPlanJiaoLu;
begin
  Result := TDaySignPlanJiaoLu( inherited GetItem(Index));
end;

procedure TMutilDaySignPlanJiaoLuList.SetItem(Index: Integer; AObject: TDaySignPlanJiaoLu);
begin
  inherited SetItem(Index,AObject);
end;

end.
