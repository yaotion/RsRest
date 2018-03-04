unit uGlobalDM;

interface

uses
  Windows, SysUtils, Classes, DB, ADODB,Forms,Messages,uDutyUser, uTFDBAutoConnect,
  StdCtrls,RzTray,uTFSystem,uSite,ZKFPEngXControl_TLB,MMSystem,
  uApparatus,ZKFPEngXUtils,uDBTrainman,uTrainman, uDBSite,AdvGrid,
  Graphics,uLogs,jpeg,Variants,ExtCtrls,uTFVariantUtils,  XMLDoc, XMLIntf,
  CommCtrl,uTFSqlConn,uTFMessageComponent, RzCommon,uLocalTrainman ,IdHTTP,uLogManage,
  DBXpress, WideStrings, SqlExpr,uDBLocalTrainman,DateUtils,uWebIF,uDutyPlace,StrUtils,uRoomCallApp;
const
  StrGridVisibleFile = 'FormColVisibles.ini';
  HISTROYFILE = 'histroy.ini';
const
  WM_MSGFingerCapture = WM_User + 11;
  WM_MSGFingerEnorll = WM_USER + 12;
  WM_MSGImageReceived = WM_USER + 13;
  WM_MSGFeatureInfo = WM_USER + 14;



type

  TGlobalDM = class(TDataModule)
    ADOConnection: TADOConnection;
    TFDBAutoConnect: TTFDBAutoConnect;
    FrameController: TRzFrameController;
    LocalADOConnection: TADOConnection;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure TFDBAutoConnectConnect(Sender: TObject);
    procedure TFDBAutoConnectDisConnect(Sender: TObject);
  private
    { Private declarations }
    {ָ���Ǹ��ٻ���ռ�}
    m_fpcHandle: Integer;

    //����ָ���ǹ㲥��Ϣ�ľ������
    m_FingerMsgList : TStrings;
    //����ָ����Ϣ�ľ��
    m_FingerMsgHandle : Integer;
    //ָ���Ƿ���ִ����
    m_bFingerCaptureing : boolean;
    //ָ�ƻ�������������
    m_FingerBufferManage: TFingerBufferManage;
    //web�ӿڲ���
    //m_webIF:TWebIF;
    //WEB��ַ
    m_strWebHost: string;

    //��Ϣҳ���ַ
    m_strWebMessagePage: string;


    procedure WndProc(var Msg : TMessage);
  public
    {ָ�Ƽ����¼�֪ͨ}
    OnReadFingerprintTemplatesChangeEvent : TOnReadChangeEvent;
    {ָ�Ƽ������}
    OnReadFingerprintTemplatesComplete : TOnEvent;
 public   
    {�����û�ָ�ƵǼ�֪ͨ}
    OnFingerLoginSuccess: TOnEventByString;
    {�û�ָ�ƵǼ�ʧ��}
    OnFingerLoginFailure : TNotifyEvent;
    {ָ���ǰ����¼�֪ͨ}
    OnFingerTouching: TNotifyEvent;
  public
    //�����ݿ�����
    OnDBConnected : TNotifyEvent;
    //�����ݿ�Ͽ�
    OnDBDisconnected : TNotifyEvent;
  private
    procedure OnMessageError(strErr: string);
    {����:ָ��ʶ��}
    procedure FingerCaptureProc(ASender: TObject; ActionResult: WordBool; ATemplate: OleVariant);
    procedure FingerCaptureProcAccess(ASender: TObject; ActionResult: WordBool; ATemplate: OleVariant);
    procedure LocalFingerCaptureProc(ASender: TObject; ActionResult: WordBool; ATemplate: OleVariant);
    //ָ�ư��µ���Ϣ
    procedure FingerTouchingProc(Sender : TObject);

    {����:��ȡ����ָ������}
    function GetLocalFingerLibGUID: string;
    {����:��ȡ���ع���վ��}
    function GetLocalSiteName: string;
    {����:���ñ��ع���վ��}
    procedure SetLocalSiteName(const Value: string);
    {����:�����Ƿ�����ģʽ}
    procedure SetLeaveLine(bLeaveLine:Boolean);
    {����:��ȡ�Ƿ�����ģʽ}
    function GetLeaveLine():Boolean;


    {����:��ѯ�Ƿ��շ�����ʾ�ƻ�}
    function GetOrderByRoom():Boolean;
    {����:�����Ƿ��շ�����ʾ�ƻ�}
    procedure SetOrderByRoom(orderByRoom:Boolean);

    {����:��ѯ�Ƿ��ɰ�ʹ��}
    function GetUseByPaiBan():Boolean;
    {����:�����Ƿ��ɰ�ʹ��}
    procedure SetUseByPaiBan(useByPaiBan:Boolean);

    {����:��ѯ�Ƿ�����ָ��}
    function GetUseFinger():Boolean;
    {����:�����Ƿ��ɰ�ʹ��}
    procedure SetUseFinger(useFinger:Boolean);


    function GetAppPath: string;

    
    function GetConfigFileName: string;
    function GetSiteNumber: string;
    procedure SetSiteNumber(const Value: string);



    function GetLoadWaitWorkStartTime():TDateTime;
    procedure SetLoadWaitWorkStartTime(_dt:TDateTime);

    function GetLoadWaitWorkEndTime():TDateTime;
    procedure SetLoadWaitWorkEndTime(_dt:TDateTime);


    {����ǩ��}
    function GetUsesOutWorkSign():Boolean;
    procedure SetOutWorkSign(AUses:Boolean);

    {����ǩ��ʱ��}
    function GetShowSignPlanStartTime():TDateTime;
    procedure SetShowSignPlanStartTime(dtTime:TDateTime);


    {����:�Ƿ����õ绰¼��}
    function GetRecordTel():Boolean;
    {����:�Ƿ����õ绰¼��}
    procedure SetRecordTel(Value:Boolean);

     {����:�Ƿ���������¼��}
    function GetUninterruptedSign():Boolean;
    {����:�Ƿ���������¼��}
    procedure SetUninterruptedSign(Value:Boolean);


      {����:�Ƿ����÷����Һ���}
    function GetEnableServerRoomCall():Boolean;
    {����:�Ƿ����÷����Һ���}
    procedure SetEnableServerRoomCall(Value:Boolean);

    {���ܣ��Ƿ����ýа���Զ���Ԣ}
    function  GetAfterCallAutoLeaveRoom:boolean ;
    procedure SetAfterCallAutoLeaveRoom(Value:Boolean);

         {����:�Ƿ����÷���}
    function  GetEnableReverseCall:boolean ;
    procedure SetEnableReverseCall(Value:Boolean);

    {����:�Ƿ�����ͬʱ����}
    function  GetEnableOnesCall:boolean ;
    procedure SetEnableOnesCall(Value:Boolean);

    {���ܣ��Ƿ���ʾ���������湤��}
    function GetShowTrainmNumber:boolean;
    procedure SetShowTrainmNumber(Value:Boolean);

    {���ܣ��Ƿ�������Աѡ���б�ʽ,0�����빤��1:�����ƴ��ʽ}
    function GetShowUserList:Boolean;
    procedure SetShowUserList(Value:Boolean);

    {���ܣ��Ƿ����ô߽�}
    function GetUseReCall:boolean   ;
    procedure SetUseReCall(Value:Boolean);

    {���ܣ��Ƿ������Ԣǩ��}
    function GetUseInRoomSign:boolean;
    procedure  SetUseInRoomSign(Value:Boolean);

    {���ܣ��Ƿ��Զ�ƥ��ƻ�}
    function GetAutoMatchPlan:boolean;
    procedure   SetAutoMatchPlan(Value:Boolean);

    procedure SetRemeberUser(const Value: string);
    function GetRemeberUser():string;

    procedure SetRemeberPWD(const Value: string);
    function GetRemeberPWD():string;

    procedure SetAutoLogin(const Value: boolean);
    function GetAutoLogin():Boolean;

    procedure SetUIFont(Section:string;const Font:TFont);
    function  GetUIFont(Section:string):TFont;
  public
    { Public declarations }
    CurrentModule : TRsSiteJob;
    {ָ�������}
    ZKFPEngX : TZKFPEngX;
    //��ǰ�ͻ��˵ĳ��ڵ�
    DutyPlace :  RRsDutyPlace ;
    //��ǰ�ͻ��˵ĸ�λ
    SiteInfo : TRsSiteInfo;
    //��ǰ��¼ֵ��Ա��Ϣ
    DutyUser : TRsDutyUser;
    //���õ����ݿ����Ӳ���
    m_SQLConfig : TSQLConfig;
    //�������ݿ����Ӳ���
    m_SQLConfig_Local :TSQLConfig;
    //�Ƿ��Ǳ���ACCESS
    m_bIsAccessMode : Boolean ;
    //��Ա��Ϣ����
    m_LocalTrainmanArray: TRsLocalTrainmanArray;

    {ָ�����Ƿ��ʼ���ɹ�}
    FingerprintInitSuccess : Boolean;
    {ָ���ǳ�ʼ������ԭ��}
    FingerprintInitFailureReason : String;

    //ָ����ʶ�𼶱�(4-8)
    VLevel : Integer;
    MsgHandle : THandle;
    TFMessageCompnent: TTFMessageCompnent;
    LogManage: TLogManage;
    //FunModuleManager: TRsFunModuleManager;

    m_dbLocalTrainman:TRsDBLocalTrainman;
  private
    //�Ƿ��Ǳ���ģʽ
    m_blnIsLocalMode: boolean;
    
  public

    //���ر���������Ϣ
    procedure LoadConfig;
    procedure LoadDB_Config();
    procedure OpenMessageCompnent();
    //�������ݿ�
    procedure ConnecDB;
    //���ӱ���sqlserver
    procedure ConnectLocal_SQLDB;
    //���ӱ������ݿ�
    function ConnectLocalDB(strDatabase: WideString=''):Boolean;
    //�������ݿ�
    function ConAccessDB(adoCon: TADOConnection;strDatabase: WideString=''):Boolean;
    //�Զ��������ݿ���Ч
    procedure EnableAutoConnecDB;
    {����:����ָ������}
    procedure ReadFingerprintTemplates(ForceUpdate : BOOL);
    {����:����ָ������_����ACCESS���ݿ�}
    procedure ReadAccessFingerprintTemplate(ForceUpdate : BOOL);
    {����:���ر���ָ������}
    procedure LoadLocalFingerTemplates();
    {����:���汾��ָ������}
    procedure SaveLocalFingerTemplates();
    {����:ɾ������ָ������}
    procedure DeleteLocalFingerTemplates();
    {����:���ݹ��ŵõ�����˾����Ϣ}
    procedure GetLocalTrainmanByNumber(TrainmanNumber: string; out Trainman: RRsTrainman);
    {����:����һ������ָ������}
    procedure AddLocalFingerTemplate(Trainman: RRsTrainman);
    procedure UpdateLocalFingerTemplate(Trainman: RRsTrainman);
    procedure DeleteLocalFingerTemplate(strTrainmanGUID: string);
    {����:��ʼ��ָ����}
    function InitFingerPrintting(): Boolean;
    {����ָ��������}  //sw add
    procedure UpdateFingerTemplateByID(const nID:Integer;const fdata1,fdata2:OleVariant);
     //��ȡԶ�̷�������ǰʱ��
    function  GetNow : TDateTime;
    //��ȡָ��ʱ���ʱ�䷶Χ
    procedure GetTimeSpan(SourceTime : TDateTime;out BeginTime : TDateTime;out EndTime : TDateTime);
    //���������ļ�
    procedure PlaySoundFile(SoundFile: string);

    // ȡ���ֵ�ƴ��
    function GetHzPy(const AHzStr: AnsiString): AnsiString;
    //��TAB_System_Config��ȡ������Ϣ
    function DB_SysConfig(const SectionName,Ident: string): string;
    function SetDBSysConfig(const SectionName, Ident, Value: string): boolean;


    //��ȡ��վ�½ӿ�
    function  GetWebApiHost():string;
    //������վ�½ӿ�
    procedure SetWebApiHost(Host:string);
    //��ȡ��վ�Ϳͻ��˵ĶԽӽӿ�
    function GetWebUrl():string;
  public
    //�������п�
    procedure SaveGridColumnWidth(Grid: TAdvStringGrid);
    //���ñ���п�
    procedure SetGridColumnWidth(Grid: TAdvStringGrid);
    //�������п���
    procedure SaveGridColumnVisible(Grid: TAdvStringGrid);
    //���ñ���п���
    procedure SetGridColumnVisible(Grid: TAdvStringGrid);
    //��ѯ�������Ƿ���������
    function GetUpdateInfo(): boolean;


    //��ȡ����и�
    procedure ReadGridRowHeight(Grid: TAdvStringGrid);
    //���ñ���п�
    procedure WriteGridRowHeight(Grid: TAdvStringGrid);
  public

      //�Ƿ��ס����
    property RemeberUser: string read GetRemeberUser write SetRemeberUser;
    //��ס������
    property RemeberPWD: string read GetRemeberPWD write SetRemeberPWD;
    //�Ƿ��Զ���¼
    property AutoLogin: boolean read GetAutoLogin write SetAutoLogin;


    {����ָ�ƿ�����GUID}
    property LocalFingerLibGUID : string read GetLocalFingerLibGUID;
    {���ع���վ��}
    property LocalSiteName : string read GetLocalSiteName write SetLocalSiteName;
    //�������ݿ�ģʽ
    property blnIsLocalMode: boolean read m_blnIsLocalMode write m_blnIsLocalMode ;
    //���߷�ʽ
    property bLeaveLine :Boolean read GetLeaveLine write SetLeaveLine;
    //ǩ����
    property bUseByPaiBan:Boolean read GetUseByPaiBan write SetUseByPaiBan;
    //����ָ����
    property bUseFinger:Boolean read GetUseFinger write SetUseFinger;

    //���õ绰¼��
    property bRecorcdTel:Boolean read GetRecordTel write SetRecordTel;


    //��������¼��
    property bUninterruptedSign:Boolean read GetUninterruptedSign write SetUninterruptedSign;

    property bEnableServerRoomCall:Boolean read GetEnableServerRoomCall write SetEnableServerRoomCall;

    //�Ƿ�����ͬʱ����(ԭ������������)
    property bEnableOnesCall:boolean  read GetEnableOnesCall write SetEnableOnesCall;
    //�Ƿ����÷�������
    property bEnableReverseCall:Boolean read   GetEnableReverseCall write SetEnableReverseCall  ;
    //�Ƿ����ýа���Զ���Ԣ
    property bAutoLeaveRoom:Boolean read GetAfterCallAutoLeaveRoom write SetAfterCallAutoLeaveRoom;
    //�Ƿ���ʾ����
    property bShowTrainmNumber:boolean read  GetShowTrainmNumber write SetShowTrainmNumber;
    //�Ƿ�ʹ����Ա�б�ʽ
    property bShowUserList:boolean read  GetShowUserList write SetShowUserList;
    //�Ƿ����ô߽�
    property bUseReCall:Boolean read GetUseReCall write SetUseReCall;
    //�Ƿ������Ԣǩ��
    property bInRoomSign:Boolean read GetUseInRoomSign write SetUseInRoomSign ;
    //�Ƿ��Զ�ƥ��ƻ�
    property bAutoMatchPlan:boolean read  GetAutoMatchPlan  write SetAutoMatchPlan;

    property UIFont[Section:string] : TFont  read GetUIFont write SetUIFont;

    //��������
    property bOrderByRoom:Boolean read GetOrderByRoom write SetOrderByRoom ;

   //����ָ���ǹ㲥��Ϣ�ľ������
    property FingerMsgList : TStrings read m_FingerMsgList write m_FingerMsgList;
    //Ӧ�ó����·��
    property AppPath : string read GetAppPath;
    //���ݿ�����
    property SQLConfig : TSQLConfig read m_SQLConfig write m_SQLConfig;
    //�������ݿ�����
    property SQLConfig_Local :TSQLConfig read m_SQLConfig_Local write m_SQLConfig_Local;
     
     property ConfigFileName : string read GetConfigFileName;
    //��ǰ����վ�Ĺ���
    property SiteNumber  : string read GetSiteNumber write SetSiteNumber;
    {���ƻ�������ʼʱ��}
    property LoadWaitWorkPlanStartTime:TDateTime read GetLoadWaitWorkStartTime write SetLoadWaitWorkStartTime;
    {���ƻ����ؽ�ֹʱ��}
    property LoadWaitWorkPlanEndTime:TDateTime read GetLoadWaitWorkEndTime write SetLoadWaitWorkEndTime;

    {���ƻ����ؽ�ֹʱ��}
    //�޸ĳ���Ա��ָ����Ϣ
    procedure UpdateTrainmainFinger(TrainmanGUID:string;FingerPrint1,FingerPrint2 : string);


    property WebHost: string read GetWebApiHost write SetWebApiHost;
    property WebMessagePage: string read m_strWebMessagePage;

    property UsesOutWorkSign :Boolean read GetUsesOutWorkSign write SetOutWorkSign;
    property ShowSignPlanStartTime:TDateTime read GetShowSignPlanStartTime write SetShowSignPlanStartTime;
  end;
  {����:�������ͷ�Ƿ�װ}
  function WebcamExists():Boolean;
  
var
  GlobalDM: TGlobalDM;
implementation
uses
  iniFiles,DSUtil,DirectShow9, superobject;
{$R *.dfm}

  {����:�������ͷ�Ƿ�װ}
  function WebcamExists():Boolean;
    //����:�������ͷ�Ƿ�װ
  var
    CapEnum : TSysDevEnum;
  begin
    Result := False;
    CapEnum := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
    try
      if CapEnum.CountFilters > 0 then
        Result := True;
    finally
    end;
    CapEnum.Free;
  end;


procedure TGlobalDM.ConnecDB;
begin
  if ADOConnection.Connected then
    ADOConnection.Connected := false;

  ADOConnection.ConnectionString := m_SQLConfig.ConnString;

  ADOConnection.LoginPrompt := false;
  ADOConnection.KeepConnection := true;
  ADOConnection.Connected := true;

  TFDBAutoConnect.Connection := ADOConnection;
  TFDBAutoConnect.Interval := 1000;
  TFDBAutoConnect.TimeOut := 10000;
  TFDBAutoConnect.Enabled := False ;
end;
procedure TGlobalDM.ConnectLocal_SQLDB;
begin

  if LocalADOConnection.Connected then
    LocalADOConnection.Connected := false;
  LocalADOConnection.ConnectionString := m_SQLConfig_Local.ConnString;
  LocalADOConnection.LoginPrompt := false;
  LocalADOConnection.KeepConnection := true;
  LocalADOConnection.Connected := true;
end;



function TGlobalDM.ConAccessDB(adoCon: TADOConnection;strDatabase: WideString=''):Boolean;
var
  strConnection: string;
begin
  result := false;
  if adoCon.Connected then adoCon.Connected := false;

  if strDatabase = '' then strDatabase := ExtractFilePath(Application.ExeName)+'RunSafty.mdb';
  strConnection := 'Provider=Microsoft.Jet.OLEDB.4.0;Persist Security Info=False;Data Source='+strDatabase+';User Id=admin;Jet OLEDB:Database Password=thinkfreely;';
  try
    adoCon.Close;
    adoCon.ConnectionString := strConnection;
    adoCon.Open;
  except
  end;
  if adoCon.Connected then
    result := true;
end;

function TGlobalDM.ConnectLocalDB(strDatabase: WideString=''):Boolean;
begin
  result := ConAccessDB(LocalADOConnection,strDatabase);
  m_dbLocalTrainman := TRsDBLocalTrainman.Create(LocalADOConnection);
end;


procedure TGlobalDM.EnableAutoConnecDB;
begin
  try
    ADOConnection.Connected := false;
    ADOConnection.ConnectionString := m_SQLConfig.ConnString;
    ADOConnection.LoginPrompt := false;
    ADOConnection.KeepConnection := true;
    //ADOConnection.Connected := true;
  except
  end;
  
  TFDBAutoConnect.Connection := ADOConnection;
  TFDBAutoConnect.Interval := 1000;
  TFDBAutoConnect.TimeOut := 10000;
  TFDBAutoConnect.Enabled := False;

end;

procedure TGlobalDM.DataModuleCreate(Sender: TObject);
begin
  m_blnIsLocalMode := false;
  m_bIsAccessMode := False ;
  m_bFingerCaptureing := false;
  LogManage := TLogManage.Create;
  m_SQLConfig := TSQLConfig.Create(AppPath + 'config.ini','SQLCONFIG');
  m_SQLConfig_Local := TSQLConfig.Create(AppPath + 'config.ini','SQLCONFIG_LOCAL'); 
  m_FingerMsgHandle := AllocateHWnd(WndProc);

  LogManage.FileNamePath := AppPath + 'Log\';
  //m_webIF:=TWebIF.create;

end;

procedure TGlobalDM.DataModuleDestroy(Sender: TObject);
begin
  DeallocateHWnd(m_FingerMsgHandle);
  if assigned(m_FingerBufferManage) then
    FreeandNil(m_FingerBufferManage);
  m_SQLConfig.Free;
  m_SQLConfig_Local.Free;
   if DutyUser <> nil then
     FreeAndNil(DutyUser);
   if SiteInfo <> nil then
     FreeAndNil(SiteInfo);
  if ZKFPEngX <> nil then
  begin
    FreeAndNil(ZKFPEngX);
  end;

  //������ǵ���ģʽ
  if not GlobalDM.bLeaveLine then
  begin
    TFMessageCompnent.Close;
    //TFMessageCompnent.Free;  //��������������Thread Error����
  end;

  LogManage.Free;

  if m_dbLocalTrainman <> nil then
    m_dbLocalTrainman.Free;

  //m_webIF.Free;
end;

function TGlobalDM.DB_SysConfig(const SectionName, Ident: string): string;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := ADOConnection;
    strSQL := 'select * from TAB_System_Config where strSection = %s and strIdent = %s';

    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(SectionName),QuotedStr(Ident)]);

    ADOQuery.Open();

    if ADOQuery.RecordCount > 0 then
    begin
      Result := Trim(ADOQuery.FieldByName('strValue').AsString);
    end
    else
      Result := '';
  finally
    ADOQuery.Free;
  end;
end;
     


function TGlobalDM.SetDBSysConfig(const SectionName, Ident, Value: string): boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := ADOConnection;
    strSQL := 'select * from TAB_System_Config where strSection = %s and strIdent = %s';
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(SectionName),QuotedStr(Ident)]);
    ADOQuery.Open();
    if ADOQuery.RecordCount = 0 then
    begin
      ADOQuery.Append;
      ADOQuery.FieldByName('strSection').AsString := SectionName;
      ADOQuery.FieldByName('strIdent').AsString := Ident;
      ADOQuery.FieldByName('strValue').AsString := Value;
    end else begin
      ADOQuery.Edit;
      ADOQuery.FieldByName('strValue').AsString := Value;
    end;
    ADOQuery.Post;
    result := true;
  finally
    ADOQuery.Free;
  end;
end;



procedure TGlobalDM.SetEnableOnesCall(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if Value then
       nValue := 1;
    ini.WriteString('SysConfig','EnableOnesCall',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetEnableReverseCall(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if Value then
       nValue := 1;
    ini.WriteString('SysConfig','EnableReverseCall',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetEnableServerRoomCall(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if Value then
       nValue := 1;
    ini.WriteString('SysConfig','EnableServerRoomCall',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetAppPath: string;
begin
   Result := ExtractFilePath(Application.ExeName)
end;



function TGlobalDM.GetAutoLogin(): boolean;
var
  ini : TIniFile;
  strResult:string;
  nResult:Integer;
begin
  result := False;
  nResult := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('Login','AutoLogin','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nResult);
      if nResult = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetAutoMatchPlan: boolean;
var
  ini : TIniFile;
  strResult:string;
  nResult:Integer;
begin
  result := False;
  nResult := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','AutoMatchPlan','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nResult);
      if nResult = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetConfigFileName: string;
begin
  result := ExtractFilePath(Application.ExeName) + 'Config.ini';
end;




function TGlobalDM.GetEnableOnesCall: boolean;
var
  ini : TIniFile;
  strResult:string;
  nValue:Integer;
begin
  result := False;
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','EnableOnesCall','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nValue);
      if nValue = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetEnableReverseCall: boolean;
var
  ini : TIniFile;
  strResult:string;
  nValue:Integer;
begin
  result := False;
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','EnableReverseCall','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nValue);
      if nValue = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetEnableServerRoomCall: Boolean;
var
  ini : TIniFile;
  strResult:string;
  nValue:Integer;
begin
  result := False;
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','EnableServerRoomCall','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nValue);
      if nValue = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetHzPy(const AHzStr: AnsiString): AnsiString;
const
  ChinaCode: array[0..25, 0..1] of Integer = ((1601, 1636), (1637, 1832), (1833, 2077),
    (2078, 2273), (2274, 2301), (2302, 2432), (2433, 2593), (2594, 2786), (9999, 0000),
    (2787, 3105), (3106, 3211), (3212, 3471), (3472, 3634), (3635, 3722), (3723, 3729),
    (3730, 3857), (3858, 4026), (4027, 4085), (4086, 4389), (4390, 4557), (9999, 0000),
    (9999, 0000), (4558, 4683), (4684, 4924), (4925, 5248), (5249, 5589));
var
  i, j, HzOrd: Integer;
begin
  Result := '';
  i := 1;
  while i <= Length(AHzStr) do
  begin
    if (AHzStr[i] >= #160) and (AHzStr[i + 1] >= #160) then
    begin
      HzOrd := (Ord(AHzStr[i]) - 160) * 100 + Ord(AHzStr[i + 1]) - 160;
      for j := 0 to 25 do
      begin
        if (HzOrd >= ChinaCode[j][0]) and (HzOrd <= ChinaCode[j][1]) then
        begin
          Result := Result + AnsiChar(Byte('A') + j);
          Break;
        end;
      end;
      Inc(i);
    end else Result := Result + AHzStr[i];
    Inc(i);
  end;
end;



function TGlobalDM.GetAfterCallAutoLeaveRoom: boolean;
var
  ini : TIniFile;
  strResult:string;
  nValue:Integer;
begin
  result := False;
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','AutoLeaveRoom','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nValue);
      if nValue = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetLoadWaitWorkEndTime: TDateTime;
var
  strResult:string;
  dtTime:TDateTime;
begin

  result :=StrToTime('07:00:00');
  strResult := ReadIniFile(ExtractFilePath(Application.ExeName) + 'Config.ini',
    'UserData','LoadWaitWorkPlanEndTime');
  if strResult <> '' then
  begin
    if TryStrToTime(strResult,dtTime) then
      Result := dtTime;
  end;
end;

function TGlobalDM.GetLoadWaitWorkStartTime: TDateTime;
var
  strResult:string;
  dtTime:TDateTime;
begin
  result :=StrToTime('07:00:00');
  strResult := ReadIniFile(ExtractFilePath(Application.ExeName) + 'Config.ini',
    'UserData','LoadWaitWorkPlanStartTime');
  if strResult <> '' then
  begin
    if TryStrToTime(strResult,dtTime) then
      Result := dtTime;
  end;
end;

function TGlobalDM.GetLocalFingerLibGUID: string;
var
  strFile: string;
  XMLDoc: IXMLDocument;
  RootNode: IXMLNode;
begin
  result := '';
  strFile := AppPath + 'Trainman.xml';
  if not FileExists(strFile) then exit;

  XMLDoc := NewXMLDocument();
  try
    XMLDoc.LoadFromFile(strFile);
    RootNode := XMLDoc.DocumentElement;
    if RootNode <> nil then
    begin
      if RootNode.HasAttribute('LocalFingerLibGUID') then
        Result := RootNode.Attributes['LocalFingerLibGUID'];
    end;
  finally
    XMLDoc := nil;
  end;
end;

function TGlobalDM.GetLocalSiteName: string;
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    Result := trim(ini.ReadString('SysConfig','LocalSiteName',''));
  finally
    ini.Free;
  end;
end;



function TGlobalDM.GetUseReCall: boolean;
var
  ini : TIniFile;
  strResult:string;
  nResult:Integer;
begin
  result := False;
  nResult := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','UseReCall','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nResult);
      if nResult = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetOrderByRoom():Boolean;
var
  ini : TIniFile;
  strResult:string;
  nResult:Integer;
begin
  Result := False;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','OrderByRoom','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nResult);
      if nResult = 1 then
        result  := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetUseByPaiBan():Boolean;
var
  ini : TIniFile;
  strResult:string;
  nResult:Integer;
begin
  Result := False;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','UseByPaiBan','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nResult);
      if nResult = 1 then
        result  := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetUseFinger():Boolean;
var
  ini : TIniFile;
  strResult:string;
  nResult:Integer;
begin
  Result := False;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','UseFinger','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nResult);
      if nResult = 1 then
        result  := True;
    end;
  finally
    ini.Free;
  end;
end;



function TGlobalDM.GetUseInRoomSign: boolean;
var
  ini : TIniFile;
  strResult:string;
  nResult:Integer;
begin
  result := False;
  nResult := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','UseInRoomSign','1'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nResult);
      if nResult = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetLeaveLine():Boolean;
var
  ini : TIniFile;
  strResult:string;
  nResult:Integer;
begin
  result := False;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','nLeaveLine','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nResult);
      if nResult = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;



procedure TGlobalDM.SetLoadWaitWorkEndTime(_dt: TDateTime);
var
  strTime:string;
  ini : TIniFile;
begin
  strTime := FormatDateTime('HH:nn:ss',_dt);
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    ini.WriteString('UserData','LoadWaitWorkPlanEndTime',strTime);
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetLoadWaitWorkStartTime(_dt: TDateTime);
var
  strTime:string;
  ini : TIniFile;
begin
  strTime := FormatDateTime('HH:nn:ss',_dt);
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    ini.WriteString('UserData','LoadWaitWorkPlanStartTime',strTime);
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetLocalSiteName(const Value: string);
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    ini.WriteString('SysConfig','LocalSiteName',Value);
  finally
    ini.Free;
  end;
end;



procedure TGlobalDM.SetUseReCall(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    if Value then
      nValue := 1;
    ini.WriteString('SysConfig','UseReCall',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetUIFont(Section: string; const Font: TFont);
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    ini.WriteString(Section,'Name',Font.Name);
    ini.WriteInteger(Section,'Height',Font.Height);
    ini.WriteInteger(Section,'Color',Font.Color);
    //ini.WriteInteger('SysConfig',Section,Font.Style);
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetUninterruptedSign(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if Value then
       nValue := 1;
    ini.WriteString('SysConfig','UninterruptedSign',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetUseByPaiBan(useByPaiBan:Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if useByPaiBan then
       nValue := 1;
    ini.WriteString('SysConfig','UseByPaiBan',inttostr(nValue));
  finally
    ini.Free;
  end;
end;
procedure TGlobalDM.SetUseFinger(useFinger:Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if useFinger then
       nValue := 1;
    ini.WriteString('SysConfig','useFinger',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetUseInRoomSign(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    if Value then
      nValue := 1;
    ini.WriteString('SysConfig','UseInRoomSign',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetOrderByRoom(orderByRoom:Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if orderByRoom then
       nValue := 1;
    ini.WriteString('SysConfig','OrderByRoom',inttostr(nValue));
  finally
    ini.Free;
  end;
end;


procedure TGlobalDM.SetLeaveLine(bLeaveLine:Boolean);
var
  ini : TIniFile;
  nLeaveLine:Integer;
begin
  nLeaveLine := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    if bLeaveLine = True then
      nLeaveLine := 1;
    ini.WriteString('SysConfig','nLeaveLine',inttostr(nLeaveLine));
  finally
    ini.Free;
  end;
end;





function TGlobalDM.GetNow: TDateTime;
var
  ado : TADOQuery;
begin
  result := Now;
  Exit;
  //Result := GetNowWeb;
 // Exit;


  Result := now;
  try
    ado := TADOQuery.Create(nil);
    try
      with ado do
      begin
        if not ADOConnection.Connected then exit;
        Connection := ADOConnection;
        Sql.Text := 'select (getdate()) as NowDate';
        Open;
        Result := FieldByName('NowDate').AsDateTime;
      end;
    finally
      ado.Free;
    end;
  except
  end;
end;




function TGlobalDM.GetShowSignPlanStartTime: TDateTime;
var
  strTemp : string;
  dtTemp : TDateTime;
begin
  result := DateOf(self.GetNow());
  strTemp := ReadIniFile(ConfigFileName,'UserData','ShowSignPlanStartTime');
  if TryStrToDateTime(strTemp,dtTemp) then
  begin
    result := dtTemp;
  end;
end;

function TGlobalDM.GetShowTrainmNumber: boolean;
var
  ini : TIniFile;
  strResult:string;
  nValue:Integer;
begin

  result := false;
  exit;

  result := False;
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','ShowTrainmNumber','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nValue);
      if nValue = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetShowUserList: Boolean;
var
  ini : TIniFile;
  strResult:string;
  nValue:Integer;
begin
  result := true ;
  exit ;
  
  result := False;
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','ShowUserList','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nValue);
      if nValue = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetSiteNumber: string;
begin
  result := ReadIniFile(ConfigFileName,'UserData','SiteNumber');
end;

procedure TGlobalDM.GetTimeSpan(SourceTime: TDateTime; out BeginTime,
  EndTime: TDateTime);
begin
  BeginTime := IncHour(dateof(SourceTime)-1, 18);
  EndTime := IncMinute(IncDay(dateOf(SourceTime), 1), 17 * 60 + 59)
end;



function TGlobalDM.InitFingerPrintting: Boolean;
{����:��ʼ��ָ����}
var
  initRlt : Integer;
begin
  Result := False;
  FingerprintInitSuccess := false;
  if ZKFPEngActiveXExist() = false then
  begin
    FingerprintInitFailureReason := '"Biokey.ocx"δΪע��!';
    Exit;
  end;
  if ZKFPEngX <> nil then
    FreeAndNil(ZKFPEngX);
    
  ZKFPEngX := TZKFPEngX.Create(nil);
  if assigned(m_FingerBufferManage) then
    FreeandNil(m_FingerBufferManage);
  m_FingerBufferManage := TFingerBufferManage.Create(ZKFPEngX);
  FingerprintInitFailureReason := '';
  try
    initRlt := ZKFPEngX.InitEngine;
    case initRlt of
      1: FingerprintInitFailureReason := '�����������ʧ��!';
      2: FingerprintInitFailureReason := 'ָ����USB���ӳ��ֹ���!';
      3: FingerprintInitFailureReason := 'ָ������Ų����ڻ�ռ��!';
    end;
    if FingerprintInitFailureReason <> '' then
    begin
      FreeAndNil(ZKFPEngX);
      Exit;
    end;
  except
    on E : Exception do
    begin
      FreeAndNil(ZKFPEngX);
      FingerprintInitFailureReason := 'ָ�����޷�ʹ��,���������Ƿ�������';
      Exit;
    end;
  end;

  FingerprintInitSuccess := True;
  Result := True;

  if m_bIsAccessMode then
    ZKFPEngX.OnCapture := FingerCaptureProcAccess //��׽��ָ�ƴ���
  else if m_blnIsLocalMode or (LocalFingerLibGUID <> '') then
    ZKFPEngX.OnCapture := LocalFingerCaptureProc //��׽��ָ�ƴ���
  else
    ZKFPEngX.OnCapture := FingerCaptureProc; //��׽��ָ�ƴ���

  {
  if m_blnIsLocalMode or (LocalFingerLibGUID <> '') then
    ZKFPEngX.OnCapture := LocalFingerCaptureProc //��׽��ָ�ƴ���
  else
    ZKFPEngX.OnCapture := FingerCaptureProc; //��׽��ָ�ƴ���
  }

  ZKFPEngX.OnFingerTouching := FingerTouchingProc;
end;

procedure TGlobalDM.LoadConfig;
begin
  //m_SQLConfig.Load;
  m_SQLConfig_Local.Load;
end;

procedure TGlobalDM.LoadDB_Config;
begin
 // m_strWebHost := WorkShopWEBHost(SiteInfo.WorkShopGUID);
  m_strWebHost := GetWebApiHost;
  m_strWebMessagePage:= DB_SysConfig('SysConfig','MessagePage');
end;

procedure TGlobalDM.FingerCaptureProc(ASender: TObject; ActionResult: WordBool;
  ATemplate: OleVariant);
var
  nID : Integer;
  Trainman : RRsTrainman;
begin
  ZKFPEngX.OnCapture := nil;
  try
    if ActionResult = False then
    begin
      if Assigned(OnFingerLoginFailure) then
        OnFingerLoginFailure(Self);
      Exit;
    end;
    if m_FingerBufferManage.FindFingerPrint(ATemplate,nID) then
    begin
      if TRsDBTrainman.GetTrainmanByID(GlobalDM.ADOConnection,nID,Trainman) then
      begin
        if Assigned(OnFingerLoginSuccess) then
        begin
           OnFingerLoginSuccess(Trainman.strTrainmanNumber);
        end;
      end
      else
      begin
        if Assigned(OnFingerLoginFailure) then
          OnFingerLoginFailure(Nil);
      end;
    end
    else
    begin
      if Assigned(OnFingerLoginFailure) then OnFingerLoginFailure(Nil);
    end;
  finally
    ZKFPEngX.OnCapture := FingerCaptureProc;
  end;
end;

procedure TGlobalDM.FingerCaptureProcAccess(ASender: TObject;
  ActionResult: WordBool; ATemplate: OleVariant);
var
  nID : Integer;
  Trainman : RRsTrainman;
begin
  ZKFPEngX.OnCapture := nil;
  try
    if ActionResult = False then
    begin
      if Assigned(OnFingerLoginFailure) then
        OnFingerLoginFailure(Self);
      Exit;
    end;
    if m_FingerBufferManage.FindFingerPrint(ATemplate,nID) then
    begin
      if m_dbLocalTrainman.GetTrainmanByID(GlobalDM.LocalADOConnection,nID,Trainman) then
      begin
        if Assigned(OnFingerLoginSuccess) then
        begin
           OnFingerLoginSuccess(Trainman.strTrainmanNumber);
        end;
      end
      else
      begin
        if Assigned(OnFingerLoginFailure) then
          OnFingerLoginFailure(Nil);
      end;
    end
    else
    begin
      if Assigned(OnFingerLoginFailure) then OnFingerLoginFailure(Nil);
    end;
  finally
    ZKFPEngX.OnCapture := FingerCaptureProcAccess;
  end;
end;

procedure TGlobalDM.LocalFingerCaptureProc(ASender: TObject; ActionResult: WordBool;
  ATemplate: OleVariant);
var
  nID, i, n: Integer;
  strTrainmanNumber: string;
begin
  ZKFPEngX.OnCapture := nil;
  try
    if ActionResult = False then
    begin
      if Assigned(OnFingerLoginFailure) then
        OnFingerLoginFailure(Self);
      Exit;
    end;
    if m_FingerBufferManage.FindFingerPrint(ATemplate,nID) then
    begin
      strTrainmanNumber := '';
      n := Length(m_LocalTrainmanArray);
      for i := 0 to n - 1 do
      begin
        if m_LocalTrainmanArray[i].nID = nID then
        begin
          strTrainmanNumber := m_LocalTrainmanArray[i].strTrainmanNumber;
          break;
        end;
      end;
      
      if strTrainmanNumber <> '' then
      begin
        if Assigned(OnFingerLoginSuccess) then
        begin
           OnFingerLoginSuccess(strTrainmanNumber);
        end;
      end
      else
      begin
        if Assigned(OnFingerLoginFailure) then
          OnFingerLoginFailure(Nil);
      end;
    end
    else
    begin
      if Assigned(OnFingerLoginFailure) then OnFingerLoginFailure(Nil);
    end;
  finally
    ZKFPEngX.OnCapture := LocalFingerCaptureProc;
  end;
end;

procedure TGlobalDM.FingerTouchingProc(Sender: TObject);
begin
  PostMessage(m_FingerMsgHandle,WM_MSGFingerCapture,0,0);
end;

procedure TGlobalDM.OnMessageError(strErr: string);
begin
  LogManage.InsertLog(strErr);
end;

procedure TGlobalDM.OpenMessageCompnent;
begin
  if not bLeaveLine then
  begin
    TFMessageCompnent := TTFMessageCompnent.Create(ASynMode);
    TFMessageCompnent.ConnectTimeOut := 3000;
    TFMessageCompnent.Period := 2000;
    TFMessageCompnent.OnError := OnMessageError;
    TFMessageCompnent.LocalTempPath := AppPath;
    TFMessageCompnent.ClientID := ReadIniFile(AppPath + 'Config.ini','TFMessage','ClientID');
    TFMessageCompnent.URL := m_strWebHost + m_strWebMessagePage;
  end;
end;

procedure TGlobalDM.PlaySoundFile(SoundFile: string);
begin
  TRoomCallApp.GetInstance.CallDevOp.PlaySoundFile(AppPath + 'Sounds\' + SoundFile);
end;

//==============================================================================

procedure TGlobalDM.SaveGridColumnWidth(Grid: TAdvStringGrid);
var
  Ini: TIniFile;
  i, nColCount, nColWidth: integer;
  strIniFile, strSection, strKey: string;
begin
  if Grid.ColumnSize.Save then exit;

  strIniFile := 'FormColWidths.ini';
  strSection := Grid.ColumnSize.Section;
  if strSection = '' then exit;

  strIniFile := ExtractFilePath(Application.ExeName) + strIniFile;
  Ini:=TIniFile.Create(strIniFile);
  try
    nColCount := Grid.ColumnHeaders.Count;

    //if nColCount > Grid.ColCount then nColCount := Grid.ColCount;
    for i := 0 to nColCount - 1 do
    begin
      strKey := Grid.ColumnHeaders[i];
      if strKey = '' then Continue;
      nColWidth := Grid.ColWidths[grid.DisplColIndex(i)];
      Ini.WriteInteger(strSection, strKey, nColWidth);
    end;
  finally
    Ini.Free();
  end;
end;

procedure TGlobalDM.SetGridColumnWidth(Grid: TAdvStringGrid);
var
  Ini: TIniFile;
  i, nColCount, nColWidth: integer;
  strIniFile, strSection, strKey: string;
begin
  if Grid.ColumnSize.Save then exit;
  
  strIniFile := 'FormColWidths.ini';
  strSection := Grid.ColumnSize.Section;
  if strIniFile = '' then exit;
  if strSection = '' then exit;

  strIniFile := ExtractFilePath(Application.ExeName) + strIniFile;
  Ini:=TIniFile.Create(strIniFile);
  try
    nColCount := Grid.ColumnHeaders.Count;
//    if nColCount > Grid.ColCount then nColCount := Grid.ColCount;
    for i := 0 to nColCount - 1 do
    begin
      strKey := Grid.ColumnHeaders[i];
      if strKey = '' then Continue;
      nColWidth := Ini.ReadInteger(strSection, strKey, -1);
      if nColWidth >= 0 then Grid.ColWidths[grid.DisplColIndex(i)] := nColWidth;
    end;
  finally
    Ini.Free();
  end;
end;
        
procedure TGlobalDM.SetAfterCallAutoLeaveRoom(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if Value then
       nValue := 1;
    ini.WriteString('SysConfig','AutoLeaveRoom',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetAutoLogin(const Value: boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    if Value then
      nValue := 1;
    ini.WriteString('Login','AutoLogin',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetAutoMatchPlan(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    if Value then
      nValue := 1;
    ini.WriteString('SysConfig','AutoMatchPlan',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SaveGridColumnVisible(Grid: TAdvStringGrid);
var
  Ini: TIniFile;
  i, nColCount: integer;
  strIniFile, strSection, strKey: string;
begin
  strIniFile := 'FormColVisibles.ini';
  strSection := Grid.ColumnSize.Section;
  if strSection = '' then exit;

  strIniFile := ExtractFilePath(Application.ExeName) + strIniFile;
  Ini:=TIniFile.Create(strIniFile);
  try
    nColCount := Grid.ColumnHeaders.Count;  
    //if nColCount > Grid.ColCount then nColCount := Grid.ColCount;
    for i := 1 to nColCount - 1 do
    begin
      strKey := Grid.ColumnHeaders[i];
      if strKey = '' then Continue;
      Ini.WriteBool(strSection, strKey, not Grid.IsHiddenColumn(i));
    end;
  finally
    Ini.Free();
  end;
end;

procedure TGlobalDM.SetGridColumnVisible(Grid: TAdvStringGrid);
var
  Ini: TIniFile;
  i, nColCount: integer;
  strIniFile, strSection, strKey: string;
begin
  strIniFile := 'FormColVisibles.ini';
  strSection := Grid.ColumnSize.Section;
  if strSection = '' then exit;

  strIniFile := ExtractFilePath(Application.ExeName) + strIniFile;
  Ini:=TIniFile.Create(strIniFile);
  Grid.BeginUpdate;
  try
    nColCount := Grid.ColumnHeaders.Count;  
    //if nColCount > Grid.ColCount then nColCount := Grid.ColCount;
    for i := 1 to nColCount - 1 do
    begin
      strKey := Grid.ColumnHeaders[i];
      if strKey = '' then Continue;
      if Ini.ReadBool(strSection, strKey, True) then
        Grid.UnHideColumn(i)
      else
        Grid.HideColumn(i);
    end;
  finally
    Grid.EndUpdate;
    Ini.Free();
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//����: STRING ������������ OLEVARIANT ��
//������
////////////////////////////////////////////////////////////////////////////////

function TextToOleData(const AText: string): OleVariant;
var
  nSize: Integer;
  pData: Pointer;
begin
  nSize := Length(AText);
  if nSize = 0 then
    Result := Null
  else begin
    Result := VarArrayCreate([0, nSize - 1], varByte);
    pData := VarArrayLock(Result);
    try
      Move(Pchar(AText)^, pData^, nSize);
    finally
      VarArrayUnlock(Result);
    end;
  end;
end;

procedure TGlobalDM.ReadAccessFingerprintTemplate(ForceUpdate : BOOL);
{����:����ָ������}
var
  i : Integer;
  trainmanArray : TRsTrainmanArray;
  blnUpdate: boolean;
  strFile, strPath: string;
begin
  blnUpdate := True ;
  //��ȡ�������ݿ�ָ����Ϣ
  TRsDBLocalTrainman.GetTrainmansBrief(LocalADOConnection,trainmanArray);
  LogManage.InsertLog('�����ݿ��ȡָ����Ϣ');
  //��ʼ��ָ����
  if m_fpcHandle <> -1 then
    ZKFPEngX.FreeFPCacheDB(m_fpcHandle);
  m_fpcHandle := ZKFPEngX.CreateFPCacheDB();
  if m_fpcHandle = 0 then
    LogManage.InsertLog('����ZKFPEngXʧ��!');

  //��������ָ�ƿⲢ���ص��ڴ���
  strPath := AppPath + 'Fingers\';
  if not DirectoryExists(strPath) then ForceDirectories(strPath);

  LogManage.InsertLog('��������ָ�ƿⲢ���ص��ڴ���');
  for i := 0 to Length(trainmanArray) - 1 do
  begin

    Application.ProcessMessages;
    if not VarIsEmpty(trainmanArray[i].FingerPrint1) then
    begin
      m_FingerBufferManage.AddFingerPrint(trainmanArray[i].FingerPrint1, trainmanArray[i].nID);
      if blnUpdate then
      begin
        strFile := strPath + Format('%d-%s.fp1', [trainmanArray[i].nID, trainmanArray[i].strTrainmanNumber]);
        ZKFPEngX.SaveTemplate(strFile, trainmanArray[i].FingerPrint1);
      end;
    end;
    if not VarIsEmpty(trainmanArray[i].FingerPrint2) then
    begin
      m_FingerBufferManage.AddFingerPrint(trainmanArray[i].FingerPrint2, trainmanArray[i].nID);
      if blnUpdate then
      begin
        strFile := strPath + Format('%d-%s.fp2', [trainmanArray[i].nID, trainmanArray[i].strTrainmanNumber]);
        ZKFPEngX.SaveTemplate(strFile, trainmanArray[i].FingerPrint2);
      end;
    end;
    if Assigned(OnReadFingerprintTemplatesChangeEvent) then
    begin
      OnReadFingerprintTemplatesChangeEvent(Length(trainmanArray),i);
      Application.ProcessMessages;
    end;
  end;

  LogManage.InsertLog('����ָ��ģ�����');
  if Assigned(OnReadFingerprintTemplatesComplete) then OnReadFingerprintTemplatesComplete();
end;

procedure TGlobalDM.ReadFingerprintTemplates(ForceUpdate : BOOL);
{����:����ָ������}
var
  i : Integer;
  trainmanArray : TRsTrainmanArray; 
  strLocalFingerLibGUID, strServerFingerLibGUID: string;
  blnUpdate: boolean;
  strFile, strPath: string;
  XMLDoc: IXMLDocument;
  RootNode, Node: IXMLNode;
begin

  //����ģʽ����ر���ָ��
  if m_blnIsLocalMode  then
  begin
    LoadLocalFingerTemplates;
    exit;
  end;
  //���δ���ع�����ָ�Ʋ��Ҳ���ǿ�м���Զ��ָ������ر���ָ��
  if (not ForceUpdate) and (LocalFingerLibGUID <> '') then
  begin
    LoadLocalFingerTemplates;
    exit;
  end;

  //��ȡԶ��ָ�ƿ���������¼�ڱ���
  strLocalFingerLibGUID := LocalFingerLibGUID;
  strServerFingerLibGUID := DB_SysConfig('SysConfig','ServerFingerLibGUID');
  if strServerFingerLibGUID = '' then
  begin
    strServerFingerLibGUID := NewGUID;
    if not SetDBSysConfig('SysConfig','ServerFingerLibGUID',strServerFingerLibGUID) then strServerFingerLibGUID := '';
  end;

  //�жϱ���ָ�ƿ������Ƿ�ͷ�������ָ�ƿ�������ͬ
  blnUpdate := (strLocalFingerLibGUID <> strServerFingerLibGUID);


  //��ȡ������ָ����Ϣ
  TRsDBTrainman.GetTrainmansBrief(ADOConnection,trainmanArray);

  //��ʼ��ָ����
  if m_fpcHandle <> -1 then
    ZKFPEngX.FreeFPCacheDB(m_fpcHandle);
  m_fpcHandle := ZKFPEngX.CreateFPCacheDB();


  //ɾ������ָ�ƿ�
  if blnUpdate then
    DeleteLocalFingerTemplates
  else if ForceUpdate then
    DeleteLocalFingerTemplates;

  //��������ָ�ƿⲢ���ص��ڴ���  
  strPath := AppPath + 'Fingers\';
  if not DirectoryExists(strPath) then ForceDirectories(strPath);
  XMLDoc := NewXMLDocument();
  try
    RootNode := XMLDoc.DocumentElement;
    if RootNode = nil then RootNode := XMLDoc.AddChild('Trainman');

    for i := 0 to Length(trainmanArray) - 1 do
    begin
      if blnUpdate then
      begin
        Application.ProcessMessages;
        Node := RootNode.AddChild(Format('Row%d', [i+1]));
        Node.Attributes['nID'] := TrainmanArray[i].nID;
        Node.Attributes['strTrainmanGUID'] := TrainmanArray[i].strTrainmanGUID;
        Node.Attributes['strTrainmanName'] := TrainmanArray[i].strTrainmanName;
        Node.Attributes['strTrainmanNumber'] := TrainmanArray[i].strTrainmanNumber;
        Node.Attributes['strJP'] := TrainmanArray[i].strJP;
      end;
      
      Application.ProcessMessages;
      if not VarIsEmpty(trainmanArray[i].FingerPrint1) then
      begin
        m_FingerBufferManage.AddFingerPrint(trainmanArray[i].FingerPrint1, trainmanArray[i].nID);
        if blnUpdate then
        begin
          strFile := strPath + Format('%d-%s.fp1', [trainmanArray[i].nID, trainmanArray[i].strTrainmanNumber]);
          ZKFPEngX.SaveTemplate(strFile, trainmanArray[i].FingerPrint1);
        end;
      end;
      if not VarIsEmpty(trainmanArray[i].FingerPrint2) then
      begin
        m_FingerBufferManage.AddFingerPrint(trainmanArray[i].FingerPrint2, trainmanArray[i].nID);  
        if blnUpdate then
        begin
          strFile := strPath + Format('%d-%s.fp2', [trainmanArray[i].nID, trainmanArray[i].strTrainmanNumber]);
          ZKFPEngX.SaveTemplate(strFile, trainmanArray[i].FingerPrint2);
        end;
      end;
      if Assigned(OnReadFingerprintTemplatesChangeEvent) then
      begin
        OnReadFingerprintTemplatesChangeEvent(Length(trainmanArray),i); 
        Application.ProcessMessages;
      end;
    end;   

    if blnUpdate then
    begin
      RootNode.Attributes['LocalFingerLibGUID'] := DB_SysConfig('SysConfig','ServerFingerLibGUID');
      XMLDoc.SaveToFile(AppPath + 'Trainman.xml');
    end;
  finally
    XMLDoc := nil;
  end;

  if Assigned(OnReadFingerprintTemplatesComplete) then OnReadFingerprintTemplatesComplete();
end;



procedure TGlobalDM.ReadGridRowHeight(Grid: TAdvStringGrid);
var
  Ini: TIniFile;
  strIniFile, strSection, strKey: string;
  nRowHeight : integer ;
begin
  strSection := Grid.Name + 'RowHeight' ;
  strIniFile := 'FormRowHeights.ini';
  strIniFile := ExtractFilePath(Application.ExeName) + strIniFile;
  Ini:=TIniFile.Create(strIniFile);
  try
    nRowHeight := Ini.ReadInteger(strSection, 'DefaultRowHeight',40);
    Grid.DefaultRowHeight := nRowHeight ;
  finally
    Ini.Free();
  end;
end;

procedure TGlobalDM.LoadLocalFingerTemplates;
var
  ms: TMemoryStream;
  template: OleVariant;
  SearchRec: TSearchRec;
  strFile, strPath: string;
  strName, strExt, strID, strTrainmanNumber: string;
  nID, nIndex, nCount, nLen: integer;
  i, n: integer;
  XMLDoc: IXMLDocument;
  RootNode, Node: IXMLNode;
  blnRetry: boolean;
begin
  if m_fpcHandle <> -1 then ZKFPEngX.FreeFPCacheDB(m_fpcHandle);
  m_fpcHandle := ZKFPEngX.CreateFPCacheDB();

  SetLength(m_LocalTrainmanArray, 0);
  strFile := AppPath + 'Trainman.xml';
  if FileExists(strFile) then
  begin
    XMLDoc := NewXMLDocument();
    try
      XMLDoc.LoadFromFile(strFile);
      RootNode := XMLDoc.DocumentElement;
      if RootNode <> nil then
      begin
        n := RootNode.ChildNodes.Count;
        SetLength(m_LocalTrainmanArray, n);
        for i := 0 to n - 1 do
        begin
          Node := RootNode.ChildNodes[i];
          m_LocalTrainmanArray[i].nID := Node.Attributes['nID'];
          m_LocalTrainmanArray[i].strTrainmanGUID := Node.Attributes['strTrainmanGUID'];
          m_LocalTrainmanArray[i].strTrainmanName := Node.Attributes['strTrainmanName'];
          m_LocalTrainmanArray[i].strTrainmanNumber := Node.Attributes['strTrainmanNumber'];
          m_LocalTrainmanArray[i].strJP := Node.Attributes['strJP'];
        end;
      end;
    finally
      XMLDoc := nil;
    end;
  end;
  blnRetry := (Length(m_LocalTrainmanArray) = 0);

  strPath := AppPath + 'Fingers\';
  ms := TMemoryStream.Create;
  try
    nCount := 0;
    if FindFirst(strPath+'*.fp?', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Attr and faDirectory) = faDirectory then Continue;  
        strExt := LowerCase(ExtractFileExt(SearchRec.Name));
        if (strExt = '.fp1') or (strExt = '.fp2') then nCount := nCount + 1;
      until FindNext(SearchRec) <> 0;
    end;
    FindClose(SearchRec);
            
    nIndex := 0;
    if FindFirst(strPath+'*.fp?', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Attr and faDirectory) = faDirectory then Continue;

        strExt := LowerCase(ExtractFileExt(SearchRec.Name));
        if (strExt = '.fp1') or (strExt = '.fp2') then
        begin
          strFile := strPath + SearchRec.Name;
          strName := Copy(SearchRec.Name, 1, Length(SearchRec.Name) - Length(strExt));
          strID := Copy(strName, 1, Pos('-', strName) - 1);
          strTrainmanNumber := Copy(strName, Pos('-', strName) + 1, Length(strName));
          nID := StrToIntDef(strID, 0);
          if nID > 0 then
          begin
            if blnRetry then
            begin
              nLen := Length(m_LocalTrainmanArray);
              SetLength(m_LocalTrainmanArray, nLen + 1);
              m_LocalTrainmanArray[nLen].nID := nID;
              m_LocalTrainmanArray[nLen].strTrainmanNumber := trim(strTrainmanNumber);
            end;

            ms.LoadFromFile(strFile);
            template := StreamToTemplateOleVariant(ms);
            if not VarIsEmpty(template) then m_FingerBufferManage.AddFingerPrint(template, nID);
          end;

          nIndex := nIndex + 1;
          if Assigned(OnReadFingerprintTemplatesChangeEvent) then OnReadFingerprintTemplatesChangeEvent(nCount, nIndex);
        end;
        Application.ProcessMessages;
      until FindNext(SearchRec) <> 0;
    end;
    FindClose(SearchRec);
  finally
    ms.Free;
  end; 
      
  if Assigned(OnReadFingerprintTemplatesComplete) then OnReadFingerprintTemplatesComplete();
end;

procedure TGlobalDM.SaveLocalFingerTemplates();
var
  i: Integer;
  trainmanArray : TRsTrainmanArray;
  strFile, strPath: string;
  XMLDoc: IXMLDocument;
  RootNode, Node: IXMLNode;
begin
  TRsDBTrainman.GetTrainmansBrief(ADOConnection,trainmanArray);

  DeleteLocalFingerTemplates;

  strPath := AppPath + 'Fingers\';
  if not DirectoryExists(strPath) then ForceDirectories(strPath);
  XMLDoc := NewXMLDocument();
  try
    RootNode := XMLDoc.DocumentElement;
    if RootNode = nil then RootNode := XMLDoc.AddChild('Trainman');

    for i := 0 to Length(trainmanArray) - 1 do
    begin
      Application.ProcessMessages;
      Node := RootNode.AddChild(Format('Row%d', [i+1]));
      Node.Attributes['nID'] := TrainmanArray[i].nID;
      Node.Attributes['strTrainmanGUID'] := TrainmanArray[i].strTrainmanGUID;
      Node.Attributes['strTrainmanName'] := TrainmanArray[i].strTrainmanName;
      Node.Attributes['strTrainmanNumber'] := TrainmanArray[i].strTrainmanNumber;
      Node.Attributes['strJP'] := TrainmanArray[i].strJP; 

      Application.ProcessMessages;
      if not VarIsEmpty(trainmanArray[i].FingerPrint1) then
      begin                                              
        strFile := strPath + Format('%d-%s.fp1', [trainmanArray[i].nID, trainmanArray[i].strTrainmanNumber]);
        ZKFPEngX.SaveTemplate(strFile, trainmanArray[i].FingerPrint1);
      end;

      Application.ProcessMessages;
      if not VarIsEmpty(trainmanArray[i].FingerPrint2) then
      begin
        strFile := strPath + Format('%d-%s.fp2', [trainmanArray[i].nID, trainmanArray[i].strTrainmanNumber]);
        ZKFPEngX.SaveTemplate(strFile, trainmanArray[i].FingerPrint2);
      end;
      UpdateFingerTemplateByID(trainmanArray[i].nID,trainmanArray[i].FingerPrint1,trainmanArray[i].FingerPrint2);
    end;

    RootNode.Attributes['LocalFingerLibGUID'] := DB_SysConfig('SysConfig','ServerFingerLibGUID');
    XMLDoc.SaveToFile(AppPath + 'Trainman.xml');
  finally
    XMLDoc := nil;
  end;
end;

procedure TGlobalDM.DeleteLocalFingerTemplates;
var
  SearchRec: TSearchRec;
  strPath, strFile: string;
begin
  strFile := AppPath + 'Trainman.xml';
  if FileExists(strFile) then
  begin
    FileSetAttr(strFile, 0);
    DeleteFile(strFile);
  end;
     
  strPath := AppPath + 'Fingers\';
  try
    if FindFirst(strPath+'*.fp?', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Attr and faDirectory) = faDirectory then continue;
        strFile := strPath + SearchRec.Name;
        begin
          FileSetAttr(strFile, 0);
          DeleteFile(strFile);
        end;
      until FindNext(SearchRec) <> 0;
    end;
    FindClose(SearchRec);
  except
  end;
end;

procedure TGlobalDM.GetLocalTrainmanByNumber(TrainmanNumber: string; out Trainman: RRsTrainman);
var
  i, n: integer;
begin
  Trainman.strTrainmanNumber := TrainmanNumber;

  n := Length(m_LocalTrainmanArray);
  for i := 0 to n - 1 do
  begin
    if m_LocalTrainmanArray[i].strTrainmanNumber = TrainmanNumber then
    begin
      Trainman.nID := m_LocalTrainmanArray[i].nID;
      Trainman.strTrainmanGUID := m_LocalTrainmanArray[i].strTrainmanGUID;
      Trainman.strTrainmanName := m_LocalTrainmanArray[i].strTrainmanName;
      Trainman.strTrainmanNumber := m_LocalTrainmanArray[i].strTrainmanNumber;
      Trainman.strJP := m_LocalTrainmanArray[i].strJP;
      break;
    end;
  end;
end;



procedure TGlobalDM.AddLocalFingerTemplate(Trainman: RRsTrainman);
var
  n: Integer;
  strFile, strPath: string;
  XMLDoc: IXMLDocument;
  RootNode, Node: IXMLNode;
begin
  strPath := AppPath + 'Fingers\';
  if not DirectoryExists(strPath) then ForceDirectories(strPath);
  if not VarIsEmpty(Trainman.FingerPrint1) then
  begin
    strFile := strPath + Format('%d-%s.fp1', [Trainman.nID, Trainman.strTrainmanNumber]);
    ZKFPEngX.SaveTemplate(strFile, Trainman.FingerPrint1);
  end;
  if not VarIsEmpty(Trainman.FingerPrint2) then
  begin
    strFile := strPath + Format('%d-%s.fp2', [Trainman.nID, Trainman.strTrainmanNumber]);
    ZKFPEngX.SaveTemplate(strFile, Trainman.FingerPrint2);
  end; 

  n := Length(m_LocalTrainmanArray);
  SetLength(m_LocalTrainmanArray, n + 1);
  m_LocalTrainmanArray[n].nID := Trainman.nID;
  m_LocalTrainmanArray[n].strTrainmanGUID := Trainman.strTrainmanGUID;
  m_LocalTrainmanArray[n].strTrainmanName := Trainman.strTrainmanName;
  m_LocalTrainmanArray[n].strTrainmanNumber := Trainman.strTrainmanNumber;
  m_LocalTrainmanArray[n].strJP := Trainman.strJP;

  strFile := AppPath + 'Trainman.xml';
  if not FileExists(strFile) then exit;
  XMLDoc := NewXMLDocument();
  try                     
    XMLDoc.LoadFromFile(strFile);
    RootNode := XMLDoc.DocumentElement;
    if RootNode = nil then RootNode := XMLDoc.AddChild('Trainman');

    Node := RootNode.AddChild(Format('Row%d', [n + 1]));
    Node.Attributes['nID'] := Trainman.nID;
    Node.Attributes['strTrainmanGUID'] := Trainman.strTrainmanGUID;
    Node.Attributes['strTrainmanName'] := Trainman.strTrainmanName;
    Node.Attributes['strTrainmanNumber'] := Trainman.strTrainmanNumber;
    Node.Attributes['strJP'] := Trainman.strJP;

    RootNode.Attributes['LocalFingerLibGUID'] := DB_SysConfig('SysConfig','ServerFingerLibGUID');
    XMLDoc.SaveToFile(strFile);
  finally
    XMLDoc := nil;
  end;
end;
      
procedure TGlobalDM.UpdateLocalFingerTemplate(Trainman: RRsTrainman);
var
  i, n: Integer;
  strFile, strPath: string;
  XMLDoc: IXMLDocument;
  RootNode, Node: IXMLNode;
  bFind : boolean;
begin
  strPath := AppPath + 'Fingers\';
  if not DirectoryExists(strPath) then ForceDirectories(strPath);
  strFile := strPath + Format('%d-%s.fp1', [Trainman.nID, Trainman.strTrainmanNumber]);
  if FileExists(strFile) then
  begin
    FileSetAttr(strFile, 0);
    DeleteFile(strFile);
  end;
  strFile := strPath + Format('%d-%s.fp2', [Trainman.nID, Trainman.strTrainmanNumber]);
  if FileExists(strFile) then
  begin
    FileSetAttr(strFile, 0);
    DeleteFile(strFile);
  end;

  if not VarIsEmpty(Trainman.FingerPrint1) then
  begin
    strFile := strPath + Format('%d-%s.fp1', [Trainman.nID, Trainman.strTrainmanNumber]);
    ZKFPEngX.SaveTemplate(strFile, Trainman.FingerPrint1);
  end;
  if not VarIsEmpty(Trainman.FingerPrint2) then
  begin
    strFile := strPath + Format('%d-%s.fp2', [Trainman.nID, Trainman.strTrainmanNumber]);
    ZKFPEngX.SaveTemplate(strFile, Trainman.FingerPrint2);
  end; 

  bFind := false; 
  n := Length(m_LocalTrainmanArray);
  for i := 0 to n - 1 do
  begin
    if m_LocalTrainmanArray[i].strTrainmanGUID = Trainman.strTrainmanGUID then
    begin
      m_LocalTrainmanArray[i].nID := Trainman.nID;
      m_LocalTrainmanArray[i].strTrainmanGUID := Trainman.strTrainmanGUID;
      m_LocalTrainmanArray[i].strTrainmanName := Trainman.strTrainmanName;
      m_LocalTrainmanArray[i].strTrainmanNumber := Trainman.strTrainmanNumber;
      m_LocalTrainmanArray[i].strJP := Trainman.strJP;
      bFind := true;
      break;
    end;
  end;
  if not bFind then
  begin
    setlength(m_LocalTrainmanArray,n+1);
    m_LocalTrainmanArray[n].nID := Trainman.nID;
    m_LocalTrainmanArray[n].strTrainmanGUID := Trainman.strTrainmanGUID;
    m_LocalTrainmanArray[n].strTrainmanName := Trainman.strTrainmanName;
    m_LocalTrainmanArray[n].strTrainmanNumber := Trainman.strTrainmanNumber;
    m_LocalTrainmanArray[n].strJP := Trainman.strJP;
  end;
  strFile := AppPath + 'Trainman.xml';
  if not FileExists(strFile) then exit;
  XMLDoc := NewXMLDocument();
  try
    XMLDoc.LoadFromFile(strFile);
    RootNode := XMLDoc.DocumentElement;
    if RootNode = nil then RootNode := XMLDoc.AddChild('Trainman');
    if not bFind then
    begin
        Node := RootNode.AddChild('Row' + IntToStr(RootNode.ChildNodes.Count + 1));
        Node.Attributes['nID'] := Trainman.nID;
        Node.Attributes['strTrainmanGUID'] := Trainman.strTrainmanGUID;
        Node.Attributes['strTrainmanName'] := Trainman.strTrainmanName;
        Node.Attributes['strTrainmanNumber'] := Trainman.strTrainmanNumber;
        Node.Attributes['strJP'] := Trainman.strJP;
    end else begin
      for i := 0 to RootNode.ChildNodes.Count - 1 do
      begin
        Node := RootNode.ChildNodes[i];
        if Node.Attributes['strTrainmanGUID'] = Trainman.strTrainmanGUID then
        begin
          Node.Attributes['nID'] := Trainman.nID;
          Node.Attributes['strTrainmanGUID'] := Trainman.strTrainmanGUID;
          Node.Attributes['strTrainmanName'] := Trainman.strTrainmanName;
          Node.Attributes['strTrainmanNumber'] := Trainman.strTrainmanNumber;
          Node.Attributes['strJP'] := Trainman.strJP;
          break;
        end;
      end;
    end;

    RootNode.Attributes['LocalFingerLibGUID'] := DB_SysConfig('SysConfig','ServerFingerLibGUID');
    XMLDoc.SaveToFile(strFile);
  finally
    XMLDoc := nil;
  end;
end;      
procedure TGlobalDM.DeleteLocalFingerTemplate(strTrainmanGUID: string);
var
  i, n: Integer;
  Trainman: RRsTrainman;
  strFile, strPath: string;
  XMLDoc: IXMLDocument;
  RootNode, Node: IXMLNode;
begin
  Trainman.nID := 0;
  n := Length(m_LocalTrainmanArray);
  for i := 0 to n - 1 do
  begin
    if m_LocalTrainmanArray[i].strTrainmanGUID = strTrainmanGUID then
    begin
      Trainman.nID := m_LocalTrainmanArray[i].nID;   
      Trainman.strTrainmanGUID := m_LocalTrainmanArray[i].strTrainmanGUID;
      Trainman.strTrainmanName := m_LocalTrainmanArray[i].strTrainmanName;
      Trainman.strTrainmanNumber := m_LocalTrainmanArray[i].strTrainmanNumber;
      Trainman.strJP := m_LocalTrainmanArray[i].strJP;
      m_LocalTrainmanArray[i].nID := 0;
      m_LocalTrainmanArray[i].strTrainmanGUID := '';
      m_LocalTrainmanArray[i].strTrainmanName := '';
      m_LocalTrainmanArray[i].strTrainmanNumber := '';
      m_LocalTrainmanArray[i].strJP := '';
      break;
    end;
  end;

  strPath := AppPath + 'Fingers\';
  if not DirectoryExists(strPath) then exit;
  strFile := strPath + Format('%d-%s.fp1', [Trainman.nID, Trainman.strTrainmanNumber]);
  if FileExists(strFile) then
  begin
    FileSetAttr(strFile, 0);
    DeleteFile(strFile);
  end;
  strFile := strPath + Format('%d-%s.fp2', [Trainman.nID, Trainman.strTrainmanNumber]);
  if FileExists(strFile) then
  begin
    FileSetAttr(strFile, 0);
    DeleteFile(strFile);
  end;
               
  strFile := AppPath + 'Trainman.xml';
  if not FileExists(strFile) then exit;
  XMLDoc := NewXMLDocument();
  try                      
    XMLDoc.LoadFromFile(strFile);
    RootNode := XMLDoc.DocumentElement;
    if RootNode = nil then exit;

    for i := 0 to RootNode.ChildNodes.Count - 1 do
    begin
      Node := RootNode.ChildNodes[i];
      if Node.Attributes['strTrainmanGUID'] = strTrainmanGUID then
      begin
        RootNode.ChildNodes.Delete(i);
        break;
      end;
    end;

    RootNode.Attributes['LocalFingerLibGUID'] := DB_SysConfig('SysConfig','ServerFingerLibGUID');
    XMLDoc.SaveToFile(strFile);
  finally
    XMLDoc := nil;
  end;
end;



procedure TGlobalDM.SetShowSignPlanStartTime(dtTime:TDateTime);
var
  strTemp:string;
begin
  strTemp := FormatDateTime('yyyy-mm-dd HH:nn:ss',dtTime);
  WriteIniFile(ConfigFileName,'UserData','ShowSignPlanStartTime',strTemp);
end;

procedure TGlobalDM.SetShowTrainmNumber(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if Value then
       nValue := 1;
    ini.WriteString('SysConfig','ShowTrainmNumber',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetShowUserList(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if Value then
       nValue := 1;
    ini.WriteString('SysConfig','ShowUserList',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetSiteNumber(const Value: string);
begin
  WriteIniFile(ConfigFileName,'UserData','SiteNumber',Value);
end;




procedure TGlobalDM.SetWebApiHost(Host: string);
var
  strUpdateIniName:string;
  strUrl:string;
begin
  WriteIniFile(ConfigFileName,'WebApi','URL',Host);

  strUpdateIniName := ExtractFilePath(Application.ExeName) + 'Update.ini';
  strUrl := Format('%s/Web�ӿ�/���³���/GetNewVersion.ashx',[Host]);
  WriteIniFile(strUpdateIniName,'SysConfig','GetNewVersionUrl',strUrl);

end;



function TGlobalDM.GetRecordTel: Boolean;
var
  ini : TIniFile;
  strResult:string;
  nValue:Integer;
begin
  result := False;
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','RecordTel','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nValue);
      if nValue = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetRemeberPWD(): string;
begin
  result := ReadIniFile(ConfigFileName,'Login','PWD');
end;

function TGlobalDM.GetRemeberUser():string;
begin
  result := ReadIniFile(ConfigFileName,'Login','User');
end;

procedure TGlobalDM.TFDBAutoConnectConnect(Sender: TObject);
begin
  try
    //�����ݿ�����
    if assigned(OnDBConnected) then
    begin
      OnDBConnected(ADOConnection);
    end;
    LogManage.InsertLog('���ݿ�����!');
  except

  end;
end;

procedure TGlobalDM.TFDBAutoConnectDisConnect(Sender: TObject);
begin
  try
    //�����ݿ�����
    if assigned(OnDBDisconnected) then
    begin
      OnDBDisconnected(ADOConnection);
    end;
    LogManage.InsertLog('���ݿ�Ͽ�!');
  except

  end;
end;



procedure TGlobalDM.UpdateFingerTemplateByID(const nID: Integer; const fdata1,
  fdata2: OleVariant);
begin
  if FingerprintInitSuccess  then
  begin
    m_FingerBufferManage.RemoveFingerPrint(nID);
    if LengTh(fdata1) > 0 then
      m_FingerBufferManage.AddFingerPrint(fdata1, nID);
    if Length(fdata2) > 0 then
      m_FingerBufferManage.AddFingerPrint(fdata2, nID);
  end;
end;



procedure TGlobalDM.UpdateTrainmainFinger(TrainmanGUID, FingerPrint1,
  FingerPrint2: string);
//����:�޸ĳ���Ա��Ƭ��ָ����Ϣ
var
  nID: Integer;
  adoQuery : TADOQuery;
  Template: OleVariant;
  TemplateStream: TMemoryStream;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConnection;
      Sql.Text := 'Select * from TAB_Org_Trainman ' +
          ' Where strTrainmanGUID = ' + QuotedStr(TrainmanGUID);
      Open;
      nID := ADOQuery.FindField('nID').AsInteger;
      Edit;
      if FingerPrint1 <> '' then
      begin
        Template := GlobalDM.ZKFPEngX.DecodeTemplate1(FingerPrint1);
        TemplateStream := TMemoryStream.Create;
        TemplateOleVariantToStream(Template, TemplateStream);
        (ADOQuery.FieldByName('Fingerprint1') as TBlobField).LoadFromStream(TemplateStream);
        TemplateStream.Free;
      end;
      if FingerPrint2 <> '' then
      begin
        Template := GlobalDM.ZKFPEngX.DecodeTemplate1(FingerPrint2);
        TemplateStream := TMemoryStream.Create;
        TemplateOleVariantToStream(Template, TemplateStream);
        (ADOQuery.FieldByName('Fingerprint2') as TBlobField).LoadFromStream(TemplateStream);
        TemplateStream.Free;
      end;
      Post;
      //���±���ָ��������
      if GlobalDM.FingerprintInitSuccess then
      begin
        GlobalDM.UpdateFingerTemplateByID(nID,
          GlobalDM.ZKFPEngX.DecodeTemplate1(FingerPrint1),
          GlobalDM.ZKFPEngX.DecodeTemplate1(FingerPrint2));
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TGlobalDM.WndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_MSGFingerCapture then
  begin
    ZKFPEngX.OnFingerTouching := nil;
    try
      if Assigned(OnFingerTouching) then
          OnFingerTouching(ZKFPEngX);
    finally
      ZKFPEngX.OnFingerTouching := FingerTouchingProc;
    end;
  end;
end;



procedure TGlobalDM.WriteGridRowHeight(Grid: TAdvStringGrid);
var
  Ini: TIniFile;
  strIniFile, strSection, strKey: string;
  nRowHeight : integer ;
begin
  strSection := Grid.Name + 'RowHeight' ;
  strIniFile := 'FormRowHeights.ini';
  strIniFile := ExtractFilePath(Application.ExeName) + strIniFile;
  Ini:=TIniFile.Create(strIniFile);
  try
    nRowHeight := Grid.RowHeights[1] ;
    Ini.WriteInteger(strSection, 'DefaultRowHeight', nRowHeight);
  finally
    Ini.Free();
  end;
end;

function TGlobalDM.GetUIFont(Section: string): TFont;
var
  ini : TIniFile;
  font : TFont ;
begin
  font := TFont.Create;
  font.Name := '����' ;
  Font.Charset := GB2312_CHARSET  ;
  Font.Color := clWindowText    ;
  Font.Height := -35    ;
  Font.Style := [fsBold]      ;

  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
   font.Name  := ini.ReadString(Section,'Name','����');
   font.Height := ini.ReadInteger(Section,'Height',-35 );
   font.Color := ini.ReadInteger(Section,'Color',Font.Color);
   //Font.Style := ini.ReadInteger('SysConfig',Section,  Font.Style  );
   result := font ;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetUninterruptedSign: Boolean;
var
  ini : TIniFile;
  strResult:string;
  nValue:Integer;
begin
  result := False;
  nValue := 0;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    strResult := trim(ini.ReadString('SysConfig','UninterruptedSign','0'));
    if strResult <> ''then
    begin
      TryStrToInt(strResult,nValue);
      if nValue = 1 then
        result := True;
    end;
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetUpdateInfo(): boolean;
var
  IdHTTP: TIdHTTP;
  iJSON: ISuperObject;
  strUrl, strUpdateInfo: string; 
  Ini: TIniFile;
  strGetNewVersionUrl, strProjectID, strProjectVersion: string;
begin
  result := false;

  if FileExists(AppPath + 'Update.ini') then
  begin
    Ini := TIniFile.Create(AppPath + 'Update.ini');
    try                  
      strGetNewVersionUrl := Trim(Ini.ReadString('SysConfig', 'GetNewVersionUrl', ''));
      strProjectID := Trim(Ini.ReadString('SysConfig', 'ProjectID', ''));
      strProjectVersion := Trim(Ini.ReadString('SysConfig', 'ProjectVersion', ''));
    finally
      Ini.Free();
    end;
  end;
  if (strGetNewVersionUrl='') or (strProjectID = '') then exit;
  
  try                       
    strUrl := strGetNewVersionUrl + Format('?pid=%s&version=%s', [strProjectID, strProjectVersion]);
    IdHTTP := TIdHTTP.Create(nil);
    try
      IdHTTP.Disconnect;
      IdHTTP.Request.Pragma := 'no-cache';
      IdHTTP.Request.CacheControl := 'no-cache';
      IdHTTP.Request.Connection := 'close';
      IdHTTP.ReadTimeout := 1000;
      IdHTTP.ConnectTimeout := 1000;
      strUpdateInfo := IdHTTP.Get(strUrl);
      strUpdateInfo := Utf8ToAnsi(strUpdateInfo);
      IdHTTP.Disconnect;
    finally
      IdHTTP.Free;
    end;
    if strUpdateInfo = '' then exit;

    iJSON := SO(strUpdateInfo);
    result := iJSON.B['NeedUpdate'];
    iJSON := nil;
  except on e : exception do
    //TtfPopBox.ShowBox('���ҷ������ϵĿ�������ʱ�������쳣��'#13#10#13#10'�쳣��Ϣ��'+e.Message);
  end;
end;


function TGlobalDM.GetUsesOutWorkSign():Boolean;
var
  strUses:string;
begin
  Result := False ;
  strUses := ReadIniFile(ConfigFileName,'SysConfig','UsesOutWorkSign');
  if strUses = '' then
    Exit
  else
    Result := StrToBool(strUses);
end;



procedure TGlobalDM.SetOutWorkSign(AUses:Boolean);
var
  strUses:string;
begin
  if AUses then
    strUses := '1'
  else
    strUses := '0';
  WriteIniFile(ConfigFileName,'SysConfig','UsesOutWorkSign',strUses);
end;




procedure TGlobalDM.SetRecordTel(Value: Boolean);
var
  ini : TIniFile;
  nValue:Integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    nValue := 0;
    if Value then
       nValue := 1;
    ini.WriteString('SysConfig','RecordTel',inttostr(nValue));
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetRemeberPWD(const Value: string);
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    ini.WriteString('Login','PWD',Value);
  finally
    ini.Free;
  end;
end;

procedure TGlobalDM.SetRemeberUser(const Value: string);
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    ini.WriteString('Login','User',Value);
  finally
    ini.Free;
  end;
end;



function TGlobalDM.GetWebApiHost: string;
begin
  Result := ReadIniFile(ConfigFileName,'WebApi','URL');
end;

function TGlobalDM.GetWebUrl: string;
var
  strUrl : string;
begin
  //strUrl := Format('%s/AshxService/DataProcess.ashx?',[GetWebApiHost]);
  strUrl := Format('%s/AshxService/QueryProcess.ashx?',[GetWebApiHost]);
  Result := strUrl ;
end;



end.
