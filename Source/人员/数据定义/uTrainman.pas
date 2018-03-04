unit uTrainman;

interface
uses
  Classes,Graphics,uSaftyEnum;

type

  //˾����Ϣ
  RRsTrainman = record
    //˾��GUID
    strTrainmanGUID: string;
    //˾������
    strTrainmanName: string;
    //˾������
    strTrainmanNumber: string;
    //ְλ
    nPostID: TRsPost;
    //ְλ����
    strPostName : string;
    //��������GUID
    strWorkShopGUID : string;
    //������������
    strWorkShopName  :string;
   {ָ��1}
    FingerPrint1 : OleVariant;
    {ָ��1�ձ�־,��λ0,����Ϊ1}
    nFingerPrint1_Null:Integer;
    {ָ��2}
    FingerPrint2 : OleVariant;
    {ָ��2�ձ�־,��λ0,����Ϊ1}
    nFingerPrint2_Null:Integer;
    //�����Ƭ
    Picture : OleVariant;
    //��Ƭ�ձ�־,��λ0,����Ϊ1
    nPicture_Null:Integer;
    //ָ����GUID
    strGuideGroupGUID : string;
    //ָ��������
    strGuideGroupName : string;
    //��ϵ�绰
    strTelNumber: string;
    //�ֻ���
    strMobileNumber : string;
    //��ͥסַ
    strAdddress  :string;
    //��ʻ����
    nDriverType : TRsDriverType;
    strDriverTypeName:string;
    //�а�״̬
    nCallWorkState :TRsCallWorkState ;
    //�а�ʱ��
    strCallWorkGUID:string;
    //�ؼ���(0,1)
    bIsKey : integer;
    //��ְ����
    dtRuZhiTime : TDateTime;
    //��ְ����
    dtJiuZhiTime : TDateTime;
    //1��2��3
    nDriverLevel : integer;
    //ABCD
    strABCD : string;
    //��ע
    strRemark : string;
    //�ͻ�ID
    nKeHuoID : TRsKehuo;
    //�ͻ�����
    strKeHuoName : string;
    //��������
    strTrainJiaoluGUID : string;
    //������Ա��·
    strTrainmanJiaoluGUID:string;
    //��������
    strTrainJiaoluName  :string;
    //�������ʱ��
    dtLastEndworkTime : TDateTime;
    //�����Ԣʱ��
    dtLastInRoomTime:TDateTime;
    //����Ԣʱ��
    dtLastOutRoomTime:TDateTime;
    //�����GUID
    strAreaGUID:string;
    //�������
    nID : Integer;
    //����ʱ��
    dtCreateTime : TDateTime;
    //״̬
    nTrainmanState: TRsTrainmanState;
    //������ƴ
    strJP : string;
  public
    procedure Assign(Trainman : RRsTrainman);
  end;
  TRsTrainmanArray = array of RRsTrainman;


   


  //��Ա״̬ͳ����Ϣ
  RTrainmanStateCount = record
    nUnRuning :Integer; {����ת}
    nReady:Integer;  {Ԥ��}
    nNormal:Integer;  {������������}
    nPlaning:Integer;  {�Ѱ��żƻ�}
    nInRoom:Integer;  {����Ԣ}
    nOutRoom:Integer;  {����Ԣ}
    nRuning:Integer;  {�ѳ���}
    nNil:Integer; {����Ա}
  end;




  ///˾����Ϣ��ѯ����
  RRsQueryTrainman = record
    //���ţ���Ϊ����
    strTrainmanNumber : string;
    //��������Ϊ����
    strTrainmanName : string;
    //�������䣬��Ϊ����
    strWorkShopGUID : string;
    //������Ϣ
    strTrainJiaoluGUID : string;
    //ָ����
    strGuideGroupGUID : string;
    //�ѵǼ�ָ��������-1Ϊ����
    nFingerCount : integer;
    //�Ƿ�����Ƭ��-1Ϊ����
    nPhotoCount : integer;
    //�������Ϣ
    strAreaGUID:string;
  end;
  //����Ա�����Ϣ
  RRsTrainmanLeaveInfo = record
    Trainman : RRsTrainman;
    strLeaveTypeGUID : string;
    strLeaveTypeName  :string;
  end;


  //�����Ϣͳ��
  RRsTrainmanLeaveCount = record
  //ɥ��
    nBereavement:Integer;
  //����
    nSick:Integer;
  //̽�׼�
    nVisit:Integer;
  //����
    nSingle:Integer;
  //���ݼ�
    nAnnual:Integer;
  //��ѵ
    nTrain:Integer;
  //���
    nMarriage:Integer;
  //�¼�
    nCasual :Integer;
  //����
    nOther:Integer;
  end;

  //��Ա��·ͳ��
  RRsTrainJiaoLuCount = record
    //��·����
    strJiaoLuName : string;
    //��Ա����
    nCount:Integer;
  end;

  TRsTrainJiaoLuCountArray = array of   RRsTrainJiaoLuCount;


  TRsTrainmanLeaveArray = array of RRsTrainmanLeaveInfo;
const
  /// <summary>��ͬ״̬��Ա������ɫ</summary>
  TRsTrainmanStateFontColorAry: array[TRsTrainmanState] of TColor =
  (clBlack, clBlack, clBlack, clBlack, clBlack, clBlack, clBlack,clBlack);
  /// <summary>��ͬ״̬��Ա������ɫ</summary>
  TRsTrainmanStateBackColorAry: array[TRsTrainmanState] of TColor =
  (cl3DLight, clMoneyGreen, clMenuBar, clLime, clYellow, clSkyBlue, $00007EFF,cl3DLight);
  //ְλ
  TRsPostNameAry: array[TRsPost] of string = ('','˾��','��˾��','ѧԱ');
  TRsTrainmanStateNameAry:array[TRsTrainmanState] of string =
    ('����ת','Ԥ��','����','�ƻ�','��Ԣ','��Ԣ','����','��');
  TRsRegisterFlagNameAry : array[TRsRegisterFlag] of string = ('�ֶ�','ָ��');
  //��ʻ����
  TRsDriverTypeNameArray : array[TRsDriverType] of string = ('','N','D','O');
  //�ͻ�����
  TRsKeHuoNameArray : array[TRsKehuo] of string = ('','�ͳ�','����','����');
  
function GetTrainmanText(Trainman: RRsTrainman): string;

function GetTrainmanName(Trainman: RRsTrainman): string;

implementation
uses
  SysUtils;
function GetTrainmanText(Trainman: RRsTrainman): string;
begin
  result := '';
  if Trainman.strTrainmanGUID <> '' then
  begin
    Result := Format('%6s[%s]',[Trainman.strTrainmanName,Trainman.strTrainmanNumber])
  end;
end;

function GetTrainmanName(Trainman: RRsTrainman): string;
begin
  result := '';
  if Trainman.strTrainmanGUID <> '' then
  begin
    Result := Format('%6s',[Trainman.strTrainmanName])
  end;
end;

{ RTrainman }

procedure RRsTrainman.Assign(Trainman: RRsTrainman);
begin
  
end;

end.

