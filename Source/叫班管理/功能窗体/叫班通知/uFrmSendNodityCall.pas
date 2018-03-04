unit uFrmSendNodityCall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, ExtCtrls, RzPanel, StdCtrls,
  ComCtrls, AdvDateTimePicker, RzLabel,uDBRoomCall,uRoomCall,uGlobalDM, Buttons,
  PngSpeedButton,uCallNotify,uDBCallNotify,uSaftyEnum,DateUtils,uPubFun,uTFSystem,
  ufrmTextInput;

type

  TColIndex = (cl_Index,cl_State,cl_Cancel,cl_CheCi,cl_CallTime,cl_ChuQinTime,
    cl_TM,cl_NotifyContent, cl_SendUser,cl_NotifyTime,cl_RecvUser,cl_RecvTime,
    cl_CancelUser,cl_CancelTime,cl_CancelReason);
    
  TFrmSendNotifyCall = class(TForm)
    rzpnl2: TRzPanel;
    GridNotifyCall: TAdvStringGrid;
    rzpnl3: TRzPanel;
    btnRefreshPaln: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    lbl1: TLabel;
    dtpStart: TAdvDateTimePicker;
    chkHideCancel: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRefreshPalnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure chkHideCancelClick(Sender: TObject);
  private
    //�а�֪ͨ���ݿ����
    m_DBCallNotify:TDBCallNotify;
    //�а�֪ͨ����
    m_CallNotifyAry:TRSCallNotifyAry;

  private
    {����:��ʼ�����}
    procedure InitGrid(nCount:Integer);
    {����:�����}
    procedure FillGrid();
    {����:�����}
    procedure FillLine(nRow:Integer;callNotify:RRsCallNotify);
    {����:����֪ͨ}
    procedure SendNotify();
    {����:ˢ��}
    procedure RefreshData();
    {����:ȡ��֪ͨ}
    procedure CancelNotify();
    {����:��ʽ����ʾ�Ƿ�ȡ��}
    function Fmt2Yes(nCancel:Integer):String;
    {����:��ȡѡ��֪ͨ}
    function GetSelectNotify(out CallNotify:RRsCallNotify):Integer; 
  end;

  {����:��ʾ���ͽа�֪ͨ����}
  procedure ShowSendCallNotifyFrm();

implementation

uses
  utfPopBox ;

{$R *.dfm}
procedure ShowSendCallNotifyFrm();
var
  frm :TFrmSendNotifyCall;
begin
  frm := TFrmSendNotifyCall.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;
{ TFrmRecvCallNodity }


procedure TFrmSendNotifyCall.btnCancelClick(Sender: TObject);
begin
  CancelNotify;
end;

procedure TFrmSendNotifyCall.btnRefreshPalnClick(Sender: TObject);
begin
  RefreshData();
end;

procedure TFrmSendNotifyCall.CancelNotify;
var
  callNotify:RRsCallNotify;
  strReason:string;
begin
  if GetSelectNotify(callNotify) = -1 then
  begin
    TtfPopBox.ShowBox('δѡ����Ч��!');
    Exit;
  end;
  if TextInput('��ʾ!','���볷��ԭ��:',strReason) = False then Exit;
  
  m_DBCallNotify.SetCancel(callNotify.strMsgGUID,GlobalDM.DutyUser.strDutyName,
       GlobalDM.GetNow,strReason );
  RefreshData;
end;

procedure TFrmSendNotifyCall.chkHideCancelClick(Sender: TObject);
begin
  RefreshData();
end;

procedure TFrmSendNotifyCall.FillGrid;
var
  i:Integer;
begin
  InitGrid(Length(m_CallNotifyAry));
  for i := 0 to Length(m_CallNotifyAry) - 1 do
  begin
    FillLine(i+1,m_CallNotifyAry[i]);
  end;
    
end;

procedure TFrmSendNotifyCall.FillLine(nRow: Integer; callNotify:RRsCallNotify);
begin
  with GridNotifyCall do
  begin
    Cells[Ord(cl_Index),nRow] := IntToStr(nRow) ;
    Cells[Ord(cl_State),nRow] := TRsCallWorkStateName[callNotify.eCallState] ;
    Cells[Ord(cl_Cancel),nRow] :=Fmt2Yes(callNotify.nCancel) ;
    Cells[Ord(cl_CheCi),nRow] := callNotify.strTrainNo ;
    Cells[Ord(cl_CallTime),nRow] := TPubFun.DT2StrmmddHHnn(callNotify.dtCallTime) ;
    Cells[Ord(cl_ChuQinTime),nRow] :=TPubFun.DT2StrmmddHHnn(callNotify.dtChuQinTime) ;
    Cells[Ord(cl_TM),nRow] :=TPubFun.FormatTMNameNum(callNotify.strTrainmanName,callNotify.strTrainmanNumber) ;
    Cells[Ord(cl_NotifyContent),nRow] := callNotify.strSendMsgContent ;
    Cells[Ord(cl_SendUser),nRow] := callNotify.strSendUser ;
    Cells[Ord(cl_NotifyTime),nRow] :=TPubFun.DT2StrmmddHHnn(callNotify.dtSendTime) ;
    Cells[Ord(cl_RecvUser),nRow] := callNotify.strRecvUser ;
    Cells[Ord(cl_RecvTime),nRow] := TPubFun.DT2StrmmddHHnn(callNotify.dtRecvTime) ;
    Cells[Ord(cl_CancelUser),nRow] :=  callNotify.strCancelUser ;
    Cells[Ord(cl_CancelTime),nRow] :=TPubFun.DT2StrmmddHHnn(callNotify.dtCancelTime) ;
    Cells[Ord(cl_CancelReason),nRow] := callNotify.strCancelReason ;
  end;
end;

function TFrmSendNotifyCall.Fmt2Yes(nCancel: Integer): String;
begin
  result := '';
  if nCancel = 1 then
    result := '��'
end;

procedure TFrmSendNotifyCall.FormCreate(Sender: TObject);
begin
  m_DBCallNotify := TDBCallNotify.Create(GlobalDM.ADOConnection);
  dtpStart.DateTime := IncMinute(GlobalDM.GetNow,-(60*4));
end;

procedure TFrmSendNotifyCall.FormDestroy(Sender: TObject);
begin
  m_DBCallNotify.Free;
end;



procedure TFrmSendNotifyCall.FormShow(Sender: TObject);
begin
  RefreshData();
end;

function TFrmSendNotifyCall.GetSelectNotify(
  out CallNotify: RRsCallNotify): Integer;
var
  nIndex:Integer;
begin
  result:= -1;
  nIndex := GridNotifyCall.Row -1;
  if (nIndex >= 0) and (nIndex < Length(m_CallNotifyAry)) then
  begin
    CallNotify := m_CallNotifyAry[nIndex];
    Result := nIndex;
  end;
  
end;

procedure TFrmSendNotifyCall.InitGrid(nCount: Integer);
begin
  With GridNotifyCall do
  begin
    ClearRows(1,10000);
    if nCount > 0  then
      RowCount := nCount + 1
    else
    begin
      RowCount := 2;
      Cells[99,1] := ''
    end;
  end;
end;

procedure TFrmSendNotifyCall.RefreshData;
begin
  m_DBCallNotify.GetByStateSec(m_CallNotifyAry,cwsNotify,cwsFinish,dtpStart.DateTime,chkHideCancel.checked);
  FillGrid();
end;

procedure TFrmSendNotifyCall.SendNotify;
begin
  
end;

end.
