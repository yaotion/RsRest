unit ufrmFingerRegister;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,ZKFPEngXControl_TLB, RzPanel, ImgList,
  uTFSystem;

type
  TfrmFingerRegister = class(TForm)
    btnClose: TButton;
    btnSave: TButton;
    labText: TLabel;
    Bevel1: TBevel;
    btnFinger1: TSpeedButton;
    btnFinger2: TSpeedButton;
    Timer: TTimer;
    RzPanel1: TRzPanel;
    ImgFinger: TImage;
    imgLog: TImage;
    ImageList: TImageList;
    labEnrollState: TLabel;
    Image1: TImage;
    Image2: TImage;
    ImgLabelArrow: TImage;
    ImgbuttonArrow: TImage;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFingerClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_strFinger1Register : String;//指纹特征1
    m_strFinger2Register : String;//指纹特征2
    m_ZKFPEng: TZKFPEngX;//指纹捕捉组件
    m_nCurrentRegisterFingerIndex : Integer;//当前进行登记的指纹序号
    m_OldTouchingEvent:TNotifyEvent;
    m_OldFingerLoginSuccess:TOnEventByString;
  private
    procedure OnZKFPEngEnroll(ASender: TObject; ActionResult: WordBool;
      ATemplate: OleVariant);
    procedure OnZKFPEngFeatureInfo(ASender: TObject; AQuality: Integer);
    procedure OnZKFPEngXOnImageReceived(ASender: TObject; var AImageValid: WordBool);
    procedure DisplayEnrollState();
    procedure SetImgageLog(nType : Integer);
  public
    { Public declarations }
  end;


function FingerRegister(var strFinger1Register,strFinger2Register : String ;
    ZKFPEng: TZKFPEngX;DefaultOne : boolean = false):Boolean;

implementation
uses
  uGlobalDM;
{$R *.dfm}

function FingerRegister(var strFinger1Register,strFinger2Register : String ;
    ZKFPEng: TZKFPEngX;DefaultOne : boolean = false):Boolean;
//功能:指纹登记
var
  frmFingerRegister : TfrmFingerRegister;
begin
  Result := False;
  frmFingerRegister := TfrmFingerRegister.Create(nil);
  try
    frmFingerRegister.m_ZKFPEng := ZKFPEng;
    ZKFPEng.OnImageReceived := frmFingerRegister.OnZKFPEngXOnImageReceived;
    ZKFPEng.OnFeatureInfo := frmFingerRegister.OnZKFPEngFeatureInfo;
    ZKFPEng.OnEnroll := frmFingerRegister.OnZKFPEngEnroll;
    ZKFPEng.CancelEnroll;
    if DefaultOne then
      frmFingerRegister.btnFinger1.Click;
    if frmFingerRegister.ShowModal = mrok then
    begin
      strFinger1Register := frmFingerRegister.m_strFinger1Register;
      strFinger2Register := frmFingerRegister.m_strFinger2Register;
      Result := True;
    end;
  finally
    ZKFPEng.OnImageReceived := nil;
    ZKFPEng.OnFeatureInfo := nil;
    ZKFPEng.OnEnroll := nil;
    frmFingerRegister.Free;
  end;
end;




procedure TfrmFingerRegister.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFingerRegister.btnFingerClick(Sender: TObject);
begin
  Image1.Visible := False;
  Image2.Visible := False;

  m_nCurrentRegisterFingerIndex := TSpeedButton(Sender).Tag;
  Timer.Enabled := False;  
  m_ZKFPEng.BeginEnroll;

  labText.Caption := '正在登记指纹'+inttostr(m_nCurrentRegisterFingerIndex)+
      ',请按下要登记的指纹...';
      
  labEnrollState.Font.Color := clNavy;
  labEnrollState.Caption := '还需要按压' +
      IntToStr(m_ZKFPEng.EnrollCount) + '次!';

  ImgLabelArrow.Visible := True;

  if m_nCurrentRegisterFingerIndex = 1 then
    ImgButtonArrow.Top := 165
  else
    ImgButtonArrow.Top := 193;

  ImgButtonArrow.Visible := True;
  
  labEnrollState.Visible := True;

end;

procedure TfrmFingerRegister.btnSaveClick(Sender: TObject);
begin
  ModalResult := mrok;
end;

procedure TfrmFingerRegister.DisplayEnrollState;
//功能:显示指纹登记状态
begin
  labEnrollState.Caption := '还需要按压' +
      IntToStr(m_ZKFPEng.EnrollIndex - 1) + '次!';
end;

procedure TfrmFingerRegister.FormCreate(Sender: TObject);
begin
  m_OldTouchingEvent := GlobalDM.OnFingerTouching;
  m_OldFingerLoginSuccess := GlobalDM.OnFingerLoginSuccess;
  GlobalDM.OnFingerTouching := nil;
  GlobalDM.OnFingerLoginSuccess :=nil;
  labText.Caption := '    请先选择登记指纹后,连续按压三次，进行指纹登记';
  labText.Font.Color := clBlack;
  m_nCurrentRegisterFingerIndex := 1;
end;

procedure TfrmFingerRegister.FormDestroy(Sender: TObject);
begin
  GlobalDM.OnFingerTouching :=  m_OldTouchingEvent;
  GlobalDM.OnFingerLoginSuccess  :=m_OldFingerLoginSuccess;
end;

procedure TfrmFingerRegister.OnZKFPEngEnroll(ASender: TObject;
  ActionResult: WordBool; ATemplate: OleVariant);
//功能:获得指纹
begin
  if ActionResult then
  begin
    labEnrollState.Font.Color := clNavy;
    labEnrollState.Caption := '指纹采集成功!';
    if m_nCurrentRegisterFingerIndex = 1 then
    begin
      m_strFinger1Register := m_ZKFPEng.EncodeTemplate1(ATemplate);
      ImageList.GetBitmap(1,Image1.Picture.Bitmap);
      Image1.Visible := True;
    end
    else
    begin
      m_strFinger2Register := m_ZKFPEng.EncodeTemplate1(ATemplate);
      ImageList.GetBitmap(1,Image2.Picture.Bitmap);
      Image2.Visible := True;            
    end;
    SetImgageLog(1);
  end
  else
  begin
    labEnrollState.Font.Color := clRed;
    labEnrollState.Caption := '指纹采集失败!';

    if m_nCurrentRegisterFingerIndex = 1 then
    begin
      m_strFinger1Register := '';
      m_strFinger1Register := m_ZKFPEng.EncodeTemplate1(ATemplate);
      ImageList.GetBitmap(0,Image1.Picture.Bitmap);
      Image1.Visible := True;
    end
    else
    begin
      m_strFinger2Register := '';
      m_strFinger2Register := m_ZKFPEng.EncodeTemplate1(ATemplate);
      ImageList.GetBitmap(0,Image2.Picture.Bitmap);
      Image2.Visible := True;      
    end;
    SetImgageLog(0);
  end;

  m_ZKFPEng.CancelEnroll;

  ImgLabelArrow.Visible := False;
  ImgbuttonArrow.Visible := False;

  labText.Caption := '    请先选择登记指纹后,连续按压三次，进行指纹登记';
  Timer.Enabled := True;

end;

procedure TfrmFingerRegister.OnZKFPEngFeatureInfo(ASender: TObject;
  AQuality: Integer);
//功能:获得指纹采集信息
begin
  if m_ZKFPEng.IsRegister = False then Exit;
  DisplayEnrollState();
end;

procedure TfrmFingerRegister.OnZKFPEngXOnImageReceived(ASender: TObject;
  var AImageValid: WordBool);
begin
  if m_ZKFPEng.IsRegister = False then Exit;
  if AImageValid = False then Exit;
  m_ZKFPEng.SaveBitmap('Finger.bmp');
  ImgFinger.Picture.LoadFromFile('Finger.bmp');
end;

procedure TfrmFingerRegister.SetImgageLog(nType: Integer);
//功能:设置ImgLog图标,1为成功,0为失败,-1为隐藏
begin
  imgLog.Picture.Graphic := Nil;
  if nType <> -1 then
    ImageList.GetBitmap(nType,imgLog.Picture.Bitmap);
  imgLog.Visible := nType <> -1;
end;

procedure TfrmFingerRegister.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  labEnrollState.Visible := False;
  imgLog.Visible := False;
  SetImgageLog(-1);
end;

end.
