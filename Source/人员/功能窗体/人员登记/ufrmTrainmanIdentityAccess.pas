unit ufrmTrainmanIdentityAccess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, RzEdit, Buttons, PngBitBtn, RzAnimtr,
  PngSpeedButton, pngimage, RzPanel,ufrmTextInput,ZKFPEngXControl_TLB,
  utfsystem,uSaftyEnum,uTrainman,uDBLocalTrainman;

const
  WM_TRAINMANFINHERPRINTLOGIN = WM_User+ 1;
  //指纹识别失败，wParam=0 指纹仪故障，wParam=1 找不到司机的指纹
  WM_FingerFail = WM_User + 2;
  //窗体显示
  WM_FormShow = WM_User + 3;


type
  TFrmTrainmanIdentityAccess = class(TForm)
    Label10: TLabel;
    lbl1: TLabel;
    RzPanel7: TRzPanel;
    Label11: TLabel;
    Image4: TImage;
    Panel1: TPanel;
    Label12: TLabel;
    lblAnalysis: TLabel;
    RzPanel2: TRzPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lblTrainmanName1: TLabel;
    lblTrainmanNumber1: TLabel;
    imgTrainmanPicture1: TPaintBox;
    btnCancelTrainman1: TPngSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    RzPanel1: TRzPanel;
    RzPanel3: TRzPanel;
    ImgFinger: TImage;
    Animator: TRzAnimator;
    btnCancel: TPngBitBtn;
    edtGongHaoInput: TRzEdit;
    pngbtnOK: TPngBitBtn;
    tmrAutoHideHint: TTimer;
    tmrRevocation: TTimer;
    procedure tmrAutoHideHintTimer(Sender: TObject);
    procedure tmrRevocationTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pngbtnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  public
    {初始化窗体显示}
    procedure ClearInfo;    
  private
    {功能:按下指纹仪}
    procedure OnFingerTouching(Sender:TObject);
    {功能:识别失败}
    procedure OnFingerLoginFailure(Sender:TObject);
    {功能：乘务员登录}
    procedure OnFingerLoginSuccess(strUserNumber : String);
    {功能:指纹图像捕捉}
    procedure OnZKFPEngXOnImageReceived(ASender: TObject; var AImageValid: WordBool);
    
    procedure LoadTrainman(strTrainmanNumber: String;
      RegisterFlag: TRsRegisterFlag;bFingureSucess:Boolean);
    procedure ShowTrainmanInfo ;
    {功能:响应乘务员指纹登录消息}
    procedure WMTrainmanLogin(var Message:TMessage);Message WM_TRAINMANFINHERPRINTLOGIN;
    //指纹识别失败消息
    procedure WMFingerFail(var Message:TMessage);Message WM_FingerFail;
    procedure WMFormShow(var message : TMessage);message WM_FormShow;
  private
    {是否有功能在运行}
    m_bIsRunFunction : Boolean;
    {最后一次登记的工号}
    m_strLastTrainmanNumber : String;
    {乘务员列表}
    m_TrainMan : RRsTrainman;
    m_nVerify : TRsRegisterFlag;
    m_DBTrainman : TRsDBLocalTrainman;
    m_bInputShowed : Boolean;
    m_nFingureErr : Integer;
    m_oldTouchingEvent:TNotifyEvent;
    m_oldFingerSucEvent:TOnEventByString;
    m_oldFingerFalEvent:TNotifyEvent;
    m_oldImageReceived:TZKFPEngXOnImageReceived;
    m_bFirst : boolean;

    m_strTrainmanGUID1:string;
    m_strTrainmanGUID2:string;
    m_strTrainmanGUID3:string;
    m_strTrainmanGUID4:string;
  public
    class function IdentfityTrainman(Sender : TObject;var Trainman:RRsTrainman;
    out Verify : TRsRegisterFlag;strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3:string;strTrainmanGUID4:string;DefaultTrainmanNumber:string = '') : boolean;

  published
    property TrainmanGUID1:string read m_strTrainmanGUID1 write m_strTrainmanGUID1; 
    property TrainmanGUID2:string read m_strTrainmanGUID2 write m_strTrainmanGUID2;
    property TrainmanGUID3:string read m_strTrainmanGUID3 write m_strTrainmanGUID3;
    property TrainmanGUID4:string read m_strTrainmanGUID4 write m_strTrainmanGUID4;
  end;

  const MAX_ERROR_CNT = 20;
var
  nFailureCnt:Integer;



var
  FrmTrainmanIdentityAccess: TFrmTrainmanIdentityAccess;

implementation

uses
  uGlobalDM ;

{$R *.dfm}

procedure TFrmTrainmanIdentityAccess.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TFrmTrainmanIdentityAccess.ClearInfo;
begin
  m_strLastTrainmanNumber := '';
  Invalidate;
end;

procedure TFrmTrainmanIdentityAccess.FormCreate(Sender: TObject);
begin
  Animator.Visible := False;
  m_bFirst := true;
  m_oldTouchingEvent := GlobalDM.OnFingerTouching;
  m_oldFingerSucEvent := GlobalDM.OnFingerLoginSuccess;
  m_oldFingerFalEvent := GlobalDM.OnFingerLoginFailure;
  m_oldImageReceived := GlobalDM.ZKFPEngX.OnImageReceived;
  GlobalDM.OnFingerLoginFailure := OnFingerLoginFailure;
  GlobalDM.OnFingerLoginSuccess := OnFingerLoginSuccess;
  GlobalDM.OnFingerTouching := OnFingerTouching;
  GlobalDM.ZKFPEngX.OnImageReceived := OnZKFPEngXOnImageReceived;
  m_bIsRunFunction := False;
  m_DBTrainman := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmTrainmanIdentityAccess.FormDestroy(Sender: TObject);
begin
  GlobalDM.OnFingerTouching := m_oldTouchingEvent;
  GlobalDM.OnFingerLoginSuccess := m_oldFingerSucEvent;
  GlobalDM.OnFingerLoginFailure := m_oldFingerFalEvent;
  GlobalDM.ZKFPEngX.OnImageReceived := m_oldImageReceived;
  m_DBTrainman.Free;
end;

procedure TFrmTrainmanIdentityAccess.FormShow(Sender: TObject);
begin
  if not m_bFirst then exit;
  m_bFirst := false;
  PostMessage(Handle,WM_FormShow,0,0);;
end;

class function TFrmTrainmanIdentityAccess.IdentfityTrainman(Sender: TObject;
  var Trainman: RRsTrainman; out Verify: TRsRegisterFlag; strTrainmanGUID1,
  strTrainmanGUID2, strTrainmanGUID3, strTrainmanGUID4,
  DefaultTrainmanNumber: string): boolean;
var
  frmIdentity: TFrmTrainmanIdentityAccess;
begin
  Result := false;

  frmIdentity := TFrmTrainmanIdentityAccess.Create(nil);
  try
    frmIdentity.TrainmanGUID1 := strTrainmanGUID1;
    frmIdentity.TrainmanGUID2 := strTrainmanGUID2;
    frmIdentity.TrainmanGUID3 := strTrainmanGUID3;
    frmIdentity.TrainmanGUID4 := strTrainmanGUID4;
    frmIdentity.edtGongHaoInput.Text := DefaultTrainmanNumber;
    if Sender <> nil then
      frmIdentity.OnFingerTouching(Sender);
    if frmIdentity.ShowModal = mrOk then
    begin
      TrainMan := frmIdentity.m_TrainMan;
      Verify := frmIdentity.m_nVerify;
      Result := true;
    end;
  finally
    frmIdentity.Free;
  end;
end;

procedure TFrmTrainmanIdentityAccess.LoadTrainman(strTrainmanNumber: String;
  RegisterFlag: TRsRegisterFlag; bFingureSucess: Boolean);
{功能:有新的乘务员登记}
begin
  if not bFingureSucess then
  begin
    lblAnalysis.Show;
    lblAnalysis.Caption := '指纹识别失败!,还可按压2次';
    m_nFingureErr := 1;
    Exit;
  end;

  if Length(Trim(strTrainmanNumber)) = 0 then
    Exit;

  if GlobalDM.blnIsLocalMode then
  begin
    GlobalDM.GetLocalTrainmanByNumber(strTrainmanNumber, m_TrainMan);
    if m_TrainMan.strTrainmanGUID = '' then m_TrainMan.strTrainmanGUID := 'do not delete or error';
  end
  else
    m_DBTrainman.GetTrainmanByNumber(strTrainmanNumber,m_TrainMan);
end;

procedure TFrmTrainmanIdentityAccess.OnFingerLoginFailure(Sender: TObject);
var
  strNumber:string;
  nCnt :Integer;
begin
  m_nFingureErr := m_nFingureErr+1;
  tmrRevocation.Enabled := False;
  tmrAutoHideHint.Enabled := False;
  tmrAutoHideHint.Enabled := True;
  Animator.Visible := False;
  nCnt := MAX_ERROR_CNT - m_nFingureErr;

  if m_nFingureErr = MAX_ERROR_CNT then
  begin
    m_nFingureErr := 0;

    if TextInput('乘务员身份验证','指纹识别失败,请输入乘务员工号:',strNumber) = False then
      Exit;
    if m_DBTrainman.ExistTrainmanByNumber(strNumber) = False then
    begin
      m_bInputShowed := false;
      //ModalResult := mrCancel;
      Box('错误的工号');
      exit;
    end
    else
    begin
      m_strLastTrainmanNumber := strNumber;
      PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN,
        Ord(rfFingerprint),0);
    end;
  end;
  lblAnalysis.Caption := '指纹识别失败!,还可按压'+IntToStr(nCnt)+'次';
  GlobalDM.PlaySoundFile('指纹识别失败.wav');
end;

procedure TFrmTrainmanIdentityAccess.OnFingerLoginSuccess(
  strUserNumber: String);
{功能：乘务员登录}
begin
  if m_bIsRunFunction then Exit;
  if StrComp(PAnsiChar(m_strLastTrainmanNumber),PAnsiChar(strUserNumber)) = 0 then  Exit;
  m_nFingureErr := 0;
  tmrAutoHideHint.Enabled := True;
  tmrRevocation.Enabled := False;
  Animator.Visible := False;
  lblAnalysis.Caption := '识别成功!';
  GlobalDM.PlaySoundFile('指纹识别成功.wav');
  if m_strLastTrainmanNumber = '' then
  begin
    m_strLastTrainmanNumber := strUserNumber;
    PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN,Ord(rfFingerprint),0);
  end;
end;

procedure TFrmTrainmanIdentityAccess.OnFingerTouching(Sender: TObject);
begin
  tmrAutoHideHint.Enabled := False;
  tmrRevocation.Enabled := True;
  lblAnalysis.Caption := '正在识别指纹...';
  lblAnalysis.Visible := True;
  Animator.Visible := True;
end;

procedure TFrmTrainmanIdentityAccess.OnZKFPEngXOnImageReceived(ASender: TObject;
  var AImageValid: WordBool);
begin
  if AImageValid = False then Exit;
  GlobalDM.ZKFPEngX.SaveBitmap('Finger.bmp');
  ImgFinger.Picture.LoadFromFile('Finger.bmp');
end;

procedure TFrmTrainmanIdentityAccess.pngbtnOKClick(Sender: TObject);
begin
  if Trim(edtGongHaoInput.Text) = '' then
  begin
    MessageBox(Handle,'请输入工号!','错误',MB_ICONHAND);
    Exit;
  end;
  m_strLastTrainmanNumber := Trim(edtGongHaoInput.Text);
  if GlobalDM.blnIsLocalMode then
  begin
    PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN, Ord(rfInput),0);
    exit;
  end;
  if m_DBTrainman.ExistTrainmanByNumber(m_strLastTrainmanNumber) = False then
  begin
    edtGongHaoInput.SetFocus;
    MessageBox(Handle,'输入的工号不存在,请重新输入!','错误',MB_ICONHAND);
    Exit;
  end
  else
  begin
    if not((TrainmanGUID1 = '') and (TrainmanGUID2= '') and (TrainmanGUID3='') and (TrainmanGUID4='')) then
    begin
      m_DBTrainman.GetTrainmanByNumber(m_strLastTrainmanNumber,m_TrainMan);
      if (m_TrainMan.strTrainmanGUID <> TrainmanGUID1) and
        (m_TrainMan.strTrainmanGUID <> TrainmanGUID2) and
        (m_TrainMan.strTrainmanGUID <> TrainmanGUID3) and
        (m_TrainMan.strTrainmanGUID <> TrainmanGUID4) then
      begin
        edtGongHaoInput.SetFocus;
        MessageBox(Handle,'不是本班人员,请重新输入!','错误',MB_ICONHAND);
        Exit;
      end;
    end;
    PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN,
      Ord(rfInput),0);
  end;
end;

procedure TFrmTrainmanIdentityAccess.ShowTrainmanInfo;
{功能:显示乘务员信息}
begin
  if m_TrainMan.strTrainmanGUID <> '' then
  begin
    lblTrainmanName1.Caption := m_TrainMan.strTrainmanName;
    lblTrainmanNumber1.Caption := m_TrainMan.strTrainmanNumber;
    btnCancelTrainman1.Visible := True;
    imgTrainmanPicture1.Repaint;
  end
  else
  begin
    lblTrainmanName1.Caption := '';
    lblTrainmanNumber1.Caption := '';
    btnCancelTrainman1.Visible := False;
    imgTrainmanPicture1.Repaint;
  end;
end;

procedure TFrmTrainmanIdentityAccess.tmrAutoHideHintTimer(Sender: TObject);
begin
  tmrAutoHideHint.Enabled := False;
end;

procedure TFrmTrainmanIdentityAccess.tmrRevocationTimer(Sender: TObject);
begin
  OnFingerLoginFailure(nil);
end;

procedure TFrmTrainmanIdentityAccess.WMFingerFail(var Message: TMessage);
var
  strNumber : string;
begin
  if not GlobalDM.FingerprintInitSuccess then
  begin
    if TextInput('乘务员身份验证','指纹仪故障,请输入乘务员工号:',strNumber) = False then
    begin
      ModalResult := mrCancel;
      Exit;
    end;
  end else begin
    if TextInput('乘务员身份验证','没有找到匹配的指纹,请输入乘务员工号:',strNumber) = False then
    begin
      Exit;
    end;
  end;

  if m_DBTrainman.ExistTrainmanByNumber(strNumber) = False then
  begin
    m_bInputShowed := false;
    Box('错误的工号');
    exit;
  end
  else
  begin
    m_strLastTrainmanNumber := strNumber;
    PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN,Ord(rfInput),0);
  end;
end;

procedure TFrmTrainmanIdentityAccess.WMFormShow(var message: TMessage);
var
  strNumber : string;
begin
  if m_Trainman.strTrainmanGUID <> '' then
    PostMessage(Handle,WM_FingerFail,0,0)
  else begin
    if not GlobalDM.FingerprintInitSuccess then
    begin
      if TextInput('乘务员身份验证','指纹仪故障,请输入乘务员工号:',strNumber) = False then
      begin
        ModalResult := mrCancel;
        Exit;
      end;
      if m_DBTrainman.ExistTrainmanByNumber(strNumber) = False then
      begin
        m_bInputShowed := false;
        Box('错误的工号');
        exit;
      end
      else
      begin
        m_strLastTrainmanNumber := strNumber;
        PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN,Ord(rfInput),0);
      end;
    end;
  end;
end;

procedure TFrmTrainmanIdentityAccess.WMTrainmanLogin(var Message: TMessage);
begin
  if Message.WParam = Ord(rfFingerprint) then
  begin
    LoadTrainman(m_strLastTrainmanNumber,rfFingerprint,true);
    m_nVerify := rfFingerprint;
  end
  else
  begin
    LoadTrainman(m_strLastTrainmanNumber,rfInput,True);
    m_nVerify := rfInput;
  end;
  ShowTrainmanInfo;
  ModalResult := mrOk;
end;

end.
