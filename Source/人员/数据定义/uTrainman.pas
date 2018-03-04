unit uTrainman;

interface
uses
  Classes,Graphics,uSaftyEnum;

type

  //司机信息
  RRsTrainman = record
    //司机GUID
    strTrainmanGUID: string;
    //司机姓名
    strTrainmanName: string;
    //司机工号
    strTrainmanNumber: string;
    //职位
    nPostID: TRsPost;
    //职位名称
    strPostName : string;
    //所属车间GUID
    strWorkShopGUID : string;
    //所属车间名称
    strWorkShopName  :string;
   {指纹1}
    FingerPrint1 : OleVariant;
    {指纹1空标志,空位0,不空为1}
    nFingerPrint1_Null:Integer;
    {指纹2}
    FingerPrint2 : OleVariant;
    {指纹2空标志,空位0,不空为1}
    nFingerPrint2_Null:Integer;
    //测酒照片
    Picture : OleVariant;
    //照片空标志,空位0,不空为1
    nPicture_Null:Integer;
    //指导组GUID
    strGuideGroupGUID : string;
    //指导组名称
    strGuideGroupName : string;
    //联系电话
    strTelNumber: string;
    //手机号
    strMobileNumber : string;
    //家庭住址
    strAdddress  :string;
    //驾驶工种
    nDriverType : TRsDriverType;
    strDriverTypeName:string;
    //叫班状态
    nCallWorkState :TRsCallWorkState ;
    //叫班时间
    strCallWorkGUID:string;
    //关键人(0,1)
    bIsKey : integer;
    //入职日期
    dtRuZhiTime : TDateTime;
    //就职日期
    dtJiuZhiTime : TDateTime;
    //1、2、3
    nDriverLevel : integer;
    //ABCD
    strABCD : string;
    //备注
    strRemark : string;
    //客货ID
    nKeHuoID : TRsKehuo;
    //客货名称
    strKeHuoName : string;
    //所属区段
    strTrainJiaoluGUID : string;
    //所属人员交路
    strTrainmanJiaoluGUID:string;
    //区段名称
    strTrainJiaoluName  :string;
    //最后退勤时间
    dtLastEndworkTime : TDateTime;
    //最后入寓时间
    dtLastInRoomTime:TDateTime;
    //最后出寓时间
    dtLastOutRoomTime:TDateTime;
    //机务段GUID
    strAreaGUID:string;
    //自增编号
    nID : Integer;
    //创建时间
    dtCreateTime : TDateTime;
    //状态
    nTrainmanState: TRsTrainmanState;
    //姓名简拼
    strJP : string;
  public
    procedure Assign(Trainman : RRsTrainman);
  end;
  TRsTrainmanArray = array of RRsTrainman;


   


  //人员状态统计信息
  RTrainmanStateCount = record
    nUnRuning :Integer; {非运转}
    nReady:Integer;  {预备}
    nNormal:Integer;  {正常或已退勤}
    nPlaning:Integer;  {已安排计划}
    nInRoom:Integer;  {已入寓}
    nOutRoom:Integer;  {已离寓}
    nRuning:Integer;  {已出勤}
    nNil:Integer; {空人员}
  end;




  ///司机信息查询条件
  RRsQueryTrainman = record
    //工号，空为所有
    strTrainmanNumber : string;
    //姓名，空为所有
    strTrainmanName : string;
    //所属车间，空为所有
    strWorkShopGUID : string;
    //区段信息
    strTrainJiaoluGUID : string;
    //指导组
    strGuideGroupGUID : string;
    //已登记指纹数量，-1为所有
    nFingerCount : integer;
    //是否有照片，-1为所有
    nPhotoCount : integer;
    //机务段信息
    strAreaGUID:string;
  end;
  //乘务员请假信息
  RRsTrainmanLeaveInfo = record
    Trainman : RRsTrainman;
    strLeaveTypeGUID : string;
    strLeaveTypeName  :string;
  end;


  //请假信息统计
  RRsTrainmanLeaveCount = record
  //丧假
    nBereavement:Integer;
  //病假
    nSick:Integer;
  //探亲假
    nVisit:Integer;
  //单牌
    nSingle:Integer;
  //年休假
    nAnnual:Integer;
  //培训
    nTrain:Integer;
  //婚假
    nMarriage:Integer;
  //事假
    nCasual :Integer;
  //其他
    nOther:Integer;
  end;

  //人员交路统计
  RRsTrainJiaoLuCount = record
    //交路名字
    strJiaoLuName : string;
    //人员个数
    nCount:Integer;
  end;

  TRsTrainJiaoLuCountArray = array of   RRsTrainJiaoLuCount;


  TRsTrainmanLeaveArray = array of RRsTrainmanLeaveInfo;
const
  /// <summary>不同状态人员字体颜色</summary>
  TRsTrainmanStateFontColorAry: array[TRsTrainmanState] of TColor =
  (clBlack, clBlack, clBlack, clBlack, clBlack, clBlack, clBlack,clBlack);
  /// <summary>不同状态人员背景颜色</summary>
  TRsTrainmanStateBackColorAry: array[TRsTrainmanState] of TColor =
  (cl3DLight, clMoneyGreen, clMenuBar, clLime, clYellow, clSkyBlue, $00007EFF,cl3DLight);
  //职位
  TRsPostNameAry: array[TRsPost] of string = ('','司机','副司机','学员');
  TRsTrainmanStateNameAry:array[TRsTrainmanState] of string =
    ('非运转','预备','正常','计划','入寓','离寓','出勤','空');
  TRsRegisterFlagNameAry : array[TRsRegisterFlag] of string = ('手动','指纹');
  //驾驶工种
  TRsDriverTypeNameArray : array[TRsDriverType] of string = ('','N','D','O');
  //客货种类
  TRsKeHuoNameArray : array[TRsKehuo] of string = ('','客车','货车','调车');
  
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

