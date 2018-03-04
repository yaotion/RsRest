unit ufrmJiaoFuJieShiCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmAnimation, uTFImage, ExtCtrls, uStyleGrid, RzPanel, RzTabs,
  OleCtrls, SHDocVw, Buttons, PngCustomButton,ADODB, uTFUtils,
  uTrainmanIntf,PngFunctions, pngimage, StdCtrls, uDevChangeNotify,
  ComObj,uDBSection,uSection,Printers,uBjJFJieShi, brisdklib,
  uTFSystem,jpeg, ActnList,StrUtils, uQNVControl,
  uTFBackgroundPanel, uHotKeys, PngImageList;
  
const
  TEMP_PATH = '交付揭示\';
  WORDREADINGHTML = '<html>' +
    '<head></head>' +
    '<body>' +
    '<center>' +
    '<img id="imgpic" width="70%%" src="%s"></img>' +
    '</center>' +
    '</body>' + 
    '</html>';
type
  TfrmGYKJiaoFuJieShi = class(TfrmAnimation)
    imgBackground: TTFImage;
    pnlTitle: TPanel;
    StepPages: TRzPageControl;
    tabJSContent: TRzTabSheet;
    RzPanel1: TRzPanel;
    pnlJieShiBackground: TRzPanel;
    WebBrowser: TWebBrowser;
    pnlJsButtons: TRzPanel;
    btnExit: TPngCustomButton;
    btnUpPreview: TPngCustomButton;
    btnDownPreView: TPngCustomButton;
    btnPreJs: TPngCustomButton;
    btnNextJS: TPngCustomButton;
    tabSections: TRzTabSheet;
    RzPanel5: TRzPanel;
    RzPanel6: TRzPanel;
    SectionGrid: TStyleGrid;
    pnlButton: TRzPanel;
    btnPreSectionPage: TPngCustomButton;
    btnNextSectionPage: TPngCustomButton;
    btnSelectSection: TPngCustomButton;
    ActionList1: TActionList;
    actEsc: TAction;
    actEnd: TAction;
    actEnter: TAction;
    actLeft: TAction;
    actRight: TAction;
    pnlKeyboardOprHint: TTFBackgroundPanel;
    TFImage1: TTFImage;
    act9: TAction;
    act8: TAction;
    tabFileList: TRzTabSheet;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    gridFileList: TStyleGrid;
    RzPanel4: TRzPanel;
    btnPrevFileListPage: TPngCustomButton;
    btnNextFileListPage: TPngCustomButton;
    btnDisplayJsContent: TPngCustomButton;
    labFileName: TLabel;
    Label1: TLabel;
    PngCustomButton2: TPngCustomButton;
    PngCustomButton1: TPngCustomButton;
    Label2: TLabel;
    RzPanel7: TRzPanel;
    lblSoundRecording: TLabel;
    RecordingPngImages: TPngImageCollection;
    TFImage2: TTFImage;
    RecordingTimer: TTimer;
    lblRecordingBoxState: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnUpPreviewClick(Sender: TObject);
    procedure btnDownPreViewClick(Sender: TObject);
    procedure btnNextJSClick(Sender: TObject);
    procedure btnPreJsClick(Sender: TObject);
    procedure btnSelectSectionClick(Sender: TObject);
    procedure btnNextSectionPageClick(Sender: TObject);
    procedure btnPreSectionPageClick(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure actLeftExecute(Sender: TObject);
    procedure actRightExecute(Sender: TObject);
    procedure actEnterExecute(Sender: TObject);
    procedure act8Execute(Sender: TObject);
    procedure RzPanel6Resize(Sender: TObject);
    procedure gridFileListDblItemClick(Sender: TStyleGrid; nItemIndex, x,
      y: Integer);
    procedure btnPrevFileListPageClick(Sender: TObject);
    procedure btnNextFileListPageClick(Sender: TObject);
    procedure StepPagesPageChange(Sender: TObject);
    procedure RzPanel3Resize(Sender: TObject);
    procedure SectionGridDblItemClick(Sender: TStyleGrid; nItemIndex, x,
      y: Integer);
    procedure btnDisplayJsContentClick(Sender: TObject);
    procedure RecordingTimerTimer(Sender: TObject);
  private
    { Private declarations }
    {当前登记的乘务员信息}
    m_TrainManList:ITrainManList;
    {区段数据库操作对象}
    m_DBSection: TDBSection;
    {区段列表}
    m_Sectionlist: TSectionList;
    m_JieShiList: TBjJFJieShiList;
    m_CurrentShowJS: TBjJFJieShi;
    {原来用Hook的方法，在载入pdf文件时会造成重复接收按键消息。
     现在改为注册热键的方法可以解决问题. -add by LiMingLie 2014.9.9}
    procedure RegHotKeys();
    procedure UnregHotKeys();
    procedure OnHotKey(var msg: TWMHotKey); message WM_HOTKEY;
    procedure OnWM_ACTIVATE(var  msg: TMessage); message WM_ACTIVATE;
    procedure ShowJieShi(JFJieShi: TBjJFJieShi);
    procedure WriteStringToFile(FileName,Value: string);
  private
    {电话录音计时}
    m_dtRecordingStart: TDateTime;
    {电话录音收集类}
    m_QNVControl : TQNVControl;
    {电话录音结果}
    m_SoundRecdInfo: RChannelInfo;
    {功能:开始呼叫}
    procedure OnCallBeginNotify(const ChannelInfo : RChannelInfo;var bRecording:Boolean);
    {功能:呼叫结束,添加语音通话记录}
    procedure OnCallEndNotify(const ChannelInfo : RChannelInfo);
    {更新录音盒状态显示}
    procedure DoUpdateRecordingState();
    {功能:保存录音信息}
    procedure SaveRecordInfo();
  private
    {功能：USB设备监控对象}
    m_UsbDevMonitor: TDevChangeMonitor;
    {功能：USB设备插入事件}
    procedure OnUsbInserted(Sender: TObject);
    {功能：USB设备拔出事件}
    procedure OnUsbDeleted(Sender: TObject);
  public
    { Public declarations }
    {功能:加载揭示列表}
    procedure LoadJieShiList(strSectionID: string);
    procedure LoadSections();
    class procedure ShowForm(TrainManList:ITrainManList);
    property TrainManList:ITrainManList read m_TrainManList write m_TrainManList;

  end;

implementation

{$R *.dfm}

uses uGlobalDM, uFilePrintCtrl, uSystemConfig;


{ TfrmGYKJiaoFuJieShi }

procedure TfrmGYKJiaoFuJieShi.btnExitClick(Sender: TObject);
begin
  //防止重入。
  if not btnExit.Enabled then exit;
  btnExit.Enabled := False;
  try
    Close;
  finally
    btnExit.Enabled := True;
  end;
end;

procedure TfrmGYKJiaoFuJieShi.btnPreJsClick(Sender: TObject);
var
  nIndex: Integer;
begin
  if m_CurrentShowJS = nil then
    Exit;

  nIndex := m_JieShiList.IndexOf(m_CurrentShowJS);
  if nIndex <= 0 then
  begin
    MessageBox('已是第一条揭示!');
    Exit;
  end
  else
  begin
    ShowJieShi(m_JieShiList.Items[nIndex-1]);
  end;
end;

procedure TfrmGYKJiaoFuJieShi.btnPreSectionPageClick(Sender: TObject);
begin
  SectionGrid.PrevPage;
end;

procedure TfrmGYKJiaoFuJieShi.FormCreate(Sender: TObject);
begin
  inherited;
  imgBackground.Align := alNone;
  imgBackGround.Width := Screen.Width -4;
  imgBackGround.Height := Screen.Height - 110;

  Width := imgBackGround.Width;
  Height := imgBackGround.Height;

  Left := 2;
  Top := 65;

  imgBackGround.Left := 0;
  imgBackGround.Top := 0;
  Animation := False;
  m_JieShiList := TBjJFJieShiList.Create();
  m_DBSection := TDBSection.Create(GlobalDM.ADOConnection);
  m_Sectionlist := TSectionList.Create;
  RzPanel3.DoubleBuffered := True;
  RzPanel6.DoubleBuffered := True;
  pnlJieShiBackground.DoubleBuffered := True;
  StepPages.ActivePageIndex := 0;

  //初始化电话录音功能。
  RzPanel7.DoubleBuffered := True;
  m_QNVControl := TQNVControl.Create;
  m_QNVControl.OnCallBeginNotify := self.OnCallBeginNotify;
  m_QNVControl.OnCallEndNotify := self.OnCallEndNotify;
  m_QNVControl.FileOutputPath := ExtractFilePath(ParamStr(0))+'tmpFile\';
  m_QNVControl.Open;
  DoUpdateRecordingState();

  //初始化电话录音设备监控功能。
  m_UsbDevMonitor:= TDevChangeMonitor.Create(nil);
  m_UsbDevMonitor.OnDevInserted := self.OnUsbInserted;
  m_UsbDevMonitor.OnDevDeleted := self.OnUsbDeleted;
  m_UsbDevMonitor.Open(CLSID_USB_DEV);
  
  RecordingTimer.Enabled := False;
end;


procedure TfrmGYKJiaoFuJieShi.FormDestroy(Sender: TObject);
begin
  self.UnregHotKeys();
  m_JieShiList.Free;
  m_DBSection.Free;
  m_Sectionlist.Free;
  m_QNVControl.Free;
  if m_UsbDevMonitor<>nil then
  begin
    m_UsbDevMonitor.Free;
  end;
  inherited;
end;

procedure TfrmGYKJiaoFuJieShi.FormShow(Sender: TObject);
begin
  inherited;
  if not DirectoryExists(G_strSysPath + TEMP_PATH) then
  begin
    ForceDirectories(G_strSysPath + TEMP_PATH);
  end;

  LoadSections();

end;

procedure TfrmGYKJiaoFuJieShi.gridFileListDblItemClick(Sender: TStyleGrid;
  nItemIndex, x, y: Integer);
begin
  ShowJieShi(m_JieShiList.Items[nItemIndex]);
end;

procedure TfrmGYKJiaoFuJieShi.LoadJieShiList(strSectionID: string);
var
  Item: TSGContentItem;
  I: Integer;
begin
  gridFileList.Items.Clear;
  m_JieShiList.Clear;
  TDBBjJFJieShi.GetSectionJsList(GlobalDM.ADOConnection,strSectionID,m_JieShiList);
  for I := 0 to m_JieShiList.Count - 1 do
  begin
    Item := gridFileList.Items.Add;
    Item.SubItems.Add(IntToStr(i + 1));
    Item.SubItems.Add(m_JieShiList.Items[i].Description);
    Item.SubItems.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss'
      ,m_JieShiList.Items[i].CreateTime));
    Item.Data := m_JieShiList.Items[i];

  end;

  if gridFileList.Items.Count > 0 then
    gridFileList.FocusIndex := 0;
end;

procedure TfrmGYKJiaoFuJieShi.LoadSections;
{呼和浩特：工区就是区段}
var
  i: Integer;
  Item: TSGContentItem;
begin
  m_DBSection.GetSectionsBySiteID(m_Sectionlist,SystemConfig.Config.SiteID);
  SectionGrid.Items.Clear;
  for I := 0 to m_Sectionlist.Count - 1 do
  begin
    Item := SectionGrid.Items.Add;
    Item.Data := m_Sectionlist.Items[i];
    Item.SubItems.Add(IntToStr(i + 1));
    Item.SubItems.Add(m_Sectionlist.Items[i].strSectionName);
    Item.SubItems.Add(IntToStr(TDBBjJFJieShi.GetSectionJsCount(
      GlobalDM.ADOConnection,m_Sectionlist.Items[i].strSectionGUID)));
  end;
end;

procedure TfrmGYKJiaoFuJieShi.OnCallBeginNotify(const ChannelInfo: RChannelInfo;
  var bRecording: Boolean);
begin
  m_SoundRecdInfo := ChannelInfo;
  self.m_dtRecordingStart := now();
  lblRecordingBoxState.Caption := '录音开始...';
  self.lblSoundRecording.Caption := '00:00';
  RecordingTimer.Enabled := True;
end;

procedure TfrmGYKJiaoFuJieShi.OnCallEndNotify(const ChannelInfo: RChannelInfo);
{功能:通话录音结束,添加语音通话记录}
begin
  m_SoundRecdInfo := ChannelInfo;
  self.RecordingTimer.Enabled := False;
  lblRecordingBoxState.Caption := '录音完毕...';

  MessageBox(Format('录音完毕:%s', [m_SoundRecdInfo.strCurrRecordingFileName]));
end;

procedure TfrmGYKJiaoFuJieShi.OnHotKey(var msg: TWMHotKey);
begin
  case msg.HotKey of
    HOTKEY_LEFT:
    begin
      ActLeftExecute(nil);
    end;
    HOTKEY_RIGHT:
    begin
      ActRightExecute(nil);
    end;
    HOTKEY_RETURE:
    begin
      ActEnterExecute(nil);
    end;
    HOTKEY_END:
    begin
      actEnterExecute(nil);
    end;
    HOTKEY_ESCAPE:
    begin
      actEscExecute(nil);
    end;
    HOTKEY_NUM8:
    begin
      act8Execute(nil);
    end;
    HOTKEY_NUM9:
    begin

    end;
  end;
end;


procedure TfrmGYKJiaoFuJieShi.OnUsbDeleted(Sender: TObject);
begin
  if (m_QNVControl<>nil) and (m_QNVControl.Active) then
  begin
    self.m_QNVControl.Close;
    self.DoUpdateRecordingState();
  end;
end;

procedure TfrmGYKJiaoFuJieShi.OnUsbInserted(Sender: TObject);
begin
  if (m_QNVControl<>nil) then
  begin
    self.m_QNVControl.Open;
    self.DoUpdateRecordingState();
  end;
end;

procedure TfrmGYKJiaoFuJieShi.OnWM_ACTIVATE(var msg: TMessage);
begin
  inherited;

  case msg.WParamLo of
    WA_INACTIVE:
    begin
      self.UnregHotKeys();
    end;
    else
    begin
      self.RegHotKeys();
    end;
  end;
end;

procedure TfrmGYKJiaoFuJieShi.btnNextJSClick(Sender: TObject);
var
  nIndex: Integer;
begin
  if m_CurrentShowJS = nil then
    Exit;

  nIndex := m_JieShiList.IndexOf(m_CurrentShowJS);
  if nIndex >= m_JieShiList.Count - 1 then
  begin
    MessageBox('已是最后一条揭示!');
    Exit;
  end
  else
  begin
    ShowJieShi(m_JieShiList.Items[nIndex+1]);
  end;
end;


procedure TfrmGYKJiaoFuJieShi.btnNextSectionPageClick(Sender: TObject);
begin
  SectionGrid.NextPage;
end;

procedure TfrmGYKJiaoFuJieShi.btnPrevFileListPageClick(Sender: TObject);
begin
  gridFileList.PrevPage;
end;

procedure TfrmGYKJiaoFuJieShi.btnNextFileListPageClick(Sender: TObject);
begin
  gridFileList.NextPage;
end;

procedure TfrmGYKJiaoFuJieShi.RecordingTimerTimer(Sender: TObject);
begin
  if TFImage2.ImageIndex=0 then
  begin
    TFImage2.ImageIndex := 1;
  end
  else
  begin
    TFImage2.ImageIndex := 0;
  end;
  TFImage2.Invalidate;
  self.lblSoundRecording.Caption := FormatDateTime('nn:ss', Now()-self.m_dtRecordingStart);
end;

procedure TfrmGYKJiaoFuJieShi.RegHotKeys;
begin
  Windows.RegisterHotKey(handle, HOTKEY_LEFT, 0, VK_LEFT);
  Windows.RegisterHotKey(handle, HOTKEY_RIGHT, 0, VK_RIGHT);
  Windows.RegisterHotKey(handle, HOTKEY_RETURE, 0, VK_RETURN);
  Windows.RegisterHotKey(handle, HOTKEY_END, 0, VK_END);
  Windows.RegisterHotKey(handle, HOTKEY_ESCAPE, 0, VK_ESCAPE);

  Windows.RegisterHotKey(handle, HOTKEY_NUM8, 0, ORD('8'));
  Windows.RegisterHotKey(handle, HOTKEY_NUM9, 0, ORD('9'));
end;

procedure TfrmGYKJiaoFuJieShi.StepPagesPageChange(Sender: TObject);
begin
  labFileName.Visible := tabJSContent.Visible;
end;

procedure TfrmGYKJiaoFuJieShi.RzPanel3Resize(Sender: TObject);
{自动设置表格第1列的大小}
var
  I,w: Integer;
begin
  w := 0;
  for I := 0 to gridFileList.Columns.Count - 1 do
  begin
    if I<>1 then
    begin
      w := w + gridFileList.Columns[I].Width;
    end;
  end;
  gridFileList.Columns[1].Width := gridFileList.Width-w;
end;

procedure TfrmGYKJiaoFuJieShi.RzPanel6Resize(Sender: TObject);
{自动设置表格第1列的大小}
var
  I,w: Integer;
begin
  w := 0;
  for I := 0 to SectionGrid.Columns.Count - 1 do
  begin
    if I<>1 then
    begin
      w := w + SectionGrid.Columns[I].Width;
    end;
  end;
  SectionGrid.Columns[1].Width := SectionGrid.Width-w;
end;

procedure TfrmGYKJiaoFuJieShi.btnSelectSectionClick(Sender: TObject);
begin
  if SectionGrid.Items.Count = 0 then
    Exit;

  StepPages.ActivePage := tabFileList;
  LoadJieShiList(TSection(SectionGrid.Items.Items[SectionGrid.FocusIndex].Data).strSectionGUID);
end;


procedure TfrmGYKJiaoFuJieShi.btnUpPreviewClick(Sender: TObject);
var
  pt,OldPt: TPoint;
begin
  GetCursorPos(OldPt);
  pt.X := (WebBrowser.Width div 2);
  pt.Y := (WebBrowser.Height div 2);
  pt := WebBrowser.ClientToScreen(pt);
  SetCursorPos(pt.x,pt.y);

  mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
  mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);

  keybd_event(VK_PRIOR,0,0,0);
  keybd_event(VK_PRIOR,0,KEYEVENTF_KEYUP,0);

  SetCursorPos(OldPt.x,OldPt.y);
end;


procedure TfrmGYKJiaoFuJieShi.DoUpdateRecordingState;
begin
  if m_QNVControl.Active then
  begin
    lblRecordingBoxState.Caption := '已连接';
  end
  else
  begin
    lblRecordingBoxState.Caption := '未连接';

    MessageBox('电话录音设备未连接，通话录音功能将无法使用。');
  end;
end;

procedure TfrmGYKJiaoFuJieShi.act8Execute(Sender: TObject);
begin
  StepPages.ActivePage := tabSections;
end;

procedure TfrmGYKJiaoFuJieShi.actEnterExecute(Sender: TObject);
begin
  if StepPages.ActivePage = tabSections then
  begin
    btnSelectSection.Click();
  end
  else
  if StepPages.ActivePage = tabFileList then
  begin
    btnDisplayJsContent.Click();
  end
  else
  if StepPages.ActivePage = tabJSContent then
  begin
    btnNextJS.Click();
  end;
end;

procedure TfrmGYKJiaoFuJieShi.actEscExecute(Sender: TObject);
begin
  if StepPages.ActivePageIndex <= 0 then
  begin
    btnExit.Click();
  end
  else
  begin
    StepPages.ActivePageIndex := StepPages.ActivePageIndex-1;
  end;
end;

procedure TfrmGYKJiaoFuJieShi.actLeftExecute(Sender: TObject);
begin
  if StepPages.ActivePage = tabSections then
  begin
    SectionGrid.PrevFocus();
  end
  else
  if StepPages.ActivePage = tabFileList then
  begin
    gridFileList.PrevFocus();
  end
  else
  if StepPages.ActivePage = tabJSContent then
  begin
    btnUpPreview.Click();
  end;
end;

procedure TfrmGYKJiaoFuJieShi.actRightExecute(Sender: TObject);
begin
  if StepPages.ActivePage = tabSections then
  begin
    SectionGrid.NextFocus;
  end
  else
  if StepPages.ActivePage = tabFileList then
  begin
    gridFileList.NextFocus();
  end
  else
  if StepPages.ActivePage = tabJSContent then
  begin
    btnDownPreView.Click();
  end;
end;

procedure TfrmGYKJiaoFuJieShi.btnDisplayJsContentClick(Sender: TObject);
begin
  if (gridFileList.Items.Count = 0) or (gridFileList.FocusIndex < 0) then Exit;
  
  ShowJieShi(m_JieShiList.Items[gridFileList.FocusIndex]);
end;

procedure TfrmGYKJiaoFuJieShi.btnDownPreViewClick(Sender: TObject);
var
  pt,OldPt: TPoint;
begin
  GetCursorPos(OldPt);
  pt.X := (WebBrowser.Width div 2);
  pt.Y := (WebBrowser.Height div 2);
  pt := WebBrowser.ClientToScreen(pt);
  SetCursorPos(pt.x,pt.y);

  mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
  mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
  keybd_event(VK_NEXT,0,0,0);
  keybd_event(VK_NEXT,0,KEYEVENTF_KEYUP,0);

  SetCursorPos(OldPt.x,OldPt.y);
end;

procedure TfrmGYKJiaoFuJieShi.SaveRecordInfo;
var
  ADOQuery: TADOQuery;
begin
  if m_SoundRecdInfo.strCurrRecordingFileName <> '' then
  begin
    ADOQuery := TADOQuery.Create(NIL);
    try
      ADOQuery.Connection := GlobalDM.ADOConnection;
      ADOQuery.SQL.Text := 'Insert into TAB_BJ_DialRecord ' +
        '(strID,strFileName,strWorkID,nSiteID,dtRecordingBeginTime,' +
        'dtRecordingEndTime,strDestTel,nFileSize) Values(:strID,:FileName,:WorkID,:SiteID,:BeginTime, '+
        ':EndTime,:TelNumber,:FileSize)';
        
      ADOQuery.Parameters.ParamByName('strID').Value := NewGUID;
      ADOQuery.Parameters.ParamByName('FileName').Value := m_SoundRecdInfo.strCurrRecordingFileName;

      if (m_TrainManList <> nil) and (m_TrainManList.Count > 0) then
        ADOQuery.Parameters.ParamByName('WorkID').Value := m_TrainManList.Items[0].StateInfo[PROPERTIES_WORKID];
      ADOQuery.Parameters.ParamByName('SiteID').Value := SystemConfig.Config.SiteID;
      ADOQuery.Parameters.ParamByName('BeginTime').Value := m_SoundRecdInfo.dtRecordingBeginTime;
      ADOQuery.Parameters.ParamByName('EndTime').Value := m_SoundRecdInfo.dtRecordingEndTime;
      ADOQuery.Parameters.ParamByName('TelNumber').Value := m_SoundRecdInfo.strDestTel;
      ADOQuery.Parameters.ParamByName('FileSize').Value := GetFileSize(m_SoundRecdInfo.strCurrRecordingFileName);

      ADOQuery.ExecSQL;

    finally
      ADOQuery.Free;
    end;  
  end;
end;

procedure TfrmGYKJiaoFuJieShi.SectionGridDblItemClick(Sender: TStyleGrid;
  nItemIndex, x, y: Integer);
begin
  btnSelectSection.Click;
end;


class procedure TfrmGYKJiaoFuJieShi.ShowForm(TrainManList:ITrainManList);
var
  frmGYKJiaoFuJieShi: TfrmGYKJiaoFuJieShi;
begin
  frmGYKJiaoFuJieShi := TfrmGYKJiaoFuJieShi.Create(nil);
  try
    frmGYKJiaoFuJieShi.m_TrainManList := TrainManList;
    frmGYKJiaoFuJieShi.ShowModal;
    frmGYKJiaoFuJieShi.SaveRecordInfo();
  finally
    frmGYKJiaoFuJieShi.Free;
  end;
end;

procedure TfrmGYKJiaoFuJieShi.ShowJieShi(JFJieShi: TBjJFJieShi);
var
  htmlValue: string;
begin
  m_CurrentShowJS := JFJieShi; 
  StepPages.ActivePage := tabJSContent;
  labFileName.Caption := JFJieShi.FileName;
  if uppercase(ExtractFileExt(JFJieShi.FileName)) = '.JPG' then
  begin
    JFJieShi.FileContent.SaveToFile(G_strSysPath + TEMP_PATH + JFJieShi.FileName);
    htmlValue := Format(WORDREADINGHTML,[G_strSysPath + TEMP_PATH + JFJieShi.FileName]);
    WriteStringToFile(G_strSysPath + TEMP_PATH + 'JFJieShi.html',htmlValue);
    WebBrowser.Navigate(G_strSysPath + TEMP_PATH + 'JFJieShi.html');
  end
  else
  begin
    JFJieShi.FlashFileContent.SaveToFile(G_strSysPath + TEMP_PATH + JFJieShi.FlashFileName);
    WebBrowser.Navigate(G_strSysPath + TEMP_PATH + JFJieShi.FlashFileName);
  end;


end;

procedure TfrmGYKJiaoFuJieShi.UnregHotKeys;
begin
  Windows.UnRegisterHotKey(handle, HOTKEY_LEFT);
  Windows.UnRegisterHotKey(handle, HOTKEY_RIGHT);
  Windows.UnRegisterHotKey(handle, HOTKEY_RETURE);
  Windows.UnRegisterHotKey(handle, HOTKEY_END);
  Windows.UnRegisterHotKey(handle, HOTKEY_ESCAPE);

  Windows.UnRegisterHotKey(handle, HOTKEY_NUM8);
  Windows.UnRegisterHotKey(handle, HOTKEY_NUM9);
end;

procedure TfrmGYKJiaoFuJieShi.WriteStringToFile(FileName, Value: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName,fmCreate or fmOpenWrite);
  try
    FileStream.Write(pchar(Value)^,Length(Value));
  finally
    FileStream.Free;
  end;  
end;

end.
