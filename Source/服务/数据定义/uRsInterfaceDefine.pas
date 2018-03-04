unit uRsInterfaceDefine;

interface
uses
  uLKJson,SysUtils,superobject,Windows;
type
  
  {TRegisterFlag ����Ա��ݵǼ����}
  TRegisterFlag  = (rfFingerprint{ָ��},rfInput{�ֶ�����},rfICCar{IC��});
  
  {��ƽ������}
  TTestAlcoholResult = (taNormal{�������},taAlcoholContentMiddling{�ƾ�������},
      taAlcoholContentHeight{�ƾ�������},taNoTest{δ����},tsError{���Թ���});

  {����Ա�¼�����}
  TCWYEventType = (cweInRoom = 1,cweOutRoom,cweYanKa,cweBeginWork,cweEndWork);

  {RRSBFCWYEvent ���ɳ���Ա�¼�}
  RRSBFCWYEvent = record
  const
    SJBS = 'SJ_CWY';
  public
    SJSJ: string;     //�¼�ʱ��,��ʽYYYYMMDDHHNNSS
    CWYID: string;    //����Ա����
    CWYXM: string;    //����Ա����
    CQSJ: string;     //����ʱ��
    CYSJ: string;     //��Ԣʱ��
    SJLX: string;     //�¼����� 01����Ԥ��
    CJMS: string;     //�¼�����
    CX: string;       //����
    CH: string;       //����
    CC: string;       //����
    DWH: string;      //��λ��
    {Ϊֵ������(1���������ࡢ2����˫˾����3����˾��)}
    tmtype : string;
    {�ͻ�����(1����ͳ���2����𳵡�3�������)}
    kh : string;
    {Ϊ��ɫ����ʱ������λΪ����}
    outMinutes : string;
    {��ɫԤ��ʱ������λΪ����}
    alarmMinutes : string;    
  end;

  {RRSBFJCEvent ���ɻ����¼�}
  RRSBFJCEvent = record
  const
    SJBS = 'SJ_JC';
  public
    SJSJ: string;     //�¼�ʱ��,��ʽYYYYMMDDHHNNSS
    CWYID1: string;   //����Ա����
    CWYID2: string;   //����Ա����
    CC: string;       //����
    CX: string;       //����
    CH: string;       //����
    JLH: string;      //��·��
    CZH: string;      //��վ��
    KH: string;       //�ͻ�
    CZBZ: string;     //�¼���־{1-����,2-���,3-ͣ��,4-����}
  end;

  {RRSBFZhengBeiEvent �����������¼�}
  RRSBFZhengBeiEvent = record
  const
    SJBS = 'SJ_ZBC';
  public
    SJSJ: string;     //�¼�ʱ��,��ʽYYYYMMDDHHNNSS
    ZBC_BS: string;   //��������ʶ
    CX: string;       //����
    CH: string;       //����
    GDH: string;      //�ɵ���
    JCZT:string;      //����״̬
    SJLX: string;     //�¼�����
    X: string;        //X����
    Y: string;        //Y����
    CDKD: string;     //���������
    CDGD: string;     //�������߶�
  end;

  {RTrainState ����״̬�ı�}
  RTrainStateChange = Record
  public
    ID : Integer;
    //����
    strLocoType : String;
    //����
    strLocoNum : String;
    //״̬
    nState : Integer;
    //ʱ��
    dtStateTime : TDateTime;
    //������ID
    strDWH : String;
  end;
  {����״̬����}
  TTrainStateChanges = array of RTrainStateChange;


  RRsBFCtqEvent = record
  const
    SJBS = 'SJ_CTQ';
  public
    SJSJ: string;     //�¼�ʱ��,��ʽYYYYMMDDHHNNSS
    DWH: string;      //��λ��
    CWYID: string;    //����Ա����
    CWYXM: string;    //����Ա����
    CJJG: string;     //��ƽ��,0δ���ԡ�1������2���ơ�3���
    SJLX: string;     //�¼�����,1��Ԣ��2���ڡ�3���ڡ�4��Ԣ
  public
    function ToJSON(): string;
    procedure SetTestResult(nRsTestResult: Integer);    
  end;


  {����Ա�¼�}
  RRSCWYEvent = record
    {�¼�ʱ��}
    etime: TDateTime;
    {����Ա����}
    tmid: string;
    {����Ա����}
    tmname: string;
    {TMISվ��}
    stmis: Integer;
    {���״̬:0}
    nresult: Integer;
    {��֤��ʽ}
    nVerify: Integer;
    {������Ϣ}
    strResult: string;
    {�¼���־}
    sjbz: TCWYEventType;
  end;

  TRSCWYEvent = array of RRSCWYEvent;

  {���м�¼�¼�}
  RRSRTFileEvent = record
    nID: Integer;
    {����ʱ��}
    dtKaiCheTime: TDateTime;
    {��վʱ��}
    dtEnterStationTime: TDateTime;
    {�ļ�����ʱ��}
    dtFileEndTime: TDateTime;
    {����Ա����}
    tmid1: string;
    {����Ա����}
    tmid2: string;
  end;

  {����Ԥ����Ϣ}
  RRSOverWorkRecord = record
    {��¼ID}
    nID: string;
    {����Ա����}
    tmid: string;
    {����Ա����}
    tmname: string;
    {�����ͺ�}
    strTrainType: string;
    {������}
    strTrainNumber: string;
    {����}
    strCheCi: string;
    {��λ��}
    strDWH: string;
    {����ʱ��}
    dtBeginWorkTime: string;
    {��Ԣʱ��}
    dtOutroomTime: string;
    {�¼���־}
    sjbz: Integer;
    {��ע}
    strRemark: string;
    {Ϊֵ������(1���������ࡢ2����˫˾����3����˾��)}
    tmtype : string;
    {�ͻ�����(1����ͳ���2����𳵡�3�������)}
    kh : string;
    {Ϊ��ɫ����ʱ������λΪ����}
    outMinutes : string;
    {��ɫԤ��ʱ������λΪ����}
    alarmMinutes : string;
  end;
  PRSOverWorkRecord = ^RRSOverWorkRecord;
  
  TYanKaResultType =(rtSame{һ��},rtUnsame{��һ��},rtManul{�˹��鿨});
  {�鿨��¼}
  RYanKaRecord = record
    {�鿨ʱ��}
    dtTestTime: TDateTime;
    {�鿨�ص�}
    strPlace: string;
    {����}
    strGh: string;
    {����}
    strName: string;
    {��ʾ����}
    JieShiCount: string;
    {���ٽ�ʾ����}
    LimiteCount: string;
    {�����ʾ����}
    SpecialCount: string;
    {��׼��ʾ����}
    nStandJieShi: string; 
    {�鿨���}
    strResult: string;{�ϸ񣬲��ϸ��˹��鿨}
  end;

  {�����¼�����}
  TJCEventType = (jceChuKu = 1,jceRuKu,jceTingChe,jceKaiChe,jceFileBegin,
    jceFileEnd,jceEnterStation=7,jceLeaveStation=8,jceDiaoCheStart=9,jceDiaoCheStop=10,
    jceChangeTrainman=11);

  {�����¼�}
  RRSJCEvent = record
    {�¼�ʱ��}
    etime: TDateTime;
    {����Ա����}
    tmid1: string;
    {����Ա����}
    tmid2: string;
    {TMISվ��}
    stmis: Integer;
    {����}
    cx: string;
    {����}
    ch: string;
    {����}
    cc: string;
    {�¼���־}
    sjbz: TJCEventType;
  end;

  PRSJCEvent = ^RRSJCEvent;

  {TZBEventType �������¼�����}
  TZBEventType = (zbAdd = 1{���},zbDel{ɾ��},zbEdit{�޸�});
  {TZBJCZTState ��������״̬}
  TZBJCZTState = (jcsOther{����},jcsChangBei{����},jcsDuanBei{�̱�},jcsLinXiu{����},
    jcsXiuCheng{�޳�},jcsZhengBei{����},jcsDaiYong{����});

  {RRSZhengBeiXX ������Ϣ}
  RRSZhengBeiXX = record
    {���ݿ��¼ID}
    nid: Integer;
    {�¼�ʱ��}
    etime: TDateTime;
    {վ��}
    stmis: Integer;
    {����}
    cx: string;
    {����}
    ch: string;
    {�¼�����}
    sjlx: TZBEventType;
    {�ɵ���}
    gdh: string;
    {��������ʶ}
    zbcbs: string;
    {����״̬}
    jczt: TZBJCZTState;
    {x����}
    xPos: Double;
    {y����}
    yPos: Double;
    {���������}
    cdkd: Integer;
    {�������߶�}
    cdgd: Integer;
  end;



  {����:��������Ϣת��Ϊ�����������ṹ}
  function ZBCXXToBFZBCEvent(ZBCXX: RRSZhengBeiXX): RRSBFZhengBeiEvent;
  {����:������Ա�¼�ת��ΪJSON}
  function BFCWYEventToJson(BFCWYEvent: RRSBFCWYEvent): string;
  {����:���ɻ����¼�ת��ΪJSON}
  function BFJCEventToJson(JCEvent: RRSBFJCEvent): string;
  {����:�����������¼�ת��ΪJSON}
  function BFZhengBeiEventToJson(BFZhengBeiEvent: RRSBFZhengBeiEvent): string;
  function OverWorkRecordToBFCWYEvent(DWH: string;OverWorkRecord: RRSOverWorkRecord): RRSBFCWYEvent;
  {����:JSONת��Ϊ���ɻ����¼�}
  function JsonToBFJCEvent(strJson: string): RRSBFJCEvent;
const
  TZBJCZTStateArray : array[TZBJCZTState] of string =
    ('����','����','�̱�','����','�޳�','����','����');
  TCWYEventTypeName : array[TCWYEventType] of string =
    ('��Ԣ','��Ԣ','�鿨','����','����');

implementation
function OverWorkRecordToBFCWYEvent(DWH: string;OverWorkRecord: RRSOverWorkRecord): RRSBFCWYEvent;
begin
  Result.CQSJ := OverWorkRecord.dtBeginWorkTime;
  Result.CYSJ := OverWorkRecord.dtOutroomTime;
  Result.SJLX := Format('%.2d',[OverWorkRecord.sjbz]);
  Result.CJMS := OverWorkRecord.strRemark;
  Result.SJSJ := FormatDateTime('yyyyMMddhhnnss',Now);
  Result.SJLX := '01';
  Result.CJMS := OverWorkRecord.strRemark;
  Result.CX := OverWorkRecord.strTrainType;
  Result.CH := OverWorkRecord.strTrainNumber;
  Result.CC := OverWorkRecord.strCheCi;
  Result.DWH := DWH;

  Result.CWYID := OverWorkRecord.tmid;
  Result.CWYXM := OverWorkRecord.tmname;
  
  Result.tmtype := OverWorkRecord.tmtype;
  Result.kh := OverWorkRecord.kh;
  Result.outMinutes := OverWorkRecord.outMinutes;
  Result.alarmMinutes := OverWorkRecord.alarmMinutes;
end;
function ZBCXXToBFZBCEvent(ZBCXX: RRSZhengBeiXX): RRSBFZhengBeiEvent;
{����:��������Ϣת��Ϊ�����������ṹ}
begin
  Result.SJSJ := FormatDateTime('YYYYMMDDHHNNSS',ZBCXX.etime);
  Result.ZBC_BS := ZBCXX.zbcbs;
  Result.CX := ZBCXX.cx;
  Result.CH := ZBCXX.ch;
  Result.GDH := ZBCXX.gdh;
  Result.JCZT := Format('%.2d',[Integer(ZBCXX.jczt)]);
  Result.SJLX := Format('%.2d',[Integer(ZBCXX.sjlx)]);
  Result.X := FloatToStr(ZBCXX.xPos);
  Result.Y := FloatToStr(ZBCXX.yPos);
  Result.CDKD := IntToStr(ZBCXX.cdkd);
  Result.CDGD := IntToStr(ZBCXX.cdgd);
end;
function JsonToBFJCEvent(strJson: string): RRSBFJCEvent;
var
  JSONObject : TlkJSONObject;
begin
  JSONObject := TlkJSON.ParseText(strJson) as TlkJSONobject;
  try
    Result.SJSJ := JSONObject.getString('SJSJ');
    Result.CWYID1 := JSONObject.getString('CWYID1');
    Result.CWYID2 := JSONObject.getString('CWYID2');
    Result.CC := JSONObject.getString('CC');
    Result.CX := JSONObject.getString('CX');
    Result.CH := JSONObject.getString('CH');
    Result.JLH := JSONObject.getString('JLH');
    Result.CZH := JSONObject.getString('CZH');
    Result.CZBZ := JSONObject.getString('CZBZ');
    Result.KH := JSONObject.getString('KH');
  finally
    JSONObject.Free;
  end;
end;


function BFZhengBeiEventToJson(BFZhengBeiEvent: RRSBFZhengBeiEvent): string;
var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',BFZhengBeiEvent.SJBS);
    JSONObject.Add('SJSJ',BFZhengBeiEvent.SJSJ);
    JSONObject.Add('ZBC_BS',BFZhengBeiEvent.ZBC_BS);
    JSONObject.Add('CX',BFZhengBeiEvent.CX);
    JSONObject.Add('CH',BFZhengBeiEvent.CH);
    JSONObject.Add('GDH',BFZhengBeiEvent.GDH);
    JSONObject.Add('JCZT',BFZhengBeiEvent.JCZT);
    JSONObject.Add('SJLX',BFZhengBeiEvent.SJLX);
    JSONObject.Add('JCX',BFZhengBeiEvent.X);
    JSONObject.Add('JCY',BFZhengBeiEvent.Y);
    JSONObject.Add('CDKD',BFZhengBeiEvent.CDKD);
    JSONObject.Add('CDGD',BFZhengBeiEvent.CDGD);
    Result := TlkJSON.GenerateText(JSONObject);

  finally
    JSONObject.Free;
  end;
end;
function BFCWYEventToJson(BFCWYEvent: RRSBFCWYEvent): string;
var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',BFCWYEvent.SJBS);
    JSONObject.Add('SJSJ',BFCWYEvent.SJSJ);
    JSONObject.Add('CWYID',BFCWYEvent.CWYID);
    JSONObject.Add('CWYXM',BFCWYEvent.CWYXM);
    JSONObject.Add('CQSJ',BFCWYEvent.CQSJ);
    JSONObject.Add('CYSJ',BFCWYEvent.CYSJ);
    JSONObject.Add('SJLX',BFCWYEvent.SJLX);
    JSONObject.Add('CJMS',BFCWYEvent.CJMS);
    JSONObject.Add('CX',BFCWYEvent.CX);
    JSONObject.Add('CH',BFCWYEvent.CH);
    JSONObject.Add('CC',BFCWYEvent.CC);
    JSONObject.Add('DWH',BFCWYEvent.DWH);

    JSONObject.Add('tmtype',BFCWYEvent.tmtype);
    JSONObject.Add('kh',BFCWYEvent.kh);
    JSONObject.Add('outMinutes',BFCWYEvent.outMinutes);
    JSONObject.Add('alarmMinutes',BFCWYEvent.alarmMinutes);
    
    Result := TlkJSON.GenerateText(JSONObject);

  finally
    JSONObject.Free;
  end;
end;

function BFJCEventToJson(JCEvent: RRSBFJCEvent): string;
var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',JCEvent.SJBS);
    JSONObject.Add('SJSJ',JCEvent.SJSJ);
    JSONObject.Add('CWYID1',JCEvent.CWYID1);
    JSONObject.Add('CWYID2',JCEvent.CWYID2);
    JSONObject.Add('CC',JCEvent.CC);
    JSONObject.Add('CX',JCEvent.CX);
    JSONObject.Add('CH',JCEvent.CH);
    JSONObject.Add('JLH',JCEvent.JLH);
    JSONObject.Add('CZH',JCEvent.CZH);
    JSONObject.Add('CZBZ',JCEvent.CZBZ);
    
    Result := TlkJSON.GenerateText(JSONObject);

  finally
    JSONObject.Free;
  end;
end;

{ RRsBFCtqEvent }

procedure RRsBFCtqEvent.SetTestResult(nRsTestResult: Integer);
begin
  case nRsTestResult of
    //taNormal
    0: CJJG := '1';
    //taAlcoholContentMiddling
    1: CJJG := '2';
    //taAlcoholContentHeight
    2: CJJG := '3';
    //taNoTest,//tsError
    3,4: CJJG := '0';
  end;
end;

function RRsBFCtqEvent.ToJSON: string;
//var
//  iJSON: ISuperObject;
//begin
//  iJSON := SO();
//  iJSON.S['SJBS'] := SJBS;
//  iJSON.S['SJSJ'] := SJSJ;
//  iJSON.S['DWH'] := DWH;
//  iJSON.S['CWYID'] := CWYID;
//  iJSON.S['CWYXM'] := CWYXM;
//  iJSON.S['CJJG'] := CJJG;
//  iJSON.S['SJLX'] := SJLX;
//  Result := iJSON.AsString;
//  iJSON := nil;
//end;

var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',SJBS);
    JSONObject.Add('SJSJ',SJSJ);
    JSONObject.Add('DWH',DWH);
    JSONObject.Add('CWYID',CWYID);
    
    JSONObject.Add('CWYXM',WideString(CWYXM));
    JSONObject.Add('CJJG',CJJG);
    JSONObject.Add('SJLX',SJLX);    
    Result := TlkJSON.GenerateText(JSONObject);
  finally
    JSONObject.Free;
  end;
end;

end.
