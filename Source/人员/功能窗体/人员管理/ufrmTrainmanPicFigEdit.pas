unit ufrmTrainmanPicFigEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Mask, RzEdit, ExtCtrls, pngimage, RzPanel,
  Buttons, PngSpeedButton,ufrmFingerRegister, OleCtrls, ZKFPEngXControl_TLB,
   DSUtil, DirectShow9, ufrmgather, JPEG, uTFSystem, ZKFPEngXUtils, ufrmTextInput;

type
  TFrmTrainmanPicFigEdit = class(TForm)
    Bevel1: TBevel;
    btnFingerRegister: TPngSpeedButton;
    Bevel2: TBevel;
    image1: TImage;
    labError: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    btnClearFinger: TPngSpeedButton;
    RzGroupBox2: TRzGroupBox;
    btnCapturePicture: TPngSpeedButton;
    btnLoadPicture: TPngSpeedButton;
    labwebcamError: TLabel;
    imgwebcamerr: TImage;
    imgPicture: TImage;
    imgTrainmanPicture1: TPaintBox;
    btnSave: TButton;
    btnClose: TButton;
    edtNumber: TRzEdit;
    edtName: TRzEdit;
    ADOQuery: TADOQuery;
    OD: TOpenDialog;
    procedure btnLoadPictureClick(Sender: TObject);
    procedure btnCapturePictureClick(Sender: TObject);
    procedure btnFingerRegisterClick(Sender: TObject);
    procedure btnClearFingerClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
      private
    {当前操作人员ID}
    m_strGUID: string;

    //指纹特征1
    m_strFinger1Register: string;
    //指纹特征2
    m_strFinger2Register: string;
    //照片
    m_PictureStream: TMemoryStream;
    m_bChange: Boolean;
    m_OldTouchingEvent: TNotifyEvent;
    m_OldFingerLoginSuccess: TOnEventByString;
  public
  public
    procedure ReadData(strGUID: string);
  private
    procedure Modify;
    procedure FormDataToADOQuery;
    procedure InitZKFPEng;
    procedure WMDevicechange(var Msg: TMessage); message WM_DEVICECHANGE;
  end;


  function ModifyTrainmanPicFigAccess(strGUID: string): Boolean;

var
  FrmTrainmanPicFigEdit: TFrmTrainmanPicFigEdit;

implementation

uses
  uGlobalDM,ufrmQuestionBox ;

{$R *.dfm}

function ModifyTrainmanPicFigAccess(strGUID: string): Boolean;
//功能:修改乘务员信息
var
  frmUserInfoEdit: TFrmTrainmanPicFigEdit;
begin
  frmUserInfoEdit := TFrmTrainmanPicFigEdit.Create(nil);
  Result := False;
  try
    frmUserInfoEdit.Caption := '修改乘务员信息';
    frmUserInfoEdit.ReadData(strGUID);
    if frmUserInfoEdit.ShowModal = mrok then
      Result := True;
  finally
    frmUserInfoEdit.Free;
  end;

end;


procedure TFrmTrainmanPicFigEdit.btnCapturePictureClick(Sender: TObject);
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

procedure TFrmTrainmanPicFigEdit.btnClearFingerClick(Sender: TObject);
begin
  if not tfMessageBox('您确定要清除该乘务员的指纹信息吗?') then
    Exit;
  ADOQuery.Close;
  ADOQuery.SQL.Text := 'update TAB_Org_Trainman set Fingerprint1=null,Fingerprint2=null ' +
    ' Where strTrainmanGUID = ' + QuotedStr(m_strGUID);
  try
    ADOQuery.ExecSQL;
    Box('成功清除指纹信息!');
    m_bChange := true;
    ModalResult := mrOk;
  except
    on E: Exception do
    begin
      BoxErr('清除指纹信息失败！错误:(' + E.Message + ')');
    end;
  end;
end;

procedure TFrmTrainmanPicFigEdit.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTrainmanPicFigEdit.btnFingerRegisterClick(Sender: TObject);
begin
  if FingerRegister(m_strFinger1Register, m_strFinger2Register, GlobalDM.ZKFPEngX) then
    m_bChange := True;
end;

procedure TFrmTrainmanPicFigEdit.btnLoadPictureClick(Sender: TObject);
begin
  if OD.Execute = False then Exit;
  ImgPicture.Picture.LoadFromFile(OD.FileName);
  m_PictureStream.LoadFromFile(OD.FileName);
end;

procedure TFrmTrainmanPicFigEdit.btnSaveClick(Sender: TObject);
begin
  if m_bChange then
  begin
     Modify();
  end else begin
    ModalResult := mrCancel;
  end;
end;

procedure TFrmTrainmanPicFigEdit.FormCreate(Sender: TObject);
begin
  m_strFinger1Register := '';
  m_strFinger2Register := '';
  m_OldTouchingEvent := GlobalDM.OnFingerTouching;
  m_OldFingerLoginSuccess := GlobalDM.OnFingerLoginSuccess;
  GlobalDM.OnFingerTouching := nil;
  GlobalDM.OnFingerLoginSuccess := nil;
  m_PictureStream := TMemoryStream.Create;
  InitZKFPEng();
  if WebcamExists() = False then
  begin
    btnCapturePicture.Enabled := False;
    imgwebcamerr.Visible := True;
    labwebcamError.Visible := True;
  end;
end;

procedure TFrmTrainmanPicFigEdit.FormDataToADOQuery;
//功能:将界面中的数据保存至数据集中
var
  Template: OleVariant;
  TemplateStream: TMemoryStream;
begin
  if GlobalDM.FingerprintInitSuccess then
  begin
    if m_strFinger1Register <> '' then
    begin
      Template := GlobalDM.ZKFPEngX.DecodeTemplate1(m_strFinger1Register);
      TemplateStream := TMemoryStream.Create;
      TemplateOleVariantToStream(Template, TemplateStream);
      (ADOQuery.FieldByName('Fingerprint1') as TBlobField).LoadFromStream(TemplateStream);
      TemplateStream.Free;
    end;
    if m_strFinger2Register <> '' then
    begin
      Template := GlobalDM.ZKFPEngX.DecodeTemplate1(m_strFinger2Register);
      TemplateStream := TMemoryStream.Create;
      TemplateOleVariantToStream(Template, TemplateStream);
      (ADOQuery.FieldByName('Fingerprint2') as TBlobField).LoadFromStream(TemplateStream);
      TemplateStream.Free;
    end;
  end;
  if m_PictureStream.Size > 0 then
  begin
    m_PictureStream.Position := 0;
    (ADOQuery.FieldByName('Picture') as TBlobField).LoadFromStream(m_PictureStream);
  end;
end;

procedure TFrmTrainmanPicFigEdit.FormDestroy(Sender: TObject);
begin
  m_PictureStream.Free;
  GlobalDM.OnFingerTouching := m_OldTouchingEvent;
  GlobalDM.OnFingerLoginSuccess := m_OldFingerLoginSuccess;
end;

procedure TFrmTrainmanPicFigEdit.InitZKFPEng;
{功能:初始化指纹仪}
begin
  if GlobalDM.FingerprintInitSuccess = False then
  begin
    image1.Visible := True;
    labError.Visible := True;
    labError.Caption := '指纹仪无法使用,' + GlobalDM.FingerprintInitFailureReason;
    btnFingerRegister.Enabled := false;
    Exit;
  end
  else
  begin
    image1.Visible := False;
    labError.Visible := False;
    btnFingerRegister.Enabled := true;
  end;
end;

procedure TFrmTrainmanPicFigEdit.Modify;
//功能:修改乘务员照片，指纹信息
var
  nID: Integer;
begin
  if tfMessageBox('确定要修改该乘务员信息吗?') = False then Exit;
  ADOQuery.SQL.Text := 'Select * from TAB_Org_Trainman ' +
    ' Where strTrainmanGUID = ' + QuotedStr(m_strGUID);
  ADOQuery.Open;
  if ADOQuery.RecordCount > 0 then
  begin
    nID := ADOQuery.FindField('nID').AsInteger;
    ADOQuery.Edit;

    try
      FormDataToADOQuery();
      ADOQuery.Post;
      //更新本地指纹特征库
      if GlobalDM.FingerprintInitSuccess then
      begin
        GlobalDM.UpdateFingerTemplateByID(nID,
          GlobalDM.ZKFPEngX.DecodeTemplate1(m_strFinger1Register),
          GlobalDM.ZKFPEngX.DecodeTemplate1(m_strFinger2Register));
      end;
    except
      on E: Exception do
      begin
        BoxErr('信息保存失败！错误:(' + E.Message + ')');
        Exit;
      end;
    end;
  end;
  ModalResult := mrok;
end;

procedure TFrmTrainmanPicFigEdit.ReadData(strGUID: string);
//功能:读取乘务员信息
var
  TemplateStream: TMemoryStream;
  PictureStream: TMemoryStream;
  JpegImage: TJPEGImage;
  Template: OleVariant;
begin
  ADOQuery.Connection := GlobalDM.LocalADOConnection;
  ADOQuery.ParamCheck := False ;
  m_strGUID := strGUID;
  ADOQuery.SQL.Text := 'Select * from tab_Org_Trainman ' +
    ' Where strTrainmanGUID = ' + QuotedStr(strGUID);
  ADOQuery.Open;
  try
    if ADOQuery.RecordCount > 0 then
    begin
      edtNumber.Text := Trim(ADOQuery.FieldByName('strTrainmanNumber').AsString);
      if Length(Trim(ADOQuery.FieldByName('strTrainmanName').AsString)) = 0 then
        edtName.Text := '-'
      else
        edtName.Text := Trim(ADOQuery.FieldByName('strTrainmanName').AsString);

      if GlobalDM.FingerprintInitSuccess then
      begin
        if ADOQuery.FieldByName('Fingerprint1').IsNull = False then
        begin
          TemplateStream := TMemoryStream.Create;
          (ADOQuery.FieldByName('Fingerprint1') as TBlobField).SaveToStream(TemplateStream);
          Template := StreamToTemplateOleVariant(TemplateStream);
          m_strFinger1Register := GlobalDM.ZKFPEngX.EncodeTemplate1(Template);
          TemplateStream.Free;

        end;

        if ADOQuery.FieldByName('Fingerprint2').IsNull = False then
        begin
          TemplateStream := TMemoryStream.Create;
          (ADOQuery.FieldByName('Fingerprint2') as TBlobField).SaveToStream(TemplateStream);

          Template := StreamToTemplateOleVariant(TemplateStream);
          m_strFinger2Register := GlobalDM.ZKFPEngX.EncodeTemplate1(Template);
          TemplateStream.Free;
        end;

      end;

      if ADOQuery.FieldByName('Picture').IsNull = False then
      begin
        PictureStream := TMemoryStream.Create;
        JpegImage := TJpegImage.Create;
        (ADOQuery.FieldByName('Picture') as TBlobField).SaveToStream(PictureStream);
        PictureStream.Position := 0;
        JpegImage.LoadFromStream(PictureStream);
        imgPicture.Picture.Graphic := JpegImage;
        JpegImage.Free;
        PictureStream.Free;
        if imgPicture.Picture.Width = 0 then
          imgPicture.Picture.Graphic := nil;
      end;

    end;
  finally
    ADOQuery.Close;
  end;
end;

procedure TFrmTrainmanPicFigEdit.WMDevicechange(var Msg: TMessage);
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
        imgwebcamerr.Visible := False;
        labwebcamError.Visible := False;
      end;
    end;
  end;
end;

end.
