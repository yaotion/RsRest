unit uFrmQueryCallRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvDateTimePicker, StdCtrls, ExtCtrls, RzPanel, Grids,
  AdvObj, BaseGrid, AdvGrid, Buttons, PngCustomButton,uRoomCallApp,uRoomCall,
  uSaftyEnum,uPubFun,DateUtils,uTFSystem, MPlayer, DSPack,uGlobalDM;

type
  TFrmQueryCallRecord = class(TForm)
    RzPnlTop: TRzPanel;
    lbl1: TLabel;
    edtRoom: TEdit;
    Label1: TLabel;
    edtTrainNo: TEdit;
    lbl: TLabel;
    dtpStart: TAdvDateTimePicker;
    Label2: TLabel;
    dtpEnd: TAdvDateTimePicker;
    rzpnlBody: TRzPanel;
    GridCallRecord: TAdvStringGrid;
    btnPlay: TPngCustomButton;
    btnPause: TPngCustomButton;
    btnStop: TPngCustomButton;
    mp1: TMediaPlayer;
    btnQuery: TPngCustomButton;
    dlgOpen1: TOpenDialog;
    btnExportWav: TPngCustomButton;
    Filter1: TFilter;
    FilterGraph1: TFilterGraph;
    Timer1: TTimer;
    DSTrackBar1: TDSTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExportWavClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    //公寓叫班管理
    m_RoomCallApp:TRoomCallApp;
    //叫班记录
    m_CallManList:TCallManRecordList;

  private
    {功能:填充数据行}
    procedure FillGridLine(nRow:Integer;CallRecord:TCallManRecord);
    {功能:清空列表}
    procedure ClearGird();
    {功能:填充数据}
    procedure FillGird();
    {功能:查询数据}
    procedure QueryData();
    {功能:赋值查询条件}
    procedure SetQueryParams(var params:RCallQryParams);
    {功能:获取选中记录}
    function GetSelectRecord(var callRecord:TCallManRecord):Boolean;
    {功能:获取录音文件路径}
    function GetVoiceFile(strFile:string):Boolean;
  public
    {更新数据}
    procedure ReFreashData();
    {功能:显示叫班记录查询窗体}
    class procedure ShowCallRecordFrm(parentFrm:TForm);
  end;


implementation

uses
  utfPopBox ;

{$R *.dfm}

{ TFrmQueryRoomCall }

procedure TFrmQueryCallRecord.btnExportWavClick(Sender: TObject);
var
  strWavFile:string;
  callRecord:TCallManRecord;
  callVoice:TCallVoice;
begin
  if not dlgOpen1.Execute then exit;
  strWavFile := dlgOpen1.FileName;
  if GetSelectRecord(callRecord) = False then
  begin
    TtfPopBox.ShowBox('未选取有效的记录行');
    Exit;
  end;
  callVoice := TCallVoice.Create;
  try
    try
      if m_RoomCallApp.DBCallVoice.Find(callRecord.strCallVoiceGUID, callVoice)= False then
      begin
        TtfPopBox.ShowBox('无叫班录音');
        Exit;
      end;
      callVoice.vms.SaveToFile(strWavFile);
      TtfPopBox.ShowBox('导出成功!');
    except on e:Exception do
      TtfPopBox.ShowBox(e.Message);
    end;
  finally
    callVoice.Free;
  end;
end;

procedure TFrmQueryCallRecord.btnPauseClick(Sender: TObject);
begin
  try
    FilterGraph1.Pause;
    exit ;
  except
    on e:Exception do
    begin
      TtfPopBox.ShowBox(e.Message);
    end;
  end;
//  FilterGraph1.Pause;
//  Exit;
//  try
//    mp1.Pause;
//  except
//    on e:Exception do
//    begin
//      TtfPopBox.ShowBox(e.Message);
//    end;
//  end;
end;

procedure TFrmQueryCallRecord.btnPlayClick(Sender: TObject);
//var
//  strFile:string;
//begin
//  try
//    mp1.Close;
//    strFile :=  GlobalDM.AppPath + 'CallRecord\1.wav' ;
//    if Self.GetVoiceFile(strFile) = False then
//    begin
//      TtfPopBox.ShowBox('无录音文件!');
//      Exit;
//    end;
//    m_RoomCallApp.CallDevOp.CallCtl.SetPlayMode(2);
//    mp1.FileName := strFile;
//    mp1.Open;
//    mp1.Play;
//  except
//    on e:Exception do
//    begin
//      TtfPopBox.ShowBox(e.Message);
//    end;
//  end;
//end;
var
  strFile:string;
begin
  btnPlay.Enabled := false;
  if FilterGraph1.State = gsPaused then
  begin
    FilterGraph1.Play;
    exit;
  end;

  if FilterGraph1.State = gsPlaying then
  begin
    FilterGraph1.Stop;
  end;
  if not FilterGraph1.Active then
  begin
    FilterGraph1.Active := true;
  end;


  try
    //mp1.Close;
    strFile :=  GlobalDM.AppPath + 'CallRecord\1.wav' ;
    if Self.GetVoiceFile(strFile) = False then
    begin
      TtfPopBox.ShowBox('无录音文件!');
      Exit;
    end;

    FilterGraph1.RenderFile(strFile);
    m_RoomCallApp.CallDevOp.CallCtl.SetPlayMode(2);
    FilterGraph1.Play;

    //mp1.FileName := strFile;
    //mp1.Open;
   // mp1.Play;
  except
    on e:Exception do
    begin
      TtfPopBox.ShowBox(e.Message);
    end;
  end;
end;

procedure TFrmQueryCallRecord.btnQueryClick(Sender: TObject);
begin
  ReFreashData;
end;

procedure TFrmQueryCallRecord.btnStopClick(Sender: TObject);
begin
  try
    FilterGraph1.Stop;
    FilterGraph1.ClearGraph;
    DSTrackBar1.Position := 0;
    Exit;
  except
    on e:Exception do
    begin
      TtfPopBox.ShowBox(e.Message);
    end;
  end;

//  Exit;
//  try
//    mp1.Stop;
//  except
//    on e:Exception do
//    begin
//      TtfPopBox.ShowBox(e.Message);
//    end;
//  end;
end;

procedure TFrmQueryCallRecord.ClearGird;
begin
  with GridCallRecord do
  begin
    ClearRows(1, 10000);
    if m_CallManList.Count = 0 then
      RowCount := 2
    else
      RowCount := m_CallManList.Count+1 ;
  end;
end;

procedure TFrmQueryCallRecord.FillGird;
var
  i:Integer;
begin
  ClearGird();
  for i := 0 to m_CallManList.Count- 1 do
  begin
    FillGridLine(i+1,m_CallManList.Items[i]);
  end;
end;

procedure TFrmQueryCallRecord.FillGridLine(nRow: Integer; CallRecord: TCallManRecord);
begin
  GridCallRecord.Cells[0,nRow] := IntToStr(nRow);
  GridCallRecord.Cells[1,nRow] := CallRecord.strRoomNum;
  GridCallRecord.Cells[2,nRow] := CallRecord.strTrainNo;
  //GridCallRecord.Cells[3,nRow] := CallRecord.strTrainmanNumber;
  GridCallRecord.Cells[3,nRow] := CallRecord.strTrainmanName;
  GridCallRecord.Cells[4,nRow] := TRoomCallStateNameAry[CallRecord.eCallState];
  GridCallRecord.Cells[5,nRow] := TRoomCallTypeNameAry[CallRecord.eCallType];
  GridCallRecord.Cells[6,nRow] := TPubFun.DateTime2Str(CallRecord.dtCallTime);
  GridCallRecord.Cells[7,nRow] := TPubFun.DateTime2Str(CallRecord.dtCreateTime);
  GridCallRecord.Cells[8,nRow] := IntToStr(CallRecord.nConTryTimes + 1);
  GridCallRecord.Cells[9,nRow] := TRoomCallResultNameAry[CallRecord.eCallResult];
  //GridCallRecord.Cells[11,nRow] :=CallRecord.strMsg;
end;

procedure TFrmQueryCallRecord.FormCreate(Sender: TObject);
begin
  m_RoomCallApp := TRoomCallApp.GetInstance();
  m_CallManList:=TCallManRecordList.Create;
  dtpStart.DateTime := DateOf(Now);
  dtpEnd.DateTime := DateOf(Now)+1;
end;

procedure TFrmQueryCallRecord.FormDestroy(Sender: TObject);
begin
  m_CallManList.Free;
end;

function TFrmQueryCallRecord.GetSelectRecord(var callRecord:TCallManRecord): Boolean;
var
  nRealRow:Integer;
begin
  result := False;
  nRealRow := GridCallRecord.RealRow;
  if ( nRealRow >= 1) and (nRealRow <= m_CallManList.Count) then
  begin
    callRecord := m_CallManList.Items[nRealRow -1];
    result :=true;
  end;
  
end;




function TFrmQueryCallRecord.GetVoiceFile(strFile:string): Boolean;
var
  callRecord:TCallManRecord;
  callVoice:TCallVoice;
begin
  result := False;
  if GetSelectRecord(callRecord) = False then
  begin
    TtfPopBox.ShowBox('未选取有效的记录行');
    Exit;
  end;

  callVoice:=TCallVoice.Create;
  try
    if m_RoomCallApp.DBCallVoice.Find(callRecord.strCallVoiceGUID,callVoice) = False then
    begin
      TtfPopBox.ShowBox('无叫班录音');
      Exit;
    end;

    //检查文件是否存在
    if FileExists(callVoice.strFilePathName) then
    begin
      callVoice.vms.SaveToFile(strFile);
    end
    else
    begin
      //如果文件不存在，则修正一下目录，然后在重新再检测一下文件是否存在
      m_RoomCallApp.DBCallVoice.ModifyVicePath(callVoice.strCallVoiceGUID, GlobalDM.AppPath);

      if m_RoomCallApp.DBCallVoice.Find(callRecord.strCallVoiceGUID,callVoice) = False then
      begin
        TtfPopBox.ShowBox('无叫班录音');
        Exit;
      end;

      if FileExists(callVoice.strFilePathName) then
      begin
        callVoice.vms.SaveToFile(strFile);
      end
      else
      begin
        TtfPopBox.ShowBox('录音文件未找到!');
        Exit;
      end;
    end;
  finally
    callVoice.Free;
  end;

  result := True;
end;


procedure TFrmQueryCallRecord.QueryData;
var
  params:RCallQryParams;
begin
  Self.SetQueryParams(params);
  m_CallManList.Clear;
  m_RoomCallApp.DBCallRecord.qryCallRecord(params,m_CallManList);
  FillGird();
end;

procedure TFrmQueryCallRecord.ReFreashData;
begin
  QueryData();
  FillGird();
end;

procedure TFrmQueryCallRecord.SetQueryParams(var params:RCallQryParams);
begin
  params.strTrainNo := UpperCase(Trim(edtTrainNo.Text));
  params.strRoomNum := Trim(edtRoom.Text);
  params.dtStartCallTime := dtpStart.DateTime;
  params.dtEndCallTime := dtpEnd.DateTime;
end;

class procedure TFrmQueryCallRecord.ShowCallRecordFrm(parentFrm:TForm);
var
  frm:TFrmQueryCallRecord;
begin
  frm:=TFrmQueryCallRecord.Create(nil);
  try
    if parentFrm = nil then
    begin
      frm.BorderStyle := bsSizeable;
    end
    else
    begin
      frm.Parent := parentFrm;
    end;
    frm.ShowModal;
  finally
    frm.Free;
  end;
  
end;




procedure TFrmQueryCallRecord.Timer1Timer(Sender: TObject);
begin
  btnPlay.Enabled := true;
  btnPause.Enabled := false;
  btnStop.Enabled := false;
  if FilterGraph1.Active then
  begin
    if FilterGraph1.State = gsPlaying then
    begin
      btnPlay.Enabled := false;
      btnPause.Enabled := true;
      btnStop.Enabled := true;
    end;
    if FilterGraph1.State = gsStopped then
    begin
      btnPlay.Enabled := true;
      btnPause.Enabled := false;
      btnStop.Enabled := false;
    end;
    if FilterGraph1.State = gsPaused then
    begin
      btnPlay.Enabled := true;
      btnPause.Enabled := false;
      btnStop.Enabled := true;
    end;
  end;
end;

end.
