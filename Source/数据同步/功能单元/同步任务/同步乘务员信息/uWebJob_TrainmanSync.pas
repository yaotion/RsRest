unit uWebJob_TrainmanSync;

interface
uses
  Classes,uHttpDataUpdateMgr,uWebIF,uWaitWork,uWaitWorkMgr,superobject,
  SysUtils,uGenericData,uTrainmanSync,Variants,ZKFPEngXUtils,uTrainman,
  uDBLocalTrainman,uSaftyEnum,uTFSystem;

const
   //��ȡ��Ա��Ϣ�б�
  ADDRESS_Trainman_TrainmanList = '%s/App_API/Public/Trainman/TrainmanList.ashx';
    //��ȡ��Ա������
  ADDRESS_Trainman_Signature = '%s/App_API/Public/Trainman/Signature.ashx';
type


  //////////////////////////////////////////////////////////////////////////////
  /// ����:TWebJob_TrainmanSync
  /// ����:ͬ��������Ա��Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TWebJob_TrainmanSync = class(THttpUpdateJob)
  public
    constructor Create(strJobName:string);override;
    destructor Destroy();override;
  public
    {����:ִ��ͬ��}
    procedure DoUpdate();override;
  private
    {����:������Ա}
    procedure UpdateTrainmanProgress(Index, totalCount, MaxID: integer;
        RltTrainmanArray: TRltTrainmanArray);
    {����:��ȡ����Ա}
    function GetTrainmanList(Option: TRltTrainmanOption; NID, PageCount: integer;
          out TrainmanArray: TRltTrainmanArray): boolean;
    {����:��ȡָ������}
    function GetSignature( out SignatureRlt: RRltSignature) :Boolean;
  private
    //������
    m_WaitWorkMgr :TWaitWorkMgr;
    //������Ա���ݿ����
    m_DBTrainman :TRsDBLocalTrainman;
  end;

implementation

{ TWebJob_WaitWorkPlan }

constructor TWebJob_TrainmanSync.Create(strJobName:string);
begin
  inherited Create(strJobName);
end;

destructor TWebJob_TrainmanSync.Destroy;
begin
  if Assigned(m_WaitWorkMgr) then
    m_WaitWorkMgr.Free;
  if Assigned(m_DBTrainman) then
    m_DBTrainman.Free;
  inherited;
end;


procedure TWebJob_TrainmanSync.UpdateTrainmanProgress(Index, totalCount, MaxID: integer;
  RltTrainmanArray: TRltTrainmanArray);
var
  i: Integer;
  rsTm:RRStrainman;
begin
 
  
  InsertLogs(Format('��ʼͬ����Ա%d/%d...',[Index,totalCount]));
  //��ʾ����
  for i := 0 to length(RltTrainmanArray) - 1 do
  begin
    rsTm.nID := RltTrainmanArray[i].nID;
    rsTm.strTrainmanGUID := RltTrainmanArray[i].trainmanid;
    rsTm.strTrainmanNumber:=RltTrainmanArray[i].trainmanNumber;
    rsTm.strTrainmanName := RltTrainmanArray[i].trainmanName;
    rsTm.nDriverType := drtNone;
    rsTm.bIsKey := 0;
    rsTm.nPostID := ptTrainman;
    rsTm.nDriverLevel := 1;
    rsTm.nKeHuoID := khKe;
    rsTm.nTrainmanState := tsReady;
    rsTm.nCallWorkState := cwsNil;

    rsTm.FingerPrint1 := RltTrainmanArray[i].finger1;
    rsTm.FingerPrint2 := RltTrainmanArray[i].finger2;
    rsTm.Picture := RltTrainmanArray[i].pic;

    m_DBTrainman.SyncTrainman(rsTm);

  end;
end;

procedure TWebJob_TrainmanSync.DoUpdate;
var
  signature : RRltSignature;
  trainmanArray : TRltTrainmanArray;
begin
  inherited;
  if not Assigned(m_WaitWorkMgr) then
  begin
    m_WaitWorkMgr := TWaitWorkMgr.Create(self.UpdateManager.LocalDB);
  end;

  if not Assigned(m_DBTrainman) then
    m_DBTrainman := TRSdbLocalTrainman.Create(self.UpdateManager.LocalDB);

  //if  System.DebugHook = 1 then Exit;
  if GetSignature(signature) = False then Exit;
  if signature.result > 0 then
  begin
    InsertLogs('��ȡ����������Ա��Ϣ���������:' + signature.resultStr);
    exit;
  end;
  //if m_DBTrainman.GetSignature() <> '' then
  begin
    if signature.signature = m_DBTrainman.GetTrainmanSignature() then
    begin
      InsertLogs('����Ա��Ϣ�������!');
      Exit;
    end;
  end;

  InsertLogs('��ʼͬ����Ա��Ϣ');
  try
    if not GetTrainmanList(rlttoFinger,0,20,trainmanArray) then
    begin
      InsertLogs('��ȡ����Ա��Ϣʧ��!');
      Exit;
    end;
  except on e:Exception do
    begin
      InsertLogs('ͬ��ʧ��!'+ e.Message);
      Exit;
    end;
  end;
  m_DBTrainman.SetTrainmanSignature(signature.signature) ;
  m_DBTrainman.SetFingerSignature(NewGUID);
  InsertLogs('��Ա��Ϣͬ������!');

end;


function TWebJob_TrainmanSync.GetSignature(out SignatureRlt: RRltSignature):Boolean;
var
  Generic: TGenericData;
  rHttp: string;
  strResponse : string;
begin
  result := False;
  try
	  strResponse := m_webIF.HttpComm.Get(Format(ADDRESS_Trainman_Signature + '?cid=%s',
          [m_webIF.webConfig.strHost,m_webIF.webConfig.strCID]));
  except on e:Exception do
    begin
      InsertLogs('��ȡָ����������:'+e.Message);
      Exit;
    end;
  end;
  rHttp := Utf8ToAnsi(strResponse);
  Generic := TGenericData.Create;
  try
    Generic.JSON :=rHttp;
    SignatureRlt.result := Generic.IntField['result'];
    SignatureRlt.resultStr := Generic.StrField['resultStr'];
    SignatureRlt.signature := Generic.StrField['signature'];
  finally
    Generic.Free;
  end;
  result := True;
end;

function TWebJob_TrainmanSync.GetTrainmanList( Option: TRltTrainmanOption; NID,
    PageCount: integer; out TrainmanArray: TRltTrainmanArray): boolean;
var
  strUrl : string;
  strResponse : string;
  iJSON: ISuperObject;
  maxID : integer;
  i: Integer;
  genericData :  TGenericData;
  ms : TMemoryStream;
begin
  result := false;
  maxID := NID;
  while True do
  begin
    if self.bStop then Exit;

    {Inc(index);
    m_nTime := GetTickCount();  }
    strUrl := Format(ADDRESS_Trainman_TrainmanList + '?cid=%s&option=%d&nid=%d&count=%d',
      [m_webIF.webConfig.strHost,m_webIF.webConfig.strCID,Ord(Option),maxID,PageCount]);
    strResponse := m_webIF.HttpComm.Get(strUrl);

    strResponse := Utf8ToAnsi(strResponse);
    iJSON := SO(strResponse);

    //��̨ҳ�����
    if (iJSON.I['result'] > 0) then exit;

    SetLength(TrainmanArray,iJSON.A['trainmanList'].Length);
    for i := 0 to iJSON.A['trainmanList'].Length - 1 do
    begin
      genericData := TGenericData.Create;
      try
        genericData.JSON :=iJSON.A['trainmanList'][i].AsString;
        TrainmanArray[i].nID := iJSON.A['trainmanList'][i].I['nid'];
        TrainmanArray[i].trainmanid :=iJSON.A['trainmanList'][i].S['trainmanid'];
        TrainmanArray[i].trainmanNumber :=iJSON.A['trainmanList'][i].S['trainmanNumber'];
        TrainmanArray[i].trainmanName :=iJSON.A['trainmanList'][i].S['trainmanName'];
        ms := TMemoryStream.Create;
        try
          ms.Clear;
          genericData.GetBlobField('finger1',ms);
          TrainmanArray[i].finger1 := StreamToTemplateOleVariant(ms);
            
          ms.Clear;
          genericData.GetBlobField('finger2',ms);
          TrainmanArray[i].finger2 :=StreamToTemplateOleVariant(ms);

          ms.Clear;
          genericData.GetBlobField('pic',ms);
          TrainmanArray[i].pic := StreamToTemplateOleVariant(ms);
        finally
          ms.Free;
        end;
      finally
        genericData.Free;
      end;
    end;

    UpdateTrainmanProgress(iJSON.I['index'],iJSON.I['totalCount'],iJSON.I['nid'],TrainmanArray);

    maxID :=  iJSON.I['nid'];
    if PageCount > length(TrainmanArray) then
    begin
      result := true;
      exit;
    end;

  end;
end;



end.

