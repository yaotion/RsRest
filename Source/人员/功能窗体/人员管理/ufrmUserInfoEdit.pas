unit ufrmUserInfoEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ComCtrls, RzDTP, StdCtrls, Mask, RzEdit, RzCmboBx,
  pngimage, ExtCtrls, PngSpeedButton, RzPanel, Buttons, PngCustomButton,
  utfsystem,uTrainman,uDBLocalTrainman,
  DSUtil,DirectShow9,ufrmgather,JPEG,ZKFPEngXUtils,uWorkShop,uGuideGroup,
  DateUtils,uSaftyEnum;

type
  TfrmUserInfoEdit = class(TForm)
    PngCustomButton1: TPngCustomButton;
    Label5: TLabel;
    RzPanel2: TRzPanel;
    btnCancel: TButton;
    btnSave: TButton;
    RzGroupBox1: TRzGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label17: TLabel;
    Label6: TLabel;
    btnCapturePicture: TPngSpeedButton;
    btnLoadPicture: TPngSpeedButton;
    btnFingerRegister: TPngSpeedButton;
    labwebcamError: TLabel;
    imgwebcamError: TImage;
    Image1: TImage;
    labError: TLabel;
    RzPanel1: TRzPanel;
    imgPicture: TImage;
    comboGuideGroup: TRzComboBox;
    comboTrainJiaolu: TRzComboBox;
    comboWorkShop: TRzComboBox;
    comboPost: TRzComboBox;
    edtNumber: TRzEdit;
    edtName: TRzEdit;
    RzGroupBox2: TRzGroupBox;
    Label10: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label19: TLabel;
    Label8: TLabel;
    Label18: TLabel;
    Label4: TLabel;
    Label16: TLabel;
    Label15: TLabel;
    Label14: TLabel;
    Label9: TLabel;
    Label20: TLabel;
    comboDriverType: TRzComboBox;
    comboDriveLevel: TRzComboBox;
    comboIsKey: TRzComboBox;
    comboABCD: TRzComboBox;
    comboKehuo: TRzComboBox;
    edtTelNumber: TRzEdit;
    edtMobileNumber: TRzEdit;
    edtRestLength: TRzEdit;
    edtLastEndWorkTime: TRzEdit;
    edtAddress: TRzEdit;
    edtRemark: TRzEdit;
    dtpRuduanDate: TRzDateTimePicker;
    dtpRenzhiDate: TRzDateTimePicker;
    ADOQuery: TADOQuery;
    OD: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLoadPictureClick(Sender: TObject);
    procedure btnCapturePictureClick(Sender: TObject);
    procedure btnFingerRegisterClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    {当前操作人员ID}
    m_strGUID : String;
    //信息编辑状态
    m_EditType : TDBOperationType;
    //指纹特征1
    m_strFinger1Register : String;
    //指纹特征2
    m_strFinger2Register : String;
    //照片
    m_PictureStream : TMemoryStream;
    //界面数据是否发生变化
    m_bChange : Boolean;
    //当前操作的司机信息
    m_Trainman : RRsTrainman;
    //司机数据库操作
    m_DBTrainman : TRsDBLocalTrainman;
  private
        {功能:初始化指纹仪}
    procedure InitZKFPEng;
    procedure WMDevicechange(var Msg:TMessage); message WM_DEVICECHANGE;
    {功能:检查用户输入}
    function CheckInput():Boolean;
    {功能:读取数据}
    procedure ReadData(strGUID : String);
    //收集数据
    procedure GatherData(var trainman : RRsTrainman);

    //初始化组织结构控件
    procedure InitOrgCtrls;
  public
          {功能:添加乘务员信息}
    class function AppendTrainmanInfo():Boolean;
    {功能:修改乘务员信息}
    class function ModifyTrainmanInfo(strGUID : String):Boolean;
  end;



var
  frmUserInfoEdit: TfrmUserInfoEdit;

implementation

uses
  uGlobalDM ,
  ufrmFingerRegister;

{$R *.dfm}

class function TfrmUserInfoEdit.AppendTrainmanInfo: Boolean;
//功能:添加乘务员信息
var
  frmUserInfoEdit: TfrmUserInfoEdit;
begin
  Result := False;
  frmUserInfoEdit:= TfrmUserInfoEdit.Create(nil);
  try
    frmUserInfoEdit.Caption := '添加司机信息';
    frmUserInfoEdit.InitOrgCtrls;
    frmUserInfoEdit.m_EditType := otInsert;
    if frmUserInfoEdit.ShowModal = mrok then
      Result := True;
  finally
    frmUserInfoEdit.Free;
  end;
end;

procedure TfrmUserInfoEdit.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TfrmUserInfoEdit.btnCapturePictureClick(Sender: TObject);
var
  JpegGraphic: TJpegImage;
begin
  if PictureGather(m_PictureStream) then
  begin
    m_bChange := True;  
    m_PictureStream.Position := 0;
    JpegGraphic := TJpegImage.Create;
    JpegGraphic.LoadFromStream(m_PictureStream);
    imgPicture.Picture.Graphic := JpegGraphic;
    JpegGraphic.Free;
  end;
end;

procedure TfrmUserInfoEdit.btnFingerRegisterClick(Sender: TObject);
begin
  if FingerRegister(m_strFinger1Register,m_strFinger2Register,GlobalDM.ZKFPEngX) then
    m_bChange := True;
end;

procedure TfrmUserInfoEdit.btnLoadPictureClick(Sender: TObject);
begin
  if OD.Execute = False then Exit;
  m_bChange := True;
  ImgPicture.Picture.LoadFromFile(OD.FileName);
  m_PictureStream.LoadFromFile(OD.FileName);
end;

procedure TfrmUserInfoEdit.btnSaveClick(Sender: TObject);
var
  nID:Integer ;
  trainman : RRsTrainman;
begin
  nID := 0 ;
  if CheckInput() = False then Exit;

  trainman := m_Trainman;
  //收集数据
  GatherData(trainman);
  try
    if m_EditType = otInsert then
    begin
      if  m_DBTrainman.GetTrainmanMaxID(nID)  then
        trainman.nID := nID ;
      trainman.strTrainmanGUID := NewGUID;
      m_DBTrainman.AddTrainman(trainman);
    end
    else begin
      m_DBTrainman.UpdateTrainman(trainman);
    end;
  except on e : exception do
    begin
      Box('保存数据失败：' + e.Message);
      exit;
    end;
  end;

  try
    //更新指纹库特征码
    if m_DBTrainman.GetTrainmanByNumber(edtNumber.Text,trainman) then
    GlobalDM.UpdateFingerTemplateByID(trainman.nID,trainman.FingerPrint1,trainman.FingerPrint2);
  except on e : exception do
    begin
      Box('更新指纹特征失败:' + e.Message);
      exit;
    end;
  end;
  ModalResult := mrOK;
end;

function TfrmUserInfoEdit.CheckInput: Boolean;
//功能:检查用户输入是否合法
begin
  Result := False;
  if Trim(edtNumber.Text) = '' then
  begin
    Box('请输入工号!');
    edtNumber.SetFocus;
    Exit;
  end;

  if Trim(edtName.Text) = '' then
  begin
    Box('请输入姓名!');
    edtName.SetFocus;
    Exit;
  end;

  if m_DBTrainman.ExistNumber(m_Trainman.strTrainmanGUID,Trim(edtNumber.Text)) then
  begin
    Box('该工号已经存在！请重新输入！');
    edtNumber.SetFocus;
    edtNumber.SelectAll;
    Exit;
  end;

  Result := True;
end;

procedure TfrmUserInfoEdit.FormCreate(Sender: TObject);
begin
  m_strFinger1Register := '';
  m_strFinger2Register := '';
  m_PictureStream := TMemoryStream.Create;

  m_Trainman.nTrainmanState := tsNil;
  InitZKFPEng();
  if WebcamExists() = False then
  begin
    btnCapturePicture.Enabled := False;
    imgwebcamError.Visible := True;
    labwebcamError.Visible := True;
  end;
  m_DBTrainman := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
  {
  //车间数据库操作
  m_DBWorkShop := TRsDBWorkShop.Create(GlobalDM.ADOConnection);
  //行车区段数据库操作
  m_DBTrainJiaolu := TRsDBTrainJiaolu.Create(GlobalDM.ADOConnection);
  //指导组数据库操作
  m_DBGuideGroup := TRsDBGuideGroup.Create(GlobalDM.ADOConnection);
  }
end;

procedure TfrmUserInfoEdit.FormDestroy(Sender: TObject);
begin
  m_DBTrainman.Free;
  m_PictureStream.Free;
  {
  //车间数据库操作
  m_DBWorkShop.Free;
  //行车区段数据库操作
  m_DBTrainJiaolu.Free;
  //指导组数据库操作
  m_DBGuideGroup.Free;
  }
end;

procedure TfrmUserInfoEdit.FormShow(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmUserInfoEdit.GatherData(var trainman: RRsTrainman);
var
  pictureStream : TMemoryStream;
begin

  trainman.strTrainmanNumber := Trim(edtNumber.Text);
  trainman.strTrainmanName := edtName.Text;
  trainman.nPostID := TRsPost(StrToInt(comboPost.Values[comboPost.ItemIndex]));
  trainman.strWorkShopGUID := '' ;
  trainman.strTrainJiaoluGUID := '' ;
  trainman.strGuideGroupGUID := '';
  trainman.nDriverType := TRsDriverType(StrToInt(comboDriverType.Values[comboDriverType.ItemIndex]));
  trainman.nDriverLevel := StrToInt(comboDriveLevel.Values[comboDriveLevel.ItemIndex]);
  trainman.bIsKey := StrToInt(comboIsKey.Values[comboIsKey.ItemIndex]);

  if comboABCD.ItemIndex > -1 then  
    trainman.strABCD :=  comboABCD.Values[comboABCD.ItemIndex];

  if comboKehuo.ItemIndex > -1 then
    trainman.nKeHuoID := TRsKehuo(StrToInt(comboKehuo.Values[comboKehuo.ItemIndex]));

  trainman.strTelNumber  := edtTelNumber.Text;
  trainman.strMobileNumber :=  edtMobileNumber.Text;
  trainman.dtRuZhiTime:= DateOf(dtpRuduanDate.DateTime);
  trainman.dtJiuZhiTime := DateOf(dtpRenzhiDate.DateTime);

  trainman.strAdddress := Trim(edtAddress.Text);
  trainman.strRemark := Trim(edtRemark.Text);
  trainman.strJP := GlobalDM.GetHzPy(Trim(edtName.Text));
  if GlobalDM.FingerprintInitSuccess then
  begin
    //指纹
    trainman.FingerPrint1 := GlobalDM.ZKFPEngX.DecodeTemplate1(m_strFinger1Register);
    trainman.FingerPrint2 := GlobalDM.ZKFPEngX.DecodeTemplate1(m_strFinger2Register);
  end;

  if not (imgPicture.Picture.Graphic = nil) then
  begin
    //照片
    PictureStream := TMemoryStream.Create;
    try
      TJpegImage(imgPicture.Picture.Graphic).SaveToStream(PictureStream);
      trainman.Picture := StreamToTemplateOleVariant(PictureStream);
    finally
      PictureStream.Free;
    end;
  end;
end;

procedure TfrmUserInfoEdit.InitOrgCtrls;
var
  i : integer;
  workshopArray : TRsWorkShopArray;
begin
  Exit ;
  //m_DBWorkShop.GetWorkShopOfArea(GlobalDM.SiteInfo.strAreaGUID,workshopArray);
  comboWorkShop.Items.Clear;
  comboWorkShop.Values.Clear;
  comboWorkShop.AddItemValue('请选择车间','');
  for i := 0 to length(workshopArray) - 1 do
  begin
    comboWorkShop.AddItemValue(workshopArray[i].strWorkShopName,workshopArray[i].strWorkShopGUID);
  end;
  comboWorkShop.ItemIndex := 0;

  comboTrainJiaolu.Items.Clear;
  comboTrainJiaolu.Values.Clear;
  comboTrainJiaolu.AddItemValue('请选择区段','');
  comboTrainJiaolu.ItemIndex := 0;

  comboGuideGroup.Items.Clear;
  comboGuideGroup.Values.Clear;
  comboGuideGroup.AddItemValue('请选择指导队','');
  comboGuideGroup.ItemIndex := 0;
end;

procedure TfrmUserInfoEdit.InitZKFPEng;
{功能:初始化指纹仪}
begin
  if GlobalDM.FingerprintInitSuccess = False then
  begin
    btnFingerRegister.Enabled := False;
    image1.Visible := True;
    labError.Visible := True;
    labError.Caption := '指纹仪无法使用,'+GlobalDM.FingerprintInitFailureReason;
    Exit;
  end;
end;

class function TfrmUserInfoEdit.ModifyTrainmanInfo(
  strGUID: String): Boolean;
//功能:修改乘务员信息
var
  frmUserInfoEdit: TfrmUserInfoEdit;
begin
  frmUserInfoEdit:= TfrmUserInfoEdit.Create(nil);
  Result := False;
  try
    frmUserInfoEdit.Caption := '修改司机信息';
    frmUserInfoEdit.m_EditType := otModify;    
    frmUserInfoEdit.InitOrgCtrls;
    frmUserInfoEdit.ReadData(strGUID);
    if frmUserInfoEdit.ShowModal = mrok then
      Result := True;
  finally
    frmUserInfoEdit.Free;
  end;
end;

procedure TfrmUserInfoEdit.ReadData(strGUID: String);
//功能:读取乘务员信息
var
  PictureStream : TMemoryStream;
  JpegImage : TJPEGImage;
begin  
  m_strGUID := strGUID;
  if not m_DBTrainman.GetTrainman(m_strGUID,m_Trainman) then
  begin
    Box('没有找到指定的司机信息');
    exit;
  end;

  edtNumber.Text := m_Trainman.strTrainmanNumber;
  edtName.Text := m_Trainman.strTrainmanName;
  ComboPost.ItemIndex := comboPost.Values.IndexOf(IntToStr(Ord(m_Trainman.nPostID)));

  {
  comboWorkShop.ItemIndex := comboWorkShop.Values.IndexOf(m_Trainman.strWorkShopGUID);
  comboWorkShop.OnChange(Self);
  comboTrainJiaolu.ItemIndex := comboTrainJiaolu.Values.IndexOf(m_Trainman.strTrainJiaoluGUID);

  if comboTrainJiaolu.ItemIndex = -1 then
    comboTrainJiaolu.ItemIndex := 0;


  comboGuideGroup.ItemIndex := comboGuideGroup.Values.IndexOf(m_Trainman.strGuideGroupGUID);
  }
  comboDriverType.ItemIndex := comboDriverType.Values.IndexOf(IntToStr(Ord(m_Trainman.nPostID)));
  comboDriveLevel.ItemIndex := comboDriveLevel.Values.IndexOf(IntToStr(Ord(m_Trainman.nDriverLevel)));
  comboIsKey.ItemIndex := comboIsKey.Values.IndexOf(IntToStr(Ord(m_Trainman.bIsKey)));
  comboABCD.ItemIndex := comboABCD.Values.IndexOf(m_Trainman.strABCD);

  comboKehuo.ItemIndex := comboKehuo.Values.IndexOf(IntToStr(Ord(m_Trainman.nKeHuoID)));
  edtTelNumber.Text := m_Trainman.strTelNumber;
  edtMobileNumber.Text := m_Trainman.strMobileNumber;
  dtpRuduanDate.DateTime := m_Trainman.dtRuZhiTime;
  dtpRenzhiDate.DateTime := m_Trainman.dtJiuZhiTime;
  edtRestLength.Text := '0小时';
  edtLastEndWorkTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',m_Trainman.dtLastEndworkTime);
  edtAddress.Text := m_Trainman.strAdddress;
  edtRemark.Text := m_Trainman.strRemark;

  if GlobalDM.FingerprintInitSuccess then
  begin
    //指纹
    if not (VarIsNull(m_Trainman.FingerPrint1) or VarIsEmpty(m_Trainman.FingerPrint1)) then
      m_strFinger1Register := GlobalDM.ZKFPEngX.EncodeTemplate1(m_Trainman.FingerPrint1);
    if not (VarIsNull(m_Trainman.FingerPrint2) or VarIsEmpty(m_Trainman.FingerPrint2)) then
      m_strFinger2Register := GlobalDM.ZKFPEngX.EncodeTemplate1(m_Trainman.FingerPrint2);
  end;
  //照片
  if not (VarIsNull(m_Trainman.Picture) or VarIsEmpty(m_Trainman.Picture)) then
  begin
    PictureStream := TMemoryStream.Create;
    TemplateOleVariantToStream(m_Trainman.Picture,PictureStream);
    JpegImage := TJpegImage.Create;
    PictureStream.Position := 0;
    JpegImage.LoadFromStream(PictureStream);
    imgPicture.Picture.Graphic := JpegImage;
    JpegImage.Free;
    PictureStream.Free;
    if imgPicture.Picture.Width = 0 then
      imgPicture.Picture.Graphic := nil;
  end;
end;

procedure TfrmUserInfoEdit.WMDevicechange(var Msg: TMessage);
begin
  if (Msg.LParam = 0) and (Msg.WParam = 7) then
  begin
    if GlobalDM.FingerprintInitSuccess = False then
    begin
      if btnFingerRegister.Enabled = False then
      begin
        if GlobalDM.InitFingerPrintting then
        begin
          image1.Visible := False;
          labError.Visible := False;
          btnFingerRegister.Enabled := True;
        end;
      end;
    end;

    if btnCapturePicture.Enabled = False then
    begin
      if WebcamExists() then
      begin
        btnCapturePicture.Enabled := True;
        imgwebcamError.Visible := False;
        labwebcamError.Visible := False;
      end;
    end;
  end;
end;

end.
