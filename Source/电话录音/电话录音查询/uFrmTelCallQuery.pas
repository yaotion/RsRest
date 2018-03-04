unit uFrmTelCallQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, AdvObj, BaseGrid, AdvGrid, MPlayer, ComCtrls,
  AdvDateTimePicker, StdCtrls, Buttons, PngCustomButton, RzPanel,uTelRecord,uRecordTelUtil;

type
  TFrmTelCallQuery = class(TForm)
    RzPnlTop: TRzPanel;
    lbl1: TLabel;
    Label1: TLabel;
    lbl: TLabel;
    Label2: TLabel;
    btnPlay: TPngCustomButton;
    btnPause: TPngCustomButton;
    btnStop: TPngCustomButton;
    btnQuery: TPngCustomButton;
    btnExportWav: TPngCustomButton;
    edtNumber: TEdit;
    dtpStart: TAdvDateTimePicker;
    dtpEnd: TAdvDateTimePicker;
    mp1: TMediaPlayer;
    rzpnlBody: TRzPanel;
    GridCallRecord: TAdvStringGrid;
    dlgOpen1: TOpenDialog;
    cmbCallType: TComboBox;
    Label3: TLabel;
    cmbDailedType: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnExportWavClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    m_TelRecordList:TTelRecordList;
    m_RecordTelUtil :TRecordTelUtil;
  private
    { Private declarations }
        {功能:填充数据行}
    procedure FillGridLine(nRow:Integer;TelRecord:TTelRecord);
        {功能:清空列表}
    procedure ClearGird();
    {功能:填充数据}
    procedure FillGird();
    {功能:查询数据}
    procedure QueryData();
        {功能:获取选中记录}
    function GetSelectRecord(var TelRecord:TTelRecord):Boolean;
  public
    { Public declarations }
        {更新数据}
    procedure ReFreashData();
    {功能:显示叫班记录查询窗体}
    class procedure ShowCallRecordFrm(parentFrm:TForm);
  end;

var
  FrmTelCallQuery: TFrmTelCallQuery;

implementation
uses
  uGlobalDM,utfPopBox,DateUtils,uTFSystem  ;

{$R *.dfm}

procedure TFrmTelCallQuery.btnExportWavClick(Sender: TObject);
var
  strWavFile:string;
  TelRecord:TTelRecord;
begin
  if not dlgOpen1.Execute then exit;
  strWavFile := dlgOpen1.FileName;
  if GetSelectRecord(TelRecord) = False then
  begin
    TtfPopBox.ShowBox('未选取有效的记录行');
    Exit;
  end;

  if tbox('源文件已经存在是否覆盖') then
  begin

    CopyFile(pansichar(TelRecord.strFileName),pansichar(strWavFile),false);
    TtfPopBox.ShowBox('导出成功!');
  end;
end;

procedure TFrmTelCallQuery.btnPauseClick(Sender: TObject);
begin
  try
    mp1.Pause;
  except
    on e:Exception do
    begin
      TtfPopBox.ShowBox(e.Message);
    end;
  end;
end;

procedure TFrmTelCallQuery.btnPlayClick(Sender: TObject);
var
  strFile:string;
  TelRecord:TTelRecord;
begin
  if GetSelectRecord(TelRecord) = False then
  begin
    TtfPopBox.ShowBox('未选取有效的记录行');
    Exit;
  end;

  if TelRecord.strFileName = '' then
  begin
    TtfPopBox.ShowBox('不存在该语音文件');
    Exit;
  end;


  try
    mp1.Close;
    strFile := TelRecord.strFileName ;
    mp1.FileName := strFile;
    mp1.Open;
    mp1.Play;
  except
    on e:Exception do
    begin
      TtfPopBox.ShowBox(e.Message);
    end;
  end;
end;

procedure TFrmTelCallQuery.btnQueryClick(Sender: TObject);
begin
  ReFreashData;
end;

procedure TFrmTelCallQuery.btnStopClick(Sender: TObject);
begin
  try
    mp1.Stop;
  except
    on e:Exception do
    begin
      TtfPopBox.ShowBox(e.Message);
    end;
  end;
end;

procedure TFrmTelCallQuery.ClearGird;
begin
  with GridCallRecord do
  begin
    ClearRows(1, 10000);
    if m_TelRecordList.Count = 0 then
      RowCount := 2
    else
      RowCount := m_TelRecordList.Count+1 ;
  end;
end;

procedure TFrmTelCallQuery.FillGird;
var
  i:Integer;
begin
  ClearGird();
  for i := 0 to m_TelRecordList.Count- 1 do
  begin
    FillGridLine(i+1,m_TelRecordList.Items[i]);
  end;
end;

procedure TFrmTelCallQuery.FillGridLine(nRow: Integer; TelRecord: TTelRecord);
var
  strText : string ;
  index:integer ;
begin
  index := 0 ;
  GridCallRecord.Cells[index,nRow] := IntToStr(nRow);
  inc(index);
  GridCallRecord.Cells[index,nRow] := formatdatetime('yyyy-MM-dd hh:mm:ss', TelRecord.dtStartTime);
  inc(index);
  GridCallRecord.Cells[index,nRow] := formatdatetime('yyyy-MM-dd hh:mm:ss', TelRecord.dtEndTime);
    inc(index);
  GridCallRecord.Cells[index,nRow] := formatdatetime('hh:mm:ss', TelRecord.dtEndTime-TelRecord.dtStartTime);
  inc(index);

  if TelRecord.bIsDialed  then
    strText := '已接'
  else
  begin
    strText :=  '未接' ;
    gridCallRecord.RowColor[nRow] := clred;
  end;
  GridCallRecord.Cells[index,nRow] := strText ;



  inc(index);
  
  if TelRecord.nCallDirection = 0 then
    strText := '主叫'
  else
    strText :=  '被叫' ;
  GridCallRecord.Cells[index,nRow] := strText ;
  inc(index);
  GridCallRecord.Cells[index,nRow] := TelRecord.strDestTel;
  inc(index);
  GridCallRecord.Cells[index,nRow] := TelRecord.strUserNumber;
  inc(index);
  GridCallRecord.Cells[index,nRow] := TelRecord.strUserName;
  inc(index);
  GridCallRecord.Cells[index,nRow] :=  ExtractFileName ( TelRecord.strFileName );
  inc(index);
end;

procedure TFrmTelCallQuery.FormCreate(Sender: TObject);
begin
  dtpStart.DateTime := DateOf(Now);
  dtpEnd.DateTime := DateOf(Now)+1;

    m_TelRecordList:=TTelRecordList.Create;
    m_RecordTelUtil := TRecordTelUtil.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmTelCallQuery.FormDestroy(Sender: TObject);
begin
  m_TelRecordList.Free;
  m_RecordTelUtil.Free;
end;

function TFrmTelCallQuery.GetSelectRecord(var TelRecord: TTelRecord): Boolean;
var
  nRealRow:Integer;
begin
  result := False;
  nRealRow := GridCallRecord.RealRow;
  if ( nRealRow >= 1) and (nRealRow <= m_TelRecordList.Count) then
  begin
    TelRecord := m_TelRecordList.Items[nRealRow -1];
    result :=true;
  end;
end;

procedure TFrmTelCallQuery.QueryData;
var
  TelRecordQueryCond:TTelRecordQueryCond ;
begin
  with  TelRecordQueryCond do
  begin
    StartDate := dtpStart.DateTime ;
    EndDate := dtpEnd.DateTime ;
    UserNumber :=  Trim(edtNumber.Text);
    if cmbCallType.Text = '全部' then
      CallDirection := -1
    else
     CallDirection :=  cmbCallType.ItemIndex - 1 ;


    if cmbDailedType.Text = '全部' then
      DailedType := -1
    else
      DailedType :=  cmbDailedType.ItemIndex - 1 ;
  end;

  m_TelRecordList.Clear;
  m_RecordTelUtil.Query(TelRecordQueryCond,m_TelRecordList);
end;

procedure TFrmTelCallQuery.ReFreashData;
begin
  QueryData();
  FillGird();
end;

class procedure TFrmTelCallQuery.ShowCallRecordFrm(parentFrm: TForm);
var
  frm:TFrmTelCallQuery;
begin
  frm:=TFrmTelCallQuery.Create(nil);
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

end.
